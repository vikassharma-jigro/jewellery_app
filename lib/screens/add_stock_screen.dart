import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewellary_stock/blocs/stock/stock_cubit.dart';
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
  DateTime? selectedDate;
  String? selectedCustomerId;

  late TransactionType stockType;
  MetalType stockItemType = MetalType.gold;
  CurrencyType currencyType = CurrencyType.inr;
  MakingChargeType? selectedMakingChargeType;

  @override
  void initState() {
    super.initState();

    // Get the stock type on Initial loading
    stockType = widget.initialTransactionType ?? TransactionType.purchase;
    selectedCustomerId = widget.customerId;
    if (widget.initialLinkedTransactionId != null) {
      linkedTransactionIdController.text = widget.initialLinkedTransactionId!;
    }

    weightController.addListener(_calculateAmount);
    goldRateController.addListener(_calculateAmount);

    context.read<CustomerCubit>().fetchCustomers();
  }

  void _calculateAmount() {
    if (stockType == TransactionType.cashJama ||
        stockType == TransactionType.cashNamae ||
        stockType == TransactionType.metalJama ||
        stockType == TransactionType.metalNamae) {
      final weight = double.tryParse(weightController.text.trim());
      final rate = double.tryParse(goldRateController.text.trim());
      if (weight != null && rate != null) {
        // Prevent cursor jumping if user is typing
        final newAmount = (weight * rate).toStringAsFixed(2);
        if (amountController.text != newAmount) {
          amountController.text = newAmount;
        }
      }
    }
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
    linkedTransactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            const Expanded(child: Center(child: Text("Transaction Entry"))),
          ],
        ),
        backgroundColor: Colors.transparent,
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text("Transaction Type"),
                const SizedBox(height: 10),

                /// Drop Down Open For Transection Selection Type
                DropdownButtonFormField<TransactionType>(
                  dropdownColor: kBg,
                  enableFeedback: true,
                  autofocus: true,
                  initialValue: stockType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                    });
                  },
                ),

                const SizedBox(height: 15),
                const Text("Customer"),
                const SizedBox(height: 10),
                BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, customerState) {
                    List<CustomerModel> customers = [];
                    if (customerState is CustomerLoaded) {
                      customers = customerState.customers;
                    }

                    String? dropdownValue = selectedCustomerId;
                    if (!customers.any((c) => c.id == dropdownValue)) {
                      dropdownValue = null;
                    }

                    return DropdownButtonFormField<String>(
                      initialValue: dropdownValue,
                      decoration: const InputDecoration(
                        hintText: "Select Customer",
                        border: OutlineInputBorder(),
                      ),
                      items: customers
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCustomerId = value;
                        });
                      },
                    );
                  },
                ),

                /// Stock Details
                const SizedBox(height: 15),
                const Text("Metal Type"),
                const SizedBox(height: 10),
                DropdownButtonFormField<MetalType>(
                  initialValue: stockItemType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                    });
                  },
                ),

                const SizedBox(height: 15),
                Text(
                  (stockType == TransactionType.cashJama ||
                          stockType == TransactionType.cashNamae)
                      ? "Weight (Gram) - Optional for settlement"
                      : "Weight (Gram)",
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Weight (Gram)",
                    border: OutlineInputBorder(),
                  ),
                ),

                // Metal Jama / Namae / Cash Jama / Namae: show Gold Rate for settlement
                if (stockType == TransactionType.metalJama ||
                    stockType == TransactionType.metalNamae ||
                    stockType == TransactionType.cashJama ||
                    stockType == TransactionType.cashNamae) ...[
                  const SizedBox(height: 15),
                  const Text("Gold Rate (₹/g) - for settlement"),
                  TextFormField(
                    controller: goldRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter Gold Rate (optional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                if (stockType == TransactionType.purchase ||
                    stockType == TransactionType.sales ||
                    stockType == TransactionType.purchaseReturn ||
                    stockType == TransactionType.salesReturn) ...[
                  const SizedBox(height: 15),
                  const Text("Purity (%)"),
                  TextFormField(
                    controller: wastageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Purity (%)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text("Stone (Gram)"),
                  TextFormField(
                    controller: stoneController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Stone Weight (Gram)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text("Currency (INR)"),

                  /// Drop Down For currency Selection
                  DropdownButtonFormField<CurrencyType>(
                    initialValue: CurrencyType.inr,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: CurrencyType.inr,
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value: CurrencyType.usd,
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value: CurrencyType.myr,
                        child: Text("MYR"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        currencyType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 15),
                  const Text("Gold Rate"),
                  TextFormField(
                    controller: goldRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Gold Rate",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (stockType == TransactionType.salesReturn ||
                      stockType == TransactionType.purchaseReturn) ...[
                    const SizedBox(height: 15),
                    const Text("Linked Transaction ID (Optional)"),
                    TextFormField(
                      controller: linkedTransactionIdController,
                      decoration: const InputDecoration(
                        hintText:
                            "Original transaction ID for exact calculations",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  if (stockType != TransactionType.salesReturn &&
                      stockType != TransactionType.purchaseReturn) ...[
                    const SizedBox(height: 15),
                    const Text("Making Charge Type"),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<MakingChargeType>(
                      initialValue: selectedMakingChargeType,
                      decoration: const InputDecoration(
                        hintText: "Select Making Charge Type",
                        border: OutlineInputBorder(),
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
                        });
                      },
                    ),

                    if (selectedMakingChargeType != null) ...[
                      const SizedBox(height: 15),
                      Text(
                        "Making Charges (${selectedMakingChargeType == MakingChargeType.percentage
                            ? '%'
                            : selectedMakingChargeType == MakingChargeType.perGram
                            ? '₹/g'
                            : '₹'})",
                      ),
                      TextFormField(
                        controller: makingChargesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText:
                              "Making Charges (${selectedMakingChargeType == MakingChargeType.percentage
                                  ? '%'
                                  : selectedMakingChargeType == MakingChargeType.perGram
                                  ? '₹/g'
                                  : '₹'})",
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ],

                const SizedBox(height: 15),
                const Text("Amount (₹)"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Amount (₹)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),
                const Text("Date"),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Date",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
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

                const SizedBox(height: 15),
                const Text("Remark"),
                const SizedBox(height: 15),
                TextFormField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Remark",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                if (state is TransactionLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                      ),
                      onPressed: () {
                        // Defaulting to "GLOBAL" if not provided for global stock operations
                        final cId = selectedCustomerId ?? "GLOBAL";

                        final weightStr = weightController.text.trim();
                        final amountStr = amountController.text.trim();
                        final remarkStr = remarkController.text.trim();
                        final wastageStr = wastageController.text.trim();
                        final stoneStr = stoneController.text.trim();
                        final goldRateStr = goldRateController.text.trim();
                        final makingChargesStr = makingChargesController.text
                            .trim();
                        final linkedTransactionIdStr =
                            linkedTransactionIdController.text.trim();

                        double? weightVal = weightStr.isNotEmpty
                            ? double.tryParse(weightStr)
                            : null;
                        double? amountVal = amountStr.isNotEmpty
                            ? double.tryParse(amountStr)
                            : null;
                        double? wastageVal = wastageStr.isNotEmpty
                            ? double.tryParse(wastageStr)
                            : null;
                        double? stoneVal = stoneStr.isNotEmpty
                            ? double.tryParse(stoneStr)
                            : null;
                        double? goldRateVal = goldRateStr.isNotEmpty
                            ? double.tryParse(goldRateStr)
                            : null;
                        double? makingChargesVal = makingChargesStr.isNotEmpty
                            ? double.tryParse(makingChargesStr)
                            : null;

                        bool hasCalcFields =
                            wastageVal != null ||
                            stoneVal != null ||
                            goldRateVal != null ||
                            makingChargesVal != null ||
                            selectedMakingChargeType != null;

                        // For Metal Jama/Namae: don't pass grossWeight to avoid
                        // calculateWeights pipeline which zeroes amount when purityPercent=0.
                        // Backend will compute settlement as weight * goldRate.
                        final isMetalSettlement =
                            stockType == TransactionType.metalJama ||
                            stockType == TransactionType.metalNamae ||
                            stockType == TransactionType.cashJama ||
                            stockType == TransactionType.cashNamae;

                        context.read<TransactionCubit>().createTransaction(
                          customerId: cId,
                          type: stockType,
                          metalType: stockItemType,
                          weight: weightVal,
                          grossWeight: isMetalSettlement
                              ? null
                              : (hasCalcFields ? weightVal : null),
                          amount: amountVal,
                          remark: remarkStr.isEmpty ? null : remarkStr,
                          purityPercent: isMetalSettlement ? null : wastageVal,
                          stoneWeight: isMetalSettlement ? null : stoneVal,
                          goldRate: goldRateVal,
                          makingChargeType: isMetalSettlement
                              ? null
                              : selectedMakingChargeType,
                          makingChargesValue: isMetalSettlement
                              ? null
                              : makingChargesVal,
                          linkedTransactionId: linkedTransactionIdStr.isEmpty
                              ? null
                              : linkedTransactionIdStr,
                        );

                        context.read<StockCubit>().fetchStockData();
                      },
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
