import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jewellary_stock/theme/app_theme.dart';
import '../blocs/transactionDetail/transaction_detail_cubit.dart';
import '../blocs/transactionDetail/transaction_detail_state.dart';
import '../data/models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/customer_repository.dart';
import '../widgets/transaction_info_card.dart';
import '../widgets/pricing_summary_card.dart';
import 'add_stock_screen.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionDetailCubit(
        RepositoryProvider.of<TransactionRepository>(context),
        RepositoryProvider.of<CustomerRepository>(context),
      )..fetchTransactionDetail(transactionId),
      child: Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(
          backgroundColor: kBg,
          title: const Text('Transaction Details'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.share_outlined),
          //     onPressed: () {
          //       // Implement share/print
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text('Share functionality coming soon'),
          //         ),
          //       );
          //     },
          //   ),
          // ],
        ),
        body: BlocBuilder<TransactionDetailCubit, TransactionDetailState>(
          builder: (context, state) {
            if (state is TransactionDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TransactionDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<TransactionDetailCubit>()
                            .fetchTransactionDetail(transactionId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is TransactionDetailLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionDetailLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(context, state.transaction),
          const SizedBox(height: 16),
          _buildCustomerCard(context, state),
          const SizedBox(height: 16),
          TransactionInfoCard(transaction: state.transaction),
          const SizedBox(height: 16),
          PricingSummaryCard(transaction: state.transaction),
          const SizedBox(height: 16),
          _buildMetaInfoCard(context, state.transaction),
          const SizedBox(height: 24),
          if (state.transaction.type == TransactionType.sales ||
              state.transaction.type == TransactionType.purchase)
            _buildReturnButton(context, state.transaction),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildReturnButton(
    BuildContext context,
    TransactionModel transaction,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.assignment_return_outlined, color: Colors.white),
        label: Text(
          transaction.type == TransactionType.sales
              ? "Initiate Sales Return"
              : "Initiate Purchase Return",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: transaction.type == TransactionType.sales
              ? Colors.green
              : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStockScreen(
                customerId: transaction.customerId,
                initialTransactionType:
                    transaction.type == TransactionType.sales
                    ? TransactionType.salesReturn
                    : TransactionType.purchaseReturn,
                initialLinkedTransactionId: transaction.id,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, TransactionModel transaction) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('dd MMM yyyy, h:mm a');

    // Type Badge setup
    Color typeColor;
    String typeText;
    switch (transaction.type) {
      case TransactionType.purchase:
        typeColor = Colors.green;
        typeText = 'PURCHASE';
        break;
      case TransactionType.purchaseReturn:
        typeColor = Colors.red;
        typeText = 'PURCHASE RETURN';
        break;
      case TransactionType.sales:
        typeColor = Colors.red;
        typeText = 'SALE';
        break;
      case TransactionType.salesReturn:
        typeColor = Colors.green;
        typeText = 'SALE RETURN';
        break;
      case TransactionType.cashJama:
        typeColor = Colors.green;
        typeText = 'CASH JAMA';
        break;
      case TransactionType.cashNamae:
        typeColor = Colors.red;
        typeText = 'CASH NAMAE';
        break;
      case TransactionType.metalJama:
        typeColor = Colors.green;
        typeText = 'METAL JAMA';
        break;
      case TransactionType.metalNamae:
        typeColor = Colors.red;
        typeText = 'METAL NAMAE';
        break;
    }

    return Card(
      color: kCard,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: typeColor.withValues(alpha: .5)),
                  ),
                  child: Text(
                    typeText,
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      transaction.metalType == MetalType.gold
                          ? Icons.circle
                          : Icons.diamond_outlined,
                      size: 14,
                      color: transaction.metalType == MetalType.gold
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      transaction.metalType.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Total Amount',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency.format(
                transaction.totalAmount ?? transaction.amount ?? 0,
              ),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction ID',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '#${_getLast8Chars(transaction.id)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: transaction.id),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaction ID copied!'),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.copy,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date & Time',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(transaction.createdAt),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    TransactionDetailLoaded state,
  ) {
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
              'Customer',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withValues(alpha: .1),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.customer != null)
                        Text(
                          state.customer!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else if (state.transaction.customerName != null &&
                          state.transaction.customerName!.isNotEmpty)
                        Text(
                          state.transaction.customerName!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        _buildShimmerLoader(),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${_getLast8Chars(state.transaction.customerId)}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Container(
      height: 16,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildMetaInfoCard(
    BuildContext context,
    TransactionModel transaction,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, h:mm a');
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        color: kCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ExpansionTile(
          title: const Text(
            'Meta Information',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          childrenPadding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            if (transaction.adminId != null)
              _buildMetaRow('Admin ID', _getLast8Chars(transaction.adminId!)),
            if (transaction.calculationVersion != null)
              _buildMetaRow(
                'Calculation Version',
                'v${transaction.calculationVersion}',
              ),
            _buildMetaRow(
              'Created At',
              dateFormat.format(transaction.createdAt),
            ),
            if (transaction.updatedAt != null)
              _buildMetaRow(
                'Updated At',
                dateFormat.format(transaction.updatedAt!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getLast8Chars(String id) {
    if (id.length <= 8) return id;
    return id.substring(id.length - 8);
  }
}
