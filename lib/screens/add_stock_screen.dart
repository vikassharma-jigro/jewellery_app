import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction_cubit.dart';
import '../data/models/transaction_model.dart';

class AddStockScreen extends StatefulWidget {
  final String? customerId;
  final TransactionType? initialTransactionType;

  const AddStockScreen({
    super.key,
    this.customerId,
    this.initialTransactionType,
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
  DateTime? selectedDate;

  late TransactionType stockType;
  MetalType stockItemType = MetalType.gold;
  CurrencyType currencyType = CurrencyType.inr;

  @override
  void initState() {
    super.initState();
    stockType = widget.initialTransactionType ?? TransactionType.stockIn;
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
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionCreated) {
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
                DropdownButtonFormField<TransactionType>(
                  initialValue: stockType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: TransactionType.stockIn,
                      child: Text("Stock In"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.stockOut,
                      child: Text("Stock Out"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.paymentIn,
                      child: Text("Payment In"),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.paymentOut,
                      child: Text("Payment Out"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      stockType = value!;
                    });
                  },
                ),

                if (stockType == TransactionType.stockIn ||
                    stockType == TransactionType.stockOut) ...[
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
                  const Text("Weight (Gram)"),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Weight (Gram)",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
                  const Text("Wasteage (%)"),
                  TextFormField(
                    controller: wastageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Wastage (%)",
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
                ],

                if (stockType == TransactionType.paymentIn ||
                    stockType == TransactionType.paymentOut) ...[
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
                ],

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
                        // In a real app we'd require a customerId here or allow picking one
                        // Defaulting to "GLOBAL" if not provided for global stock operations
                        final cId = widget.customerId ?? "GLOBAL";

                        final weightStr = weightController.text.trim();
                        final amountStr = amountController.text.trim();
                        final remarkStr = remarkController.text.trim();
                        final wastageStr = wastageController.text.trim();
                        final stoneStr = stoneController.text.trim();
                        final goldRateStr = goldRateController.text.trim();

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

                        context.read<TransactionCubit>().createTransaction(
                          customerId: cId,
                          type: stockType,
                          metalType: stockItemType,
                          weight:
                              weightVal, // Pass to standard weight (in case it's not a calculation)
                          grossWeight:
                              weightVal, // Also pass as grossWeight for backend auto-calc
                          amount: amountVal,
                          remark: remarkStr.isEmpty ? null : remarkStr,
                          wastagePercent: wastageVal,
                          stoneWeight: stoneVal,
                          goldRate: goldRateVal,
                        );
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
