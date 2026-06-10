import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../widgets/common.dart';
import '../state/transaction_cubit.dart';
import '../state/transaction_state.dart';

class ReceivablesScreen extends StatefulWidget {
  const ReceivablesScreen({super.key});

  @override
  State<ReceivablesScreen> createState() => _ReceivablesScreenState();
}

class _ReceivablesScreenState extends State<ReceivablesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().fetchReceivables();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Receivables')),
    body: BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading || state is TransactionInitial) {
          return const Center(child: CircularProgressIndicator(color: kGold));
        } else if (state is TransactionError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: kError)),
          );
        }

        final receivables = (state as TransactionLoaded).receivables ?? [];
        final totalAmount = receivables.fold<double>(
          0,
          (sum, item) =>
              sum + (double.tryParse(item['amount']?.toString() ?? '0') ?? 0),
        );

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Outstanding',
                    style: TextStyle(color: kMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: kGold,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Across ${receivables.length} receivables',
                    style: const TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...receivables.map(
              (x) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SectionCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              x['entityName'] ?? 'Unknown',
                              style: const TextStyle(
                                color: kText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              x['status'] ?? 'Pending',
                              style: const TextStyle(
                                color: kMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${x['amount']}',
                        style: const TextStyle(
                          color: kGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {}, // Payment action
                        icon: const Icon(Icons.payments, color: kGold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
