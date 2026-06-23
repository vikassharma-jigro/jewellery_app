import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellary_stock/theme/app_theme.dart';
import '../data/models/transaction_model.dart';

class PricingSummaryCard extends StatelessWidget {
  final TransactionModel transaction;

  const PricingSummaryCard({super.key, required this.transaction});

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  String _getMakingChargeLabel() {
    if (transaction.makingChargeType == null) return '';
    String typeStr = '';
    switch (transaction.makingChargeType!) {
      case MakingChargeType.percentage:
        typeStr = 'Percentage';
        break;
      case MakingChargeType.perGram:
        typeStr = 'Per Gram';
        break;
      case MakingChargeType.fixed:
        typeStr = 'Fixed';
        break;
    }

    if (transaction.makingChargeValue != null &&
        transaction.makingChargeValue! > 0) {
      if (transaction.makingChargeType == MakingChargeType.percentage) {
        return ' (Type: $typeStr @ ${transaction.makingChargeValue}%)';
      } else if (transaction.makingChargeType == MakingChargeType.perGram) {
        return ' (Type: $typeStr @ ${_formatCurrency(transaction.makingChargeValue!)})';
      } else {
        return ' (Type: $typeStr)';
      }
    }
    return ' (Type: $typeStr)';
  }

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
              'Rate & Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPricingRow(
              'Gold Rate',
              '${_formatCurrency(transaction.goldRate ?? 0)} / gram',
            ),
            const Divider(height: 24),
            _buildPricingRow(
              'Price Segment',
              _formatCurrency(transaction.priceSegment ?? 0),
            ),
            if ((transaction.makingCharge ?? 0) > 0) ...[
              const Divider(height: 24),

              //${_formatCurrency(transaction.makingCharge ?? 0)}
              _buildPricingRow('Making Charge', _getMakingChargeLabel()),
            ],
            const Divider(height: 24, thickness: 1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatCurrency(
                    transaction.totalAmount ?? transaction.amount ?? 0,
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
