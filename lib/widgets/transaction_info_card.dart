import 'package:flutter/material.dart';
import 'package:jewellary_stock/theme/app_theme.dart';
import '../data/models/transaction_model.dart';
import 'info_tile_widget.dart';

class TransactionInfoCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionInfoCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight & Purity',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InfoTileWidget(
                    label: 'Gross Weight',
                    value:
                        '${transaction.grossWeight?.toStringAsFixed(2) ?? '0.00'} g',
                  ),
                ),
                Expanded(
                  child: InfoTileWidget(
                    label: 'Net Weight',
                    value:
                        '${transaction.netWeight?.toStringAsFixed(2) ?? '0.00'} g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InfoTileWidget(
                    label: 'Stone Weight',
                    value:
                        '${transaction.stoneWeight?.toStringAsFixed(2) ?? '0.00'} g',
                  ),
                ),
                Expanded(
                  child: InfoTileWidget(
                    label: 'Final Weight',
                    value:
                        '${transaction.finalWeight?.toStringAsFixed(2) ?? '0.00'} g',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InfoTileWidget(
                    label: 'Wastage',
                    value: transaction.wastage?.toStringAsFixed(2) ?? '0.00',
                  ),
                ),
                Expanded(
                  child: InfoTileWidget(
                    label: 'Purity %',
                    value:
                        '${transaction.purityPercent?.toStringAsFixed(2) ?? '0.00'}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
