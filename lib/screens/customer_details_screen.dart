import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import 'customer_ledger_screen.dart';
import '../blocs/transaction_cubit.dart';
import '../data/models/transaction_model.dart';
import 'package:intl/intl.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String customerId;
  final String name;
  final String phone;
  final String stock;
  final String payment;

  const CustomerDetailsScreen({
    super.key,
    required this.customerId,
    required this.name,
    required this.phone,
    required this.stock,
    required this.payment,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().fetchTransactionsByCustomer(
      widget.customerId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("Customer Details"),
        backgroundColor: kBg,
        foregroundColor: kText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Customer Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.goldLight,
                    child: Text(
                      widget.name.isNotEmpty
                          ? widget.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.goldDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.phone,
                    style: const TextStyle(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          "Pending Stock",
                          widget.stock,
                          Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(
                          "Pending Payment",
                          widget.payment,
                          Icons.currency_rupee,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Actions
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _actionButton(
                  context,
                  "Add Stock",
                  Icons.add_box,
                  Colors.green,
                ),
                _actionButton(
                  context,
                  "Receive Stock",
                  Icons.inventory,
                  Colors.orange,
                ),
                _actionButton(
                  context,
                  "Add Payment",
                  Icons.account_balance_wallet,
                  Colors.red,
                ),
                _actionButton(
                  context,
                  "Receive Payment",
                  Icons.payments,
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Transaction History
            const Row(
              children: [
                Text(
                  "Transaction History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 12),

            BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading ||
                    state is TransactionInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionError) {
                  return Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else if (state is TransactionLoaded) {
                  if (state.transactions.isEmpty) {
                    return const Text('No transactions yet.');
                  }

                  // Filter transactions for this customer just in case
                  final txs = state.transactions
                      .where((t) => t.customerId == widget.customerId)
                      .toList();
                  if (txs.isEmpty && state.transactions.isNotEmpty) {
                    // Loading new data for this customer
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: txs.map((tx) {
                      String title = '';
                      String amount = '';
                      Color color = Colors.black;

                      if (tx.type == TransactionType.paymentIn ||
                          tx.type == TransactionType.paymentOut) {
                        title = tx.type == TransactionType.paymentIn
                            ? 'Payment Received'
                            : 'Payment Sent';
                        amount = '₹${tx.amount?.toStringAsFixed(2) ?? "0.00"}';
                        color = tx.type == TransactionType.paymentIn
                            ? Colors.blue
                            : Colors.red;
                      } else {
                        title = tx.type == TransactionType.stockIn
                            ? 'Stock In'
                            : 'Stock Out';
                        if (tx.metalType != MetalType.none) {
                          title += ' · ${tx.metalType.name.toUpperCase()}';
                        }
                        amount = '${tx.weight?.toStringAsFixed(2) ?? "0.00"} g';
                        color = tx.type == TransactionType.stockIn
                            ? Colors.green
                            : Colors.orange;
                      }

                      final dateStr = DateFormat(
                        'dd MMM yyyy, HH:mm',
                      ).format(tx.createdAt);

                      return _historyTile(
                        title,
                        (tx.type == TransactionType.paymentIn ||
                                    tx.type == TransactionType.stockIn
                                ? '+'
                                : '-') +
                            amount,
                        dateStr,
                        color,
                      );
                    }).toList(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffFAF7EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.gold),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionEntryScreen(
              title: title,
              isStock: title.contains("Stock"),
              customerId: widget.customerId,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyTile(String title, String amount, String date, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(Icons.history, color: color),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
