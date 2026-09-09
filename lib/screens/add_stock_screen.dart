import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewellary_stock/theme/app_theme.dart';
import '../blocs/transaction/transaction_cubit.dart';
import '../data/models/transaction_model.dart';
import '../blocs/customer/customer_cubit.dart';
import '../data/models/customer_model.dart';

class AddStockScreen extends StatefulWidget {
  final String? customerId;
  final TransactionType? initialTransactionType;
  final String? initialLinkedTransactionId;

  const AddStockScreen({
    super.key,
    this.customerId,
    this.initialTransactionType,
    this.initialLinkedTransactionId,
  });

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final weightController = TextEditingController();
  final amountController = TextEditingController();
  final remarkController = TextEditingController();
  final dateController = TextEditingController();
  final wastageController = TextEditingController();
  final stoneController = TextEditingController();
  final goldRateController = TextEditingController();
  final makingChargesController = TextEditingController();
  final linkedTransactionIdController = TextEditingController();
  final purityFinalController = TextEditingController();

  DateTime? selectedDate;
  String? selectedCustomerId;

  late TransactionType stockType;
  MetalType stockItemType = MetalType.gold;
  CurrencyType currencyType = CurrencyType.inr;
  MakingChargeType? selectedMakingChargeType;

  @override
  void initState() {
    super.initState();

    stockType =
        widget.initialTransactionType ?? TransactionType.purchase;

    selectedCustomerId = widget.customerId;

    if (widget.initialLinkedTransactionId != null) {
      linkedTransactionIdController.text =
      widget.initialLinkedTransactionId!;
    }

    weightController.addListener(_calculateAmount);
    goldRateController.addListener(_calculateAmount);

    weightController.addListener(_calculatePurityFinal);
    wastageController.addListener(_calculatePurityFinal);
    stoneController.addListener(_calculatePurityFinal);

    context.read<CustomerCubit>().fetchCustomers();
  }

  // ---------------- CALCULATIONS ----------------

  void _calculateAmount() {
    if (stockType == TransactionType.cashJama ||
        stockType == TransactionType.cashNamae ||
        stockType == TransactionType.metalJama ||
        stockType == TransactionType.metalNamae) {
      final weight = double.tryParse(
        weightController.text.trim(),
      );

      final rate = double.tryParse(
        goldRateController.text.trim(),
      );

      if (weight != null && rate != null) {
        final newAmount =
        (weight * rate).toStringAsFixed(2);

        if (amountController.text != newAmount) {
          amountController.text = newAmount;
        }
      }
    }
  }

  void _calculatePurityFinal() {
    final weight = double.tryParse(
      weightController.text.trim(),
    );

    final wastage = double.tryParse(
      wastageController.text.trim(),
    );

    final stone =
    stockItemType == MetalType.jewellery
        ? double.tryParse(
      stoneController.text.trim(),
    )
        : null;

    if (weight != null && wastage != null) {
      final netWeight = weight - (stone ?? 0);
      final finalW =
          netWeight * (wastage / 100);

      final newFinal =
      finalW.toStringAsFixed(2);

      if (purityFinalController.text != newFinal) {
        purityFinalController.text = newFinal;
      }
    } else {
      if (purityFinalController.text.isNotEmpty) {
        purityFinalController.text = "";
      }
    }
  }

  // ---------------- COMMON TEXT FIELD UI ----------------

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputformatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputformatters,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.gold,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // --------------------REMARKS WIDGET ------------------

  Widget buildTextFieldRemarks({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
    int? maxlength,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputformatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxlength ?? 100,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputformatters,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        suffixIcon: suffixIcon,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFFE6D8A8),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppTheme.gold,
            width: 1.5,
          ),
        ),
      ),
    );
  }




  // ---------------- COMMON DROPDOWN UI ----------------

  InputDecoration dropdownDecoration({
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE6D8A8),
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE6D8A8),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppTheme.gold,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    weightController.dispose();
    amountController.dispose();
    remarkController.dispose();
    dateController.dispose();
    wastageController.dispose();
    stoneController.dispose();
    goldRateController.dispose();
    makingChargesController.dispose();
    linkedTransactionIdController.dispose();
    purityFinalController.dispose();

    super.dispose();
  }


  //--------------FOR THE HEADING AND ASTERISK--------------
  Widget buildFieldTitle(String title, String required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                color: AppTheme.goldDark,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: required,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: kBg,

        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios,
              ),
            ),

            const Expanded(
              child: Center(
                child: Text(
                  "Transaction Entry",
                ),
              ),
            ),
          ],
        ),
      ),

      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionCreated) {
            context
                .read<CustomerCubit>()
                .fetchCustomers();

            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  "Transaction Saved Successfully",
                ),
              ),
            );

            Navigator.pop(context);
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),


                buildFieldTitle("Transaction Type", ' *'),

                const SizedBox(height: 8),

                // ---------------- TRANSACTION TYPE ----------------

                DropdownButtonFormField<TransactionType>(
                  initialValue: stockType,
                  isExpanded: true,
                  dropdownColor: Colors.white,

                  decoration:
                  dropdownDecoration(),

                  items: const [
                    DropdownMenuItem(
                      value:
                      TransactionType.purchase,
                      child: Text("PURCHASE"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.purchaseReturn,
                      child:
                      Text("PURCHASE RETURN"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.sales,
                      child: Text("SALE"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.salesReturn,
                      child:
                      Text("SALE RETURN"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.cashJama,
                      child: Text("CASH JAMA"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.cashNamae,
                      child: Text("CASH NAMAE"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.metalJama,
                      child: Text("METAL"),
                    ),
                    DropdownMenuItem(
                      value:
                      TransactionType.metalNamae,
                      child: Text("METAL NAMAE"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      stockType = value!;

                      if (stockType !=
                          TransactionType
                              .cashJama &&
                          stockType !=
                              TransactionType
                                  .cashNamae &&
                          stockType !=
                              TransactionType
                                  .metalJama &&
                          stockType !=
                              TransactionType
                                  .metalNamae) {
                        amountController.clear();
                      }
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ---------------- CUSTOMER ----------------

                buildFieldTitle("Customer", ' *'),

                const SizedBox(height: 8),

                BlocBuilder<CustomerCubit,
                    CustomerState>(
                  builder:
                      (context, customerState) {
                    List<CustomerModel> customers =
                    [];

                    if (customerState
                    is CustomerLoaded) {
                      customers =
                          customerState.customers;
                    }

                    String? dropdownValue =
                        selectedCustomerId;

                    if (!customers.any(
                          (c) => c.id == dropdownValue,
                    )) {
                      dropdownValue = null;
                    }

                    return DropdownButtonFormField<
                        String>(
                      initialValue: dropdownValue,
                      isExpanded: true,
                      dropdownColor: Colors.white,

                      decoration:
                      dropdownDecoration(
                        hintText:
                        "Select Customer",
                      ),

                      items: customers
                          .map(
                            (c) =>
                            DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                c.name,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            ),
                      )
                          .toList(),

                      onChanged: (value) {
                        setState(() {
                          selectedCustomerId =
                              value;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ---------------- METAL TYPE ----------------
                buildFieldTitle("Metal Type", ' *'),

                const SizedBox(height: 8),

                DropdownButtonFormField<MetalType>(
                  initialValue: stockItemType,
                  isExpanded: true,
                  dropdownColor: Colors.white,

                  decoration:
                  dropdownDecoration(),

                  items: const [
                    DropdownMenuItem(
                      value: MetalType.gold,
                      child: Text("Gold"),
                    ),
                    DropdownMenuItem(
                      value: MetalType.jewellery,
                      child:
                      Text("Jewellery"),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      stockItemType = value!;

                      if (stockItemType ==
                          MetalType.gold) {
                        stoneController.clear();
                        makingChargesController
                            .clear();
                        selectedMakingChargeType =
                        null;
                      }

                      _calculatePurityFinal();
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ---------------- WEIGHT ----------------

                Text(
                  (stockType ==
                      TransactionType
                          .cashJama ||
                      stockType ==
                          TransactionType
                              .cashNamae)
                      ? "Weight (Gram) - Optional for settlement"
                      : "Weight (Gram) *",
                  style: const TextStyle(
                    color: AppTheme.goldDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                buildTextField(
                  controller: weightController,
                  hint: "0.0gm",
                  keyboardType:
                  TextInputType.number,
                ),

                // ---------------- SETTLEMENT GOLD RATE ----------------

                if (stockType ==
                    TransactionType
                        .metalJama ||
                    stockType ==
                        TransactionType
                            .metalNamae ||
                    stockType ==
                        TransactionType
                            .cashJama ||
                    stockType ==
                        TransactionType
                            .cashNamae) ...[
                  const SizedBox(height: 16),

                  const Text(
                    "Gold Rate (₹/g) - for settlement",
                    style: TextStyle(
                      color: AppTheme.goldDark,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller:
                    goldRateController,
                    hint:
                    "Enter Gold Rate (optional)",
                    keyboardType:
                    TextInputType.number,
                  ),
                ],

                // ---------------- PURCHASE / SALES ----------------

                if (stockType ==
                    TransactionType
                        .purchase ||
                    stockType ==
                        TransactionType
                            .sales ||
                    stockType ==
                        TransactionType
                            .purchaseReturn ||
                    stockType ==
                        TransactionType
                            .salesReturn) ...[
                  const SizedBox(height: 16),

                  buildFieldTitle("Purity (%)", ' *'),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller:
                    wastageController,
                    hint: "0%",
                    keyboardType:
                    TextInputType.number,
                  ),

                  // ---------------- STONE ----------------

                  if (stockItemType ==
                      MetalType.jewellery) ...[
                    const SizedBox(height: 16),

                    const Text(
                      "Stone (Gram)",
                      style: TextStyle(
                        color:
                        AppTheme.goldDark,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    buildTextField(
                      controller:
                      stoneController,
                      hint:
                      "0.0gm",
                      keyboardType:
                      TextInputType.number,
                    ),
                  ],

                  // ---------------- PURITY FINAL ----------------

                  const SizedBox(height: 16),

                  buildFieldTitle("Purity Final (Gram)", ' *'),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller:
                    purityFinalController,
                    hint: "0.0gm",
                    readOnly: true,
                  ),

                  // ---------------- CURRENCY ----------------

                  const SizedBox(height: 16),

                  const Text(
                    "Currency (INR)",
                    style: TextStyle(
                      color: AppTheme.goldDark,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<CurrencyType>(
                    initialValue:
                    currencyType,
                    isExpanded: true,
                    dropdownColor: Colors.white,

                    decoration:
                    dropdownDecoration(),

                    items: const [
                      DropdownMenuItem(
                        value:
                        CurrencyType.inr,
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value:
                        CurrencyType.usd,
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value:
                        CurrencyType.myr,
                        child: Text("MYR"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        currencyType =
                        value!;
                      });
                    },
                  ),

                  // ---------------- GOLD RATE ----------------

                  const SizedBox(height: 16),

                  buildFieldTitle("Gold Rate (gm)", ' *'),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller:
                    goldRateController,
                    hint: "0.0gm",
                    keyboardType:
                    TextInputType.number,
                  ),

                  // ---------------- LINKED TRANSACTION ----------------

                  if (stockType ==
                      TransactionType
                          .salesReturn ||
                      stockType ==
                          TransactionType
                              .purchaseReturn) ...[
                    const SizedBox(height: 16),

                    const Text(
                      "Linked Transaction ID (Optional)",
                      style: TextStyle(
                        color:
                        AppTheme.goldDark,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    buildTextField(
                      controller:
                      linkedTransactionIdController,
                      hint:
                      "Original transaction ID for exact calculations",
                    ),
                  ],

                  // ---------------- MAKING CHARGES ----------------

                  if (stockType !=
                      TransactionType
                          .salesReturn &&
                      stockType !=
                          TransactionType
                              .purchaseReturn &&
                      stockItemType ==
                          MetalType.jewellery) ...[
                    const SizedBox(height: 16),

                    const Text(
                      "Making Charge Type",
                      style: TextStyle(
                        color:
                        AppTheme.goldDark,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<
                        MakingChargeType>(
                      initialValue:
                      selectedMakingChargeType,
                      isExpanded: true,
                      dropdownColor:
                      Colors.white,

                      decoration:
                      dropdownDecoration(
                        hintText:
                        "Select Making Charge Type",
                      ),

                      items: const [
                        DropdownMenuItem(
                          value:
                          MakingChargeType
                              .percentage,
                          child: Text(
                            "Percentage (%)",
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                          MakingChargeType
                              .perGram,
                          child: Text(
                            "Per Gram (₹/g)",
                          ),
                        ),
                        DropdownMenuItem(
                          value:
                          MakingChargeType
                              .fixed,
                          child: Text(
                            "Fixed Value (₹)",
                          ),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          selectedMakingChargeType =
                              value;
                        });
                      },
                    ),

                    if (selectedMakingChargeType !=
                        null) ...[
                      const SizedBox(height: 16),

                      Text(
                        "Making Charges (${selectedMakingChargeType == MakingChargeType.percentage
                            ? '%'
                            : selectedMakingChargeType ==
                            MakingChargeType.perGram
                            ? '₹/g'
                            : '₹'})",
                        style: const TextStyle(
                          color:
                          AppTheme.goldDark,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      buildTextField(
                        controller:
                        makingChargesController,
                        hint:
                        "Making Charges",
                        keyboardType:
                        TextInputType.number,
                      ),
                    ],
                  ],
                ],

                // ---------------- AMOUNT ----------------

                if (stockType ==
                    TransactionType
                        .cashJama ||
                    stockType ==
                        TransactionType
                            .cashNamae ||
                    stockType ==
                        TransactionType
                            .metalJama ||
                    stockType ==
                        TransactionType
                            .metalNamae) ...[
                  const SizedBox(height: 16),

                  const Text(
                    "Amount (₹)",
                    style: TextStyle(
                      color: AppTheme.goldDark,
                      fontSize: 14,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  buildTextField(
                    controller:
                    amountController,
                    hint: "Amount (₹)",
                    keyboardType:
                    TextInputType.number,
                  ),
                ],

                // ---------------- DATE ----------------

                const SizedBox(height: 16),

                const Text(
                  "Date",
                  style: TextStyle(
                    color: AppTheme.goldDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                buildTextField(
                  controller: dateController,
                  hint: "Date",
                  readOnly: true,
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                  ),
                  onTap: () async {
                    DateTime? pickedDate =
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                      DateTime(2020),
                      lastDate:
                      DateTime(2050),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate =
                            pickedDate;

                        dateController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),

                // ---------------- REMARKS ----------------

                const SizedBox(height: 16),

                const Text(
                  "Remarks",
                  style: TextStyle(
                    color: AppTheme.goldDark,
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                buildTextFieldRemarks(
                  controller: remarkController,
                  hint: "Remarks",
                  inputformatters: [
                    LengthLimitingTextInputFormatter(100)
                  ],
                  maxLines: 3,
                ),

                const SizedBox(height: 30),

                // ---------------- SAVE ----------------

                if (state is TransactionLoading)
                  const Center(
                    child:
                    CircularProgressIndicator(),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppTheme.gold,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),

                      onPressed: () {
                        // ---------------- REQUIRED FIELD VALIDATION ----------------

                        if (selectedCustomerId == null ||
                            selectedCustomerId!.trim().isEmpty ||
                            selectedCustomerId == "GLOBAL") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Customer selection is required.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Weight is required except for CASH JAMA / CASH NAMAE
                        final isCashSettlement =
                            stockType == TransactionType.cashJama ||
                                stockType == TransactionType.cashNamae;

                        if (!isCashSettlement &&
                            weightController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Weight (Gram) is required.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Purity and Gold Rate are required for
                        // Purchase / Sale / Purchase Return / Sale Return
                        final requiresPurchaseSaleFields =
                            stockType == TransactionType.purchase ||
                                stockType == TransactionType.sales ||
                                stockType == TransactionType.purchaseReturn ||
                                stockType == TransactionType.salesReturn;

                        if (requiresPurchaseSaleFields &&
                            wastageController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Purity (%) is required.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (requiresPurchaseSaleFields &&
                            goldRateController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Gold Rate is required.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // ---------------- EXISTING SAVE LOGIC ----------------

                        final cId = selectedCustomerId!;

                        final weightStr =
                        weightController.text.trim();

                        final amountStr =
                        amountController.text.trim();

                        final remarkStr =
                        remarkController.text.trim();

                        final wastageStr =
                        wastageController.text.trim();

                        final stoneStr =
                        stoneController.text.trim();

                        final goldRateStr =
                        goldRateController.text.trim();

                        final makingChargesStr =
                        makingChargesController.text.trim();

                        final linkedTransactionIdStr =
                        linkedTransactionIdController.text.trim();

                        final isMetalSettlement =
                            stockType == TransactionType.metalJama ||
                                stockType == TransactionType.metalNamae ||
                                stockType == TransactionType.cashJama ||
                                stockType == TransactionType.cashNamae;

                        double? weightVal =
                        weightStr.isNotEmpty
                            ? double.tryParse(weightStr)
                            : null;

                        double? amountVal =
                        (isMetalSettlement &&
                            amountStr.isNotEmpty)
                            ? double.tryParse(amountStr)
                            : null;

                        double? wastageVal =
                        wastageStr.isNotEmpty
                            ? double.tryParse(wastageStr)
                            : null;

                        double? stoneVal =
                        (stockItemType == MetalType.jewellery &&
                            stoneStr.isNotEmpty)
                            ? double.tryParse(stoneStr)
                            : null;

                        double? goldRateVal =
                        goldRateStr.isNotEmpty
                            ? double.tryParse(goldRateStr)
                            : null;

                        double? makingChargesVal =
                        (stockItemType == MetalType.jewellery &&
                            makingChargesStr.isNotEmpty)
                            ? double.tryParse(makingChargesStr)
                            : null;

                        MakingChargeType? makingChargeTypeVal =
                        (stockItemType == MetalType.jewellery)
                            ? selectedMakingChargeType
                            : null;

                        bool hasCalcFields =
                            wastageVal != null ||
                                stoneVal != null ||
                                goldRateVal != null ||
                                makingChargesVal != null ||
                                makingChargeTypeVal != null;

                        context.read<TransactionCubit>().createTransaction(

                          customerId: cId,
                          type: stockType,
                          metalType: stockItemType,
                          weight: weightVal,
                          grossWeight:
                          isMetalSettlement
                              ? null
                              : (hasCalcFields
                              ? weightVal
                              : null),
                          amount: amountVal,
                          remark:
                          remarkStr.isEmpty
                              ? null
                              : remarkStr,
                          purityPercent:
                          isMetalSettlement
                              ? null
                              : wastageVal,
                          stoneWeight:
                          isMetalSettlement
                              ? null
                              : stoneVal,
                          goldRate: goldRateVal,
                          makingChargeType:
                          isMetalSettlement
                              ? null
                              : makingChargeTypeVal,
                          makingChargesValue:
                          isMetalSettlement
                              ? null
                              : makingChargesVal,
                          linkedTransactionId:
                          linkedTransactionIdStr.isEmpty
                              ? null
                              : linkedTransactionIdStr,

                          currency: currencyType,

                        );
                      },

                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}