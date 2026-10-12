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
  final TransactionModel? initialTransaction;

  const AddStockScreen({
    super.key,
    this.customerId,
    this.initialTransactionType,
    this.initialLinkedTransactionId,
    this.initialTransaction,
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
  bool isSettlement = false;

  @override
  void initState() {
    super.initState();

    stockType = widget.initialTransactionType ?? TransactionType.purchase;
    selectedCustomerId = widget.customerId;

    if (widget.initialTransaction != null) {
      final tx = widget.initialTransaction!;
      selectedCustomerId = tx.customerId;
      if (tx.metalType != MetalType.none) {
        stockItemType = tx.metalType;
      }
      currencyType = tx.currency;
      if (tx.weight != null) weightController.text = tx.weight.toString();
      if (tx.purityPercent != null) {
        wastageController.text = tx.purityPercent.toString();
      }
      if (tx.goldRate != null) goldRateController.text = tx.goldRate.toString();
      if (tx.stoneWeight != null && tx.stoneWeight! > 0) {
        stoneController.text = tx.stoneWeight.toString();
      }
      linkedTransactionIdController.text = tx.id;
    } else if (widget.initialLinkedTransactionId != null) {
      linkedTransactionIdController.text = widget.initialLinkedTransactionId!;
    }

    weightController.addListener(_calculateAmountAndPurity);
    goldRateController.addListener(_calculateAmountAndPurity);
    wastageController.addListener(_calculateAmountAndPurity);
    stoneController.addListener(_calculateAmountAndPurity);
    makingChargesController.addListener(() => setState(() {}));

    context.read<CustomerCubit>().fetchCustomers();
  }

  // ---------------- CALCULATIONS ----------------

  void _calculateAmountAndPurity() {
    _calculatePurityFinal();
    _calculateAmount();
    setState(() {});
  }

  void _calculateAmount() {
    if (stockType == TransactionType.metalJama ||
        stockType == TransactionType.metalNamae) {
      if (isSettlement) {
        final weight = double.tryParse(weightController.text.trim());
        final rate = double.tryParse(goldRateController.text.trim());
        if (weight != null && rate != null) {
          final newAmount = (weight * rate).toStringAsFixed(2);
          if (amountController.text != newAmount) {
            amountController.text = newAmount;
          }
        }
      } else {
        if (amountController.text.isNotEmpty) {
          amountController.clear();
        }
      }
    } else if (stockType == TransactionType.cashJama ||
        stockType == TransactionType.cashNamae) {
      if (isSettlement) {
        final amount = double.tryParse(amountController.text.trim());
        final rate = double.tryParse(goldRateController.text.trim());
        if (amount != null && rate != null && rate > 0) {
          final newWeight = (amount / rate).toStringAsFixed(3);
          if (weightController.text != newWeight) {
            weightController.text = newWeight;
          }
        }
      }
    }
  }

  void _calculatePurityFinal() {
    final weight = double.tryParse(weightController.text.trim());
    final wastage = double.tryParse(wastageController.text.trim());
    final stone = stockItemType == MetalType.jewellery
        ? double.tryParse(stoneController.text.trim())
        : null;

    if (weight != null && wastage != null) {
      final netWeight = (weight - (stone ?? 0)) > 0
          ? (weight - (stone ?? 0))
          : 0.0;
      final finalW = netWeight * (wastage / 100);
      final newFinal = finalW.toStringAsFixed(2);

      if (purityFinalController.text != newFinal) {
        purityFinalController.text = newFinal;
      }
    } else {
      if (purityFinalController.text.isNotEmpty) {
        purityFinalController.text = "";
      }
    }
  }

  double _calculateEstimatedTotal() {
    final weight = double.tryParse(weightController.text.trim()) ?? 0;
    final stone = stockItemType == MetalType.jewellery
        ? (double.tryParse(stoneController.text.trim()) ?? 0)
        : 0.0;
    final purity = double.tryParse(wastageController.text.trim()) ?? 0;
    final rate = double.tryParse(goldRateController.text.trim()) ?? 0;

    final netW = (weight - stone) > 0 ? (weight - stone) : 0.0;
    final fineW = netW * (purity / 100.0);
    final priceSegment = fineW * rate;

    double making = 0.0;
    if (stockItemType == MetalType.jewellery &&
        selectedMakingChargeType != null) {
      final mcVal = double.tryParse(makingChargesController.text.trim()) ?? 0;
      if (selectedMakingChargeType == MakingChargeType.percentage) {
        making = priceSegment * (mcVal / 100.0);
      } else if (selectedMakingChargeType == MakingChargeType.perGram) {
        making = fineW * mcVal;
      } else if (selectedMakingChargeType == MakingChargeType.fixed) {
        making = mcVal;
      }
    }

    return priceSegment + making;
  }

  // ---------------- COMMON TEXT FIELD UI ----------------

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
        ),
      ),
    );
  }

  Widget buildTextFieldRemarks({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
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
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
      ),
    );
  }

  void _showCustomerSearchPicker(
    BuildContext context,
    List<CustomerModel> customers,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => _CustomerSearchSheet(
        customers: customers,
        selectedCustomerId: selectedCustomerId,
        onSelected: (customerId) {
          setState(() {
            selectedCustomerId = customerId;
          });
        },
      ),
    );
  }

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
              style: const TextStyle(color: Colors.red),
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    final isCashType =
        stockType == TransactionType.cashJama ||
        stockType == TransactionType.cashNamae;
    final isMetalType =
        stockType == TransactionType.metalJama ||
        stockType == TransactionType.metalNamae;
    final isPurchaseOrSale =
        stockType == TransactionType.purchase ||
        stockType == TransactionType.sales ||
        stockType == TransactionType.purchaseReturn ||
        stockType == TransactionType.salesReturn;
    final isReturn =
        stockType == TransactionType.purchaseReturn ||
        stockType == TransactionType.salesReturn;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: kBg,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios),
            ),
            const Expanded(child: Center(child: Text("Transaction Entry"))),
          ],
        ),
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionCreated) {
            context.read<CustomerCubit>().fetchCustomers();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Transaction Saved Successfully")),
            );
            Navigator.pop(context);
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ---------------- TRANSACTION TYPE ----------------
                buildFieldTitle("Transaction Type", ' *'),
                const SizedBox(height: 8),
                DropdownButtonFormField<TransactionType>(
                  initialValue: stockType,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  decoration: dropdownDecoration(),
                  items: const [
                    DropdownMenuItem(
                      value: TransactionType.purchase,
                      child: Text("PURCHASE"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.purchaseReturn,
                      child: Text("PURCHASE RETURN"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.sales,
                      child: Text("SALE"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.salesReturn,
                      child: Text("SALE RETURN"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.cashJama,
                      child: Text("CASH JAMA"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.cashNamae,
                      child: Text("CASH NAMAE"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.metalJama,
                      child: Text("METAL"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.metalNamae,
                      child: Text("METAL NAMAE"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      stockType = value!;
                      isSettlement = false;
                      amountController.clear();
                      weightController.clear();
                      goldRateController.clear();
                      _calculateAmountAndPurity();
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ---------------- CUSTOMER ----------------
                buildFieldTitle("Customer", ' *'),
                const SizedBox(height: 8),
                BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, customerState) {
                    List<CustomerModel> customers = [];
                    if (customerState is CustomerLoaded) {
                      customers = customerState.customers;
                    }

                    CustomerModel? selectedCustomer;
                    if (selectedCustomerId != null) {
                      try {
                        selectedCustomer = customers.firstWhere(
                          (c) => c.id == selectedCustomerId,
                        );
                      } catch (_) {
                        selectedCustomer = null;
                      }
                    }

                    final isLoading =
                        customerState is CustomerLoading && customers.isEmpty;

                    return InkWell(
                      onTap: () {
                        if (isLoading) return;
                        _showCustomerSearchPicker(context, customers);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: InputDecorator(
                        decoration: dropdownDecoration(hintText: ""),
                        isEmpty: selectedCustomer == null,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedCustomer != null
                                    ? '${selectedCustomer.name} (Gold: ${selectedCustomer.goldBalance.toStringAsFixed(2)}g, Cash: ₹${selectedCustomer.cashBalance.toStringAsFixed(0)})'
                                    : 'Select Customer',
                                style: TextStyle(
                                  color: selectedCustomer != null
                                      ? Colors.black87
                                      : AppTheme.muted,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isLoading)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppTheme.gold,
                                  ),
                                ),
                              )
                            else ...[
                              if (selectedCustomer != null)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCustomerId = null;
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: AppTheme.muted,
                                    ),
                                  ),
                                ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: AppTheme.goldDark,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // ---------------- SETTLEMENT TOGGLE (CASH OR METAL) ----------------
                if (isCashType) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSettlement
                            ? AppTheme.gold
                            : const Color(0xFFE6D8A8),
                        width: isSettlement ? 1.5 : 1,
                      ),
                    ),
                    child: SwitchListTile(
                      activeThumbColor: AppTheme.goldDark,
                      title: const Text(
                        "Settle Metal Obligation using Cash",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        "Cash paid clears customer's metal weight debt at agreed rate",
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                      value: isSettlement,
                      onChanged: (val) {
                        setState(() {
                          isSettlement = val;
                          weightController.clear();
                          goldRateController.clear();
                          _calculateAmountAndPurity();
                        });
                      },
                    ),
                  ),
                ],

                if (isMetalType) ...[
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSettlement
                            ? AppTheme.gold
                            : const Color(0xFFE6D8A8),
                        width: isSettlement ? 1.5 : 1,
                      ),
                    ),
                    child: SwitchListTile(
                      activeThumbColor: AppTheme.goldDark,
                      title: const Text(
                        "Settle Cash Due using Metal",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        "Delivered metal weight offsets customer's cash payment due at agreed rate",
                        style: TextStyle(fontSize: 12, color: AppTheme.muted),
                      ),
                      value: isSettlement,
                      onChanged: (val) {
                        setState(() {
                          isSettlement = val;
                          amountController.clear();
                          goldRateController.clear();
                          _calculateAmountAndPurity();
                        });
                      },
                    ),
                  ),
                ],

                // ---------------- METAL TYPE (FOR METAL, SETTLEMENT, PURCHASE/SALE) ----------------
                if (isPurchaseOrSale ||
                    isMetalType ||
                    (isCashType && isSettlement)) ...[
                  const SizedBox(height: 16),
                  buildFieldTitle("Metal Type", ' *'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<MetalType>(
                    initialValue: stockItemType,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    decoration: dropdownDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: MetalType.gold,
                        child: Text("Gold"),
                      ),
                      DropdownMenuItem(
                        value: MetalType.jewellery,
                        child: Text("Jewellery"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        stockItemType = value!;
                        if (stockItemType == MetalType.gold) {
                          stoneController.clear();
                          makingChargesController.clear();
                          selectedMakingChargeType = null;
                        }
                        _calculateAmountAndPurity();
                      });
                    },
                  ),
                ],

                // ---------------- WEIGHT (FOR PURCHASE, SALE, METAL, CASH SETTLEMENT) ----------------
                if (isPurchaseOrSale ||
                    isMetalType ||
                    (isCashType && isSettlement)) ...[
                  const SizedBox(height: 16),
                  buildFieldTitle(
                    (isCashType && isSettlement)
                        ? "Calculated Settled Metal (Gram)"
                        : "Weight (Gram)",
                    ' *',
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: weightController,
                    hint: "0.00 gm",
                    inputformatters: [LengthLimitingTextInputFormatter(8)],
                    keyboardType: TextInputType.number,
                    readOnly: (isCashType && isSettlement),
                  ),
                ],

                // ---------------- AMOUNT (FOR CASH, AND METAL SETTLEMENT) ----------------
                if (isCashType || (isMetalType && isSettlement)) ...[
                  const SizedBox(height: 16),
                  buildFieldTitle(
                    (isMetalType && isSettlement)
                        ? "Calculated Settlement Value (₹)"
                        : "Amount (₹)",
                    ' *',
                  ),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: amountController,
                    hint: "₹ 0.00",
                    inputformatters: [LengthLimitingTextInputFormatter(6)],
                    keyboardType: TextInputType.number,
                    readOnly: (isMetalType && isSettlement),
                  ),
                ],

                // ---------------- GOLD RATE (FOR PURCHASE/SALE AND SETTLEMENTS) ----------------
                if (isPurchaseOrSale || isSettlement) ...[
                  const SizedBox(height: 16),
                  buildFieldTitle("Gold Rate (₹/g)", ' *'),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: goldRateController,
                    hint: "Rate per gram (e.g. 7000)",
                    inputformatters: [LengthLimitingTextInputFormatter(6)],
                    keyboardType: TextInputType.number,
                  ),
                ],

                // ---------------- PURCHASE / SALES DETAIL FIELDS ----------------
                if (isPurchaseOrSale) ...[
                  const SizedBox(height: 16),
                  buildFieldTitle("Purity (%)", ' *'),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: wastageController,
                    hint: "e.g. 91.6%",
                    inputformatters: [LengthLimitingTextInputFormatter(5)],
                    keyboardType: TextInputType.number,
                  ),

                  // Stone Weight (if Jewellery)
                  if (stockItemType == MetalType.jewellery) ...[
                    const SizedBox(height: 16),
                    buildFieldTitle("Stone Weight (Gram)", ''),
                    const SizedBox(height: 8),
                    buildTextField(
                      controller: stoneController,
                      hint: "0.0 gm",
                      inputformatters: [LengthLimitingTextInputFormatter(5)],
                      keyboardType: TextInputType.number,
                    ),
                  ],

                  // Purity Final (Fine Weight)
                  const SizedBox(height: 16),
                  buildFieldTitle("Fine Weight (Gram)", ''),
                  const SizedBox(height: 8),
                  buildTextField(
                    controller: purityFinalController,
                    hint: "0.00 gm",
                    readOnly: true,
                  ),

                  // Currency
                  const SizedBox(height: 16),
                  buildFieldTitle("Currency", ' *'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CurrencyType>(
                    initialValue: currencyType,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    decoration: dropdownDecoration(),
                    items: const [
                      DropdownMenuItem(
                        value: CurrencyType.inr,
                        child: Text("INR (₹)"),
                      ),
                      DropdownMenuItem(
                        value: CurrencyType.usd,
                        child: Text("USD (\$)"),
                      ),
                      DropdownMenuItem(
                        value: CurrencyType.myr,
                        child: Text("MYR (RM)"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        currencyType = value!;
                      });
                    },
                  ),

                  // Linked Transaction for Returns
                  if (isReturn) ...[
                    const SizedBox(height: 16),
                    buildFieldTitle("Linked Transaction ID", ' *'),
                    const SizedBox(height: 8),
                    buildTextField(
                      controller: linkedTransactionIdController,
                      hint: "Original transaction ID required for verification",
                      readOnly: widget.initialLinkedTransactionId != null,
                    ),
                  ],

                  // Making Charges (only if jewellery and not returns)
                  if (!isReturn && stockItemType == MetalType.jewellery) ...[
                    const SizedBox(height: 16),
                    buildFieldTitle("Making Charge Type", ''),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<MakingChargeType>(
                      initialValue: selectedMakingChargeType,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      decoration: dropdownDecoration(
                        hintText: "Select Making Charge Type",
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: MakingChargeType.percentage,
                          child: Text("Percentage (%)"),
                        ),
                        DropdownMenuItem(
                          value: MakingChargeType.perGram,
                          child: Text("Per Gram (₹/g)"),
                        ),
                        DropdownMenuItem(
                          value: MakingChargeType.fixed,
                          child: Text("Fixed Value (₹)"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedMakingChargeType = value;
                          if (value == null) makingChargesController.clear();
                        });
                      },
                    ),

                    if (selectedMakingChargeType != null) ...[
                      const SizedBox(height: 16),
                      buildFieldTitle(
                        "Making Charges (${selectedMakingChargeType == MakingChargeType.percentage
                            ? '%'
                            : selectedMakingChargeType == MakingChargeType.perGram
                            ? '₹/g'
                            : '₹'})",
                        ' *',
                      ),
                      const SizedBox(height: 8),
                      buildTextField(
                        controller: makingChargesController,
                        hint: "Enter Making Charges",
                        inputformatters: [LengthLimitingTextInputFormatter(2)],
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],

                  // Live Estimated Valuation Card
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F6ED),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE6D8A8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.calculate_outlined,
                              color: AppTheme.goldDark,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Estimated Valuation Summary",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldDark,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Fine Weight:",
                              style: TextStyle(color: AppTheme.muted),
                            ),
                            Text(
                              "${purityFinalController.text.isNotEmpty ? purityFinalController.text : '0.00'} g",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Estimated Total Value:",
                              style: TextStyle(color: AppTheme.muted),
                            ),
                            Text(
                              "₹ ${_calculateEstimatedTotal().toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppTheme.goldDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                // ---------------- DATE ----------------
                const SizedBox(height: 16),
                buildFieldTitle("Date", ''),
                const SizedBox(height: 8),
                buildTextField(
                  controller: dateController,
                  hint: "Date (optional)",
                  readOnly: true,
                  suffixIcon: const Icon(Icons.calendar_month),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),

                // ---------------- REMARKS ----------------
                const SizedBox(height: 16),
                buildFieldTitle("Remarks", ''),
                const SizedBox(height: 8),
                buildTextFieldRemarks(
                  controller: remarkController,
                  hint: "Optional remarks or voucher notes",
                  inputformatters: [LengthLimitingTextInputFormatter(100)],
                  maxLines: 3,
                ),

                const SizedBox(height: 30),

                // ---------------- SAVE ACTION ----------------
                if (state is TransactionLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        // ---------------- VALIDATION ----------------
                        if (selectedCustomerId == null ||
                            selectedCustomerId!.trim().isEmpty ||
                            selectedCustomerId == "GLOBAL") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Customer selection is required.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final weightStr = weightController.text.trim();
                        final amountStr = amountController.text.trim();
                        final goldRateStr = goldRateController.text.trim();
                        final wastageStr = wastageController.text.trim();
                        final stoneStr = stoneController.text.trim();
                        final makingChargesStr = makingChargesController.text
                            .trim();
                        final linkedTransactionIdStr =
                            linkedTransactionIdController.text.trim();

                        final weightVal = double.tryParse(weightStr);
                        final amountVal = double.tryParse(amountStr);
                        final goldRateVal = double.tryParse(goldRateStr);
                        final wastageVal = double.tryParse(wastageStr);
                        final stoneVal = double.tryParse(stoneStr);
                        final makingChargesVal = double.tryParse(
                          makingChargesStr,
                        );

                        // Cash Validations
                        if (isCashType) {
                          if (amountVal == null || amountVal <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A valid Amount (> 0) is required.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (isSettlement &&
                              (goldRateVal == null || goldRateVal <= 0)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gold Rate (> 0) is required for metal settlement.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        }

                        // Metal Validations
                        if (isMetalType) {
                          if (weightVal == null || weightVal <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A valid Weight (> 0) is required.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (isSettlement &&
                              (goldRateVal == null || goldRateVal <= 0)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gold Rate (> 0) is required for cash settlement.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                        }

                        // Purchase / Sale Validations
                        if (isPurchaseOrSale) {
                          if (weightVal == null || weightVal <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A valid Weight (> 0) is required.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (wastageVal == null ||
                              wastageVal <= 0 ||
                              wastageVal > 100) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'A valid Purity percentage (1-100%) is required.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (goldRateVal == null || goldRateVal <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gold Rate (> 0) is required.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (isReturn && linkedTransactionIdStr.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Linked Transaction ID is required for returns.',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          if (isReturn && widget.initialTransaction != null) {
                            final origWeight =
                                widget.initialTransaction!.weight ?? 0.0;
                            if (origWeight > 0 && weightVal > origWeight) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Returned weight (${weightVal}g) cannot exceed original eligible weight (${origWeight}g).',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                          }
                        }

                        // ---------------- DISPATCH TO CUBIT ----------------
                        final cId = selectedCustomerId!;
                        final remarkStr = remarkController.text.trim();

                        if (isCashType) {
                          if (!isSettlement) {
                            // Pure Cash Transaction
                            context.read<TransactionCubit>().createTransaction(
                              customerId: cId,
                              type: stockType,
                              metalType: MetalType.none,
                              amount: amountVal,
                              weight: null,
                              grossWeight: null,
                              goldRate: null,
                              remark: remarkStr.isEmpty ? null : remarkStr,
                              currency: currencyType,
                            );
                          } else {
                            // Settle Metal using Cash
                            final settledWeight = (amountVal! / goldRateVal!);
                            context.read<TransactionCubit>().createTransaction(
                              customerId: cId,
                              type: stockType,
                              metalType: stockItemType,
                              weight: settledWeight,
                              grossWeight: settledWeight,
                              amount: amountVal,
                              goldRate: goldRateVal,
                              remark: remarkStr.isEmpty ? null : remarkStr,
                              currency: currencyType,
                            );
                          }
                        } else if (isMetalType) {
                          if (!isSettlement) {
                            // Pure Metal Transaction
                            context.read<TransactionCubit>().createTransaction(
                              customerId: cId,
                              type: stockType,
                              metalType: stockItemType,
                              weight: weightVal,
                              grossWeight: weightVal,
                              amount: null,
                              goldRate: null,
                              remark: remarkStr.isEmpty ? null : remarkStr,
                              currency: currencyType,
                            );
                          } else {
                            // Settle Cash using Metal
                            final settledAmount = weightVal! * goldRateVal!;
                            context.read<TransactionCubit>().createTransaction(
                              customerId: cId,
                              type: stockType,
                              metalType: stockItemType,
                              weight: weightVal,
                              grossWeight: weightVal,
                              amount: settledAmount,
                              goldRate: goldRateVal,
                              remark: remarkStr.isEmpty ? null : remarkStr,
                              currency: currencyType,
                            );
                          }
                        } else {
                          // Purchase / Sale / Returns
                          context.read<TransactionCubit>().createTransaction(
                            customerId: cId,
                            type: stockType,
                            metalType: stockItemType,
                            weight: weightVal,
                            grossWeight: weightVal,
                            purityPercent: wastageVal,
                            stoneWeight: stockItemType == MetalType.jewellery
                                ? stoneVal
                                : null,
                            goldRate: goldRateVal,
                            makingChargeType:
                                stockItemType == MetalType.jewellery
                                ? selectedMakingChargeType
                                : null,
                            makingChargesValue:
                                stockItemType == MetalType.jewellery
                                ? makingChargesVal
                                : null,
                            linkedTransactionId:
                                isReturn && linkedTransactionIdStr.isNotEmpty
                                ? linkedTransactionIdStr
                                : null,
                            remark: remarkStr.isEmpty ? null : remarkStr,
                            currency: currencyType,
                          );
                        }
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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

class _CustomerSearchSheet extends StatefulWidget {
  final List<CustomerModel> customers;
  final String? selectedCustomerId;
  final ValueChanged<String> onSelected;

  const _CustomerSearchSheet({
    required this.customers,
    required this.selectedCustomerId,
    required this.onSelected,
  });

  @override
  State<_CustomerSearchSheet> createState() => _CustomerSearchSheetState();
}

class _CustomerSearchSheetState extends State<_CustomerSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final filteredCustomers = query.isEmpty
        ? widget.customers
        : widget.customers.where((c) {
            final nameMatch = c.name.toLowerCase().contains(query);
            final phoneMatch = c.phone?.toLowerCase().contains(query) ?? false;
            return nameMatch || phoneMatch;
          }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Select Customer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.muted),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name or mobile',
                hintStyle: const TextStyle(color: AppTheme.muted, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppTheme.goldDark),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppTheme.muted,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE6D8A8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppTheme.gold,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0EAE1)),
          // List
          Flexible(
            child: filteredCustomers.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 56,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No customers available'
                              : 'No customer matching "$_searchQuery"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredCustomers.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 68,
                      endIndent: 16,
                      color: Color(0xFFF7F4EB),
                    ),
                    itemBuilder: (context, index) {
                      final customer = filteredCustomers[index];
                      final isSelected =
                          customer.id == widget.selectedCustomerId;

                      return InkWell(
                        onTap: () {
                          widget.onSelected(customer.id);
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: isSelected
                              ? AppTheme.gold.withValues(alpha: 0.08)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: isSelected
                                    ? AppTheme.gold
                                    : const Color(0xFFF3ECE0),
                                child: Text(
                                  customer.name.isNotEmpty
                                      ? customer.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : AppTheme.goldDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: AppTheme.ink,
                                      ),
                                    ),
                                    if (customer.phone != null &&
                                        customer.phone!.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        customer.phone!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.muted,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'Gold: ${customer.goldBalance.toStringAsFixed(2)}g',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.goldDark,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Cash: ₹${customer.cashBalance.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.success,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppTheme.gold,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
