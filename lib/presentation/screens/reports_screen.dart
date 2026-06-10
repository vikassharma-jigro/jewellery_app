import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../../data/models/transaction_model.dart';
import '../widgets/bottom_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/transaction_cubit.dart';
import '../../blocs/customer_cubit.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionCubit>().fetchTransactions();
      context.read<CustomerCubit>().fetchCustomers();
    });
  }

  // Fallback icon helper
  IconData _getIconForType(String type) {
    switch (type) {
      case 'Inward':
        return Icons.call_received;
      case 'Outward':
        return Icons.call_made;
      case 'Sale':
        return Icons.point_of_sale;
      default:
        return Icons.help_outline;
    }
  }

  void _showSettlementModal(BuildContext context, Map customer) {
    String selectedSettlement = 'Physical Metal Transfer';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: kCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: kDivider.withValues(alpha: 0.3)),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Settle Balance',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kGold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: kMuted),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: kDivider, height: 24),
                    const SizedBox(height: 8),

                    // Entity name
                    const Text(
                      'ENTITY',
                      style: TextStyle(
                        fontSize: 10,
                        color: kMuted,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer['name']?.toString() ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Outstanding Balance
                    const Text(
                      'OUTSTANDING BALANCE',
                      style: TextStyle(
                        fontSize: 10,
                        color: kMuted,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${customer['balance'] ?? '0.0'}g Gold',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            (customer['balance']?.toString() ?? '0.0')
                                .startsWith('-')
                            ? Colors.redAccent
                            : kGold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Settlement type dropdown
                    const Text(
                      'SETTLEMENT TYPE',
                      style: TextStyle(
                        fontSize: 10,
                        color: kMuted,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: kCardHigh,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: const Border(
                          bottom: BorderSide(color: kGold, width: 2),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSettlement,
                          dropdownColor: kCardHigh,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: kGold),
                          style: const TextStyle(color: kText, fontSize: 14),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setModalState(() {
                                selectedSettlement = newValue;
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Physical Metal Transfer',
                              child: Text('Physical Metal Transfer'),
                            ),
                            DropdownMenuItem(
                              value: 'Cash Liquidation',
                              child: Text('Cash Liquidation'),
                            ),
                            DropdownMenuItem(
                              value: 'Contra Voucher',
                              child: Text('Contra Voucher'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCardHigh,
                                foregroundColor: kText,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kGold,
                                foregroundColor: const Color(0xFF241A00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                final balanceStr =
                                    customer['balance']?.toString() ?? '0';
                                final amountStr = balanceStr
                                    .replaceAll('+', '')
                                    .replaceAll('-', '');
                                final numAmount =
                                    double.tryParse(amountStr) ?? 0.0;
                                final isNegative = balanceStr.startsWith('-');

                                context
                                    .read<TransactionCubit>()
                                    .createTransaction(
                                      type:
                                          selectedSettlement == 'Gold Delivery'
                                          ? TransactionType.stockOut
                                          : TransactionType.stockIn,
                                      amount: numAmount,
                                      customerId:
                                          customer['customerId']?.toString() ??
                                          '',
                                      remark: 'Settled via $selectedSettlement',
                                      metalType: MetalType.gold,
                                    )
                                    .then((_) {
                                      if (context.mounted) {
                                        context
                                            .read<TransactionCubit>()
                                            .fetchTransactions();
                                      }
                                    });

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Settlement processing for ${customer['name'] ?? ''}',
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              },
                              child: const Text(
                                'CONFIRM',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return AppScaffold(
      title: 'Ledger',
      currentIndex: 3,
      body: Stack(
        children: [
          // Subtle Ambient background blur circles
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGold.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withValues(alpha: 0.03),
              ),
            ),
          ),

          // Main Layout Scrollview
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Summary Section
                  BlocBuilder<CustomerCubit, CustomerState>(
                    builder: (context, customerState) {
                      double pendingReceive = 0;
                      double pendingDeliver = 0;
                      if (customerState is CustomerLoaded) {
                        for (var c in customerState.customers) {
                          final balance = c.goldBalance;
                          if (balance > 0) {
                            pendingReceive += balance;
                          } else if (balance < 0) {
                            pendingDeliver += balance.abs();
                          }
                        }
                      }

                      final receiveStr = pendingReceive.toStringAsFixed(2);
                      final deliverStr = pendingDeliver.toStringAsFixed(2);

                      if (isDesktop) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildHeroCard(
                                title: 'Gold Pending Receive',
                                value: receiveStr,
                                unit: 'g',
                                trend: 'Aggregated',
                                icon: Icons.call_received,
                                color: kGold,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildHeroCard(
                                title: 'Gold Pending Deliver',
                                value: deliverStr,
                                unit: 'g',
                                trend: 'Aggregated',
                                icon: Icons.call_made,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeroCard(
                              title: 'Gold Pending Receive',
                              value: receiveStr,
                              unit: 'g',
                              trend: 'Aggregated',
                              icon: Icons.call_received,
                              color: kGold,
                            ),
                            const SizedBox(height: 16),
                            _buildHeroCard(
                              title: 'Gold Pending Deliver',
                              value: deliverStr,
                              unit: 'g',
                              trend: 'Aggregated',
                              icon: Icons.call_made,
                              color: Colors.redAccent,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Ledger Controls header
                  _buildControlsHeader(context, isDesktop),
                  const SizedBox(height: 20),

                  // Data Table Grid
                  BlocBuilder<TransactionCubit, TransactionState>(
                    builder: (context, state) {
                      if (state is TransactionLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: kGold),
                        );
                      } else if (state is TransactionError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else if (state is TransactionLoaded) {
                        final transactions = state.transactions;
                        if (transactions.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No ledger transactions found.',
                                style: TextStyle(color: kMuted),
                              ),
                            ),
                          );
                        }
                        return _buildDataTable(isDesktop, transactions);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard({
    required String title,
    required String value,
    required String unit,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCard2,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Icon(icon, color: color.withValues(alpha: 0.08), size: 64),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: kMuted,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'g',
                    style: TextStyle(fontSize: 18, color: kMuted),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    icon == Icons.call_received
                        ? Icons.trending_up
                        : Icons.schedule,
                    size: 14,
                    color: kMuted.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      fontSize: 12,
                      color: kMuted.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlsHeader(BuildContext context, bool isDesktop) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Customer Settlement Ledger',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kText,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Manage outstanding metal balances and historical settlements.',
          style: TextStyle(fontSize: 13, color: kMuted),
        ),
      ],
    );

    final buttonsWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Expanded(
        //   flex: isDesktop ? 0 : 1,
        //   child: OutlinedButton.icon(
        //     onPressed: () {},
        //     style: OutlinedButton.styleFrom(
        //       foregroundColor: kText,
        //       side: const BorderSide(color: kDivider),
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //     ),
        //     // icon: const Icon(Icons.filter_list, size: 16),
        //     label: const Text(
        //       'FILTER',
        //       style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        // const SizedBox(width: 8),
        Expanded(
          flex: isDesktop ? 0 : 1,
          child: ElevatedButton.icon(
            onPressed: () => _showNewTransactionDialog(context, isDesktop),
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: const Color(0xFF241A00),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text(
              'NEW TRANSACTION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );

    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: titleWidget),
          const SizedBox(width: 12),
          buttonsWidget,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [titleWidget, const SizedBox(height: 16), buttonsWidget],
      );
    }
  }

  Widget _buildDataTable(bool isDesktop, List<dynamic> transactions) {
    if (isDesktop) {
      return Container(
        decoration: BoxDecoration(
          color: kCard2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kDivider.withValues(alpha: 0.2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Table Header
            Container(
              color: kCardHigh.withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: const [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'CUSTOMER ENTITY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'BALANCE (G)',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'STATUS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'LAST SETTLED',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'ACTIONS',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Table Body Rows
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) =>
                  Divider(color: kDivider.withValues(alpha: 0.1), height: 1),
              itemBuilder: (context, index) {
                final TransactionModel t = transactions[index];
                final amount = t.amount?.toStringAsFixed(2) ?? '0.00';
                final typeStr = (t.type == TransactionType.stockOut || t.type == TransactionType.paymentOut) ? 'Outward' : 'Inward';
                final isOutward = typeStr == 'Outward';
                final sign = isOutward ? '-' : '+';

                final uiCustomer = {
                  'customerId': t.customerId,
                  'name': t.customerName ?? 'Unknown Customer',
                  'reg': 'No Details',
                  'icon': _getIconForType(typeStr),
                  'iconColor': isOutward ? Colors.redAccent : kGold,
                  'balance': '$sign$amount',
                  'balanceType': isOutward ? 'TO DELIVER' : 'TO RECEIVE',
                  'status': typeStr.toUpperCase(),
                  'statusColor': isOutward ? Colors.redAccent : kGold,
                  'date': t.createdAt.toLocal().toString().substring(0, 10),
                  'ref': t.id.length > 6
                      ? 'Ref: #${t.id.substring(0, 6)}'
                      : 'Ref: ${t.id}',
                };
                return _buildDesktopRow(uiCustomer);
              },
            ),
          ],
        ),
      );
    } else {
      // Mobile Card layout
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final TransactionModel t = transactions[index];
          final amount = t.amount?.toStringAsFixed(2) ?? '0.00';
          final typeStr = (t.type == TransactionType.stockOut || t.type == TransactionType.paymentOut) ? 'Outward' : 'Inward';
          final isOutward = typeStr == 'Outward';
          final sign = isOutward ? '-' : '+';

          final uiCustomer = {
            'customerId': t.customerId,
            'name': t.customerName ?? 'Unknown Customer',
            'reg': 'No Details',
            'icon': _getIconForType(typeStr),
            'iconColor': isOutward ? Colors.redAccent : kGold,
            'balance': '$sign$amount',
            'balanceType': isOutward ? 'TO DELIVER' : 'TO RECEIVE',
            'status': typeStr.toUpperCase(),
            'statusColor': isOutward ? Colors.redAccent : kGold,
            'date': t.createdAt.toLocal().toString().substring(0, 10),
            'ref': t.id.length > 6
                ? 'Ref: #${t.id.substring(0, 6)}'
                : 'Ref: ${t.id}',
          };
          return _buildMobileCard(uiCustomer);
        },
      );
    }
  }

  Widget _buildDesktopRow(Map customer) {
    final balance = customer['balance']?.toString() ?? '0.0';
    final isNegative = balance.startsWith('-');
    final isZero = balance == '0.00';
    Color balanceColor = kGold;
    if (isNegative) balanceColor = Colors.redAccent;
    if (isZero) balanceColor = kMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Customer Entity info
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (customer['iconColor'] as Color? ?? Colors.grey)
                        .withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    customer['icon'] as IconData? ?? Icons.circle,
                    color: customer['iconColor'] as Color? ?? Colors.grey,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer['name']?.toString() ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        customer['reg']?.toString() ?? '',
                        style: const TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Balance (g)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: balanceColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer['balanceType']?.toString() ?? '',
                  style: const TextStyle(fontSize: 10, color: kMuted),
                ),
              ],
            ),
          ),

          // Status Badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (customer['statusColor'] as Color? ?? Colors.grey)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (customer['statusColor'] as Color? ?? Colors.grey)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  customer['status']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: customer['statusColor'] as Color? ?? Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // Last Settled
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  customer['date']?.toString() ?? '',
                  style: const TextStyle(fontSize: 13, color: kText),
                ),
                const SizedBox(height: 4),
                Text(
                  customer['ref']?.toString() ?? '',
                  style: const TextStyle(fontSize: 11, color: kMuted),
                ),
              ],
            ),
          ),

          // Actions
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Settle Balance',
                  icon: const Icon(Icons.payments_outlined, color: kGold),
                  onPressed: () => _showSettlementModal(context, customer),
                ),
                // IconButton(
                //   tooltip: 'View History',
                //   icon: const Icon(Icons.history, color: kMuted),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map customer) {
    final balance = customer['balance']?.toString() ?? '0.0';
    final isNegative = balance.startsWith('-');
    final isZero = balance == '0.00';
    Color balanceColor = kGold;
    if (isNegative) balanceColor = Colors.redAccent;
    if (isZero) balanceColor = kMuted;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (customer['iconColor'] as Color? ?? Colors.grey)
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  customer['icon'] as IconData? ?? Icons.circle,
                  color: customer['iconColor'] as Color? ?? Colors.grey,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer['name']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer['reg']?.toString() ?? '',
                      style: const TextStyle(fontSize: 11, color: kMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: kDivider, height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Outstanding Balance',
                    style: TextStyle(fontSize: 10, color: kMuted),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        balance,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: balanceColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        customer['balanceType']?.toString() ?? '',
                        style: const TextStyle(fontSize: 9, color: kMuted),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (customer['statusColor'] as Color? ?? Colors.grey)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (customer['statusColor'] as Color? ?? Colors.grey)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  customer['status']?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: customer['statusColor'] as Color? ?? Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last: ${customer['date']?.toString() ?? ''}',
                    style: const TextStyle(fontSize: 11, color: kText),
                  ),
                  Text(
                    customer['ref']?.toString() ?? '',
                    style: const TextStyle(fontSize: 10, color: kMuted),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGoldContainer.withValues(alpha: 0.1),
                      foregroundColor: kGold,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    icon: const Icon(Icons.payments_outlined, size: 14),
                    label: const Text(
                      'SETTLE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => _showSettlementModal(context, customer),
                  ),
                  const SizedBox(width: 8),
                  // IconButton(
                  //   icon: const Icon(Icons.history, color: kMuted, size: 18),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNewTransactionDialog(BuildContext context, bool isDesktop) {
    final balanceController = TextEditingController();
    final dateController = TextEditingController();

    String selectedDirection = 'TO RECEIVE';
    String selectedStatus = 'OVERDUE';
    String? selectedCustomerId;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: kCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: kDivider.withValues(alpha: 0.3)),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'New Ledger Settlement',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kGold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: kMuted),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(color: kDivider, height: 24),

                      const Text(
                        'SELECT CUSTOMER',
                        style: TextStyle(
                          fontSize: 10,
                          color: kMuted,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 48,
                        decoration: BoxDecoration(
                          color: kCardHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kDivider),
                        ),
                        child: BlocBuilder<CustomerCubit, CustomerState>(
                          builder: (context, state) {
                            if (state is CustomerLoading) {
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: kGold,
                                  ),
                                ),
                              );
                            } else if (state is CustomerLoaded) {
                              final customers = state.customers;
                              if (customers.isEmpty) {
                                return const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'No customers found',
                                    style: TextStyle(color: kMuted),
                                  ),
                                );
                              }
                              return DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerId,
                                  hint: const Text(
                                    'Select a customer',
                                    style: TextStyle(
                                      color: kMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                  dropdownColor: kCardHigh,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: kGold,
                                  ),
                                  style: const TextStyle(
                                    color: kText,
                                    fontSize: 14,
                                  ),
                                  onChanged: (newValue) {
                                    setModalState(() {
                                      selectedCustomerId = newValue;
                                    });
                                  },
                                  items: customers.map((c) {
                                    return DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(
                                        '${c.name} (${c.phone ?? ''})',
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Error loading customers',
                                style: TextStyle(color: kError),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BALANCE (G)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: balanceController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kText,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. 50.25',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DIRECTION',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: kCardHigh,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: kDivider),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedDirection,
                                      dropdownColor: kCardHigh,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: kGold,
                                      ),
                                      style: const TextStyle(
                                        color: kText,
                                        fontSize: 13,
                                      ),
                                      onChanged: (newValue) {
                                        if (newValue != null) {
                                          setModalState(() {
                                            selectedDirection = newValue;
                                          });
                                        }
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'TO RECEIVE',
                                          child: Text('TO RECEIVE'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'TO DELIVER',
                                          child: Text('TO DELIVER'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'BALANCED',
                                          child: Text('BALANCED'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SETTLEMENT STATUS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: kCardHigh,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: kDivider),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedStatus,
                                      dropdownColor: kCardHigh,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: kGold,
                                      ),
                                      style: const TextStyle(
                                        color: kText,
                                        fontSize: 13,
                                      ),
                                      onChanged: (newValue) {
                                        if (newValue != null) {
                                          setModalState(() {
                                            selectedStatus = newValue;
                                          });
                                        }
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'OVERDUE',
                                          child: Text('OVERDUE'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'SCHEDULED',
                                          child: Text('SCHEDULED'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'SETTLED',
                                          child: Text('SETTLED'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'HIGH VALUE',
                                          child: Text('HIGH VALUE'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'DATE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null) {
                                      dateController.text =
                                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kText,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Select Date',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: kText,
                                  side: const BorderSide(color: kDivider),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'CANCEL',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kGold,
                                  foregroundColor: const Color(0xFF241A00),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  if (selectedCustomerId == null ||
                                      balanceController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a customer and enter balance.',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  final balanceVal = balanceController.text
                                      .trim();

                                  final numAmount =
                                      double.tryParse(balanceVal) ?? 0.0;

                                  context
                                      .read<TransactionCubit>()
                                      .createTransaction(
                                        type: selectedDirection == 'TO RECEIVE'
                                            ? TransactionType.stockIn
                                            : TransactionType.stockOut,
                                        amount: numAmount,
                                        customerId: selectedCustomerId!,
                                        remark: 'Added via Ledger Screen',
                                        metalType: MetalType.gold,
                                      )
                                      .then((_) {
                                        if (context.mounted) {
                                          context
                                              .read<TransactionCubit>()
                                              .fetchTransactions();
                                        }
                                      });

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Ledger settlement recorded.',
                                      ),
                                      backgroundColor: Colors.white,
                                    ),
                                  );
                                },
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
