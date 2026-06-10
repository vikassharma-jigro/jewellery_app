import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../blocs/transaction_cubit.dart';
import '../data/models/transaction_model.dart';

class TransactionEntryScreen extends StatefulWidget {
  final String title;
  final bool isStock;
  final String customerId;

  const TransactionEntryScreen({
    super.key,
    required this.title,
    required this.isStock,
    required this.customerId,
  });

  @override
  State<TransactionEntryScreen> createState() =>
      _TransactionEntryScreenState();
}

class _TransactionEntryScreenState extends State<TransactionEntryScreen> {
  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  MetalType stockItemType = MetalType.gold;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppTheme.gold,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${widget.title} Saved Successfully")),
            );
            Navigator.pop(context);
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      if (widget.isStock) ...[
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Metal Type", style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<MetalType>(
                          value: stockItemType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: MetalType.gold,
                              child: Text("Gold"),
                            ),
                            DropdownMenuItem(
                              value: MetalType.silver,
                              child: Text("Silver"),
                            ),
                            DropdownMenuItem(
                              value: MetalType.none,
                              child: Text("None"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              stockItemType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                          widget.isStock ? "Weight (gm)" : "Amount (₹)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );

                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: remarkController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Remark",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (state is TransactionLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                            ),
                            onPressed: () {
                              final amountStr = amountController.text.trim();
                              if (amountStr.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter amount/weight")),
                                );
                                return;
                              }
                              
                              final val = double.tryParse(amountStr);
                              final remark = remarkController.text.trim();

                              TransactionType type;
                              if (widget.title.contains("Add Stock")) {
                                type = TransactionType.stockOut; // Giving stock to customer
                              } else if (widget.title.contains("Receive Stock")) {
                                type = TransactionType.stockIn;
                              } else if (widget.title.contains("Add Payment")) {
                                type = TransactionType.paymentOut; // Giving money to customer
                              } else {
                                type = TransactionType.paymentIn; // Receive Payment
                              }

                              context.read<TransactionCubit>().createTransaction(
                                customerId: widget.customerId,
                                type: type,
                                metalType: widget.isStock ? stockItemType : MetalType.none,
                                weight: widget.isStock ? val : null,
                                amount: !widget.isStock ? val : null,
                                remark: remark.isNotEmpty ? remark : null,
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
                        )
                    ],
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