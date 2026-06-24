import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/transaction_cubit.dart';
import '../data/models/transaction_model.dart';
import '../theme/app_theme.dart';
import 'transaction_detail_screen.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().fetchTransactions();
  }

  Map<String, List<TransactionModel>> _groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    final Map<String, List<TransactionModel>> grouped = {};
    for (var tx in transactions) {
      final dateStr = DateFormat('dd MMM yyyy').format(tx.createdAt);
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(tx);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        title: const Text(
          'All Transactions',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading || state is TransactionInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<TransactionCubit>().fetchTransactions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final transactions = (state as TransactionLoaded).transactions;
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found'));
          }

          final grouped = _groupTransactionsByDate(transactions);
          final sortedKeys = grouped.keys.toList()
            ..sort(
              (a, b) => DateFormat(
                'dd MMM yyyy',
              ).parse(b).compareTo(DateFormat('dd MMM yyyy').parse(a)),
            );

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<TransactionCubit>().fetchTransactions();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                final dateStr = sortedKeys[index];
                final dateTransactions = grouped[dateStr]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.muted,
                        ),
                      ),
                    ),
                    ...dateTransactions.map((tx) => _TxTile(tx: tx)),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final TransactionModel tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isIn =
        tx.type == TransactionType.cashJama ||
        tx.type == TransactionType.purchase ||
        tx.type == TransactionType.salesReturn ||
        tx.type == TransactionType.metalJama;
    final color = isIn ? AppTheme.success : AppTheme.danger;

    String sub = '';
    String amount = '';
    if (tx.type == TransactionType.cashJama ||
        tx.type == TransactionType.cashNamae) {
      sub = tx.type == TransactionType.cashJama
          ? 'Payment Received'
          : 'Payment Sent';
      amount = '₹${tx.amount?.toStringAsFixed(2) ?? "0.00"}';
    } else {
      if (tx.type == TransactionType.purchase) {
        sub = 'Purchase';
      } else if (tx.type == TransactionType.sales) {
        sub = 'Sale';
      } else if (tx.type == TransactionType.purchaseReturn) {
        sub = 'Purchase Return';
      } else if (tx.type == TransactionType.salesReturn) {
        sub = 'Sale Return';
      } else if (tx.type == TransactionType.metalJama) {
        sub = 'Metal Jama';
      } else if (tx.type == TransactionType.metalNamae) {
        sub = 'Metal Namae';
      }

      if (tx.metalType != MetalType.none) {
        sub += ' · ${tx.metalType.name.toUpperCase()}';
      }
      amount = '${tx.weight?.toStringAsFixed(2) ?? "0.00"} g';
    }

    amount = (isIn ? '+' : '-') + amount;

    final name =
        tx.customerName ??
        'Customer (${tx.customerId.length > 4 ? tx.customerId.substring(0, 4) : tx.customerId}...)';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(transactionId: tx.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEFE8D2)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppTheme.goldLight,
              child: Text(
                'C',
                style: TextStyle(
                  color: AppTheme.goldDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
