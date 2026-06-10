import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_title.dart';
import 'add_stock_screen.dart';
import 'add_customer_screen.dart';
import '../blocs/dashboard_cubit.dart';
import '../data/models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().fetchDashboardSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () => context
                          .read<DashboardCubit>()
                          .fetchDashboardSummary(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final summary = (state as DashboardLoaded).summary;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<DashboardCubit>().fetchDashboardSummary(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.goldLight,
                          child: Text(
                            'JS',
                            style: TextStyle(
                              color: AppTheme.goldDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: TextStyle(
                                  color: AppTheme.muted,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'AU Relian',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Stack(
                            children: [
                              Icon(Icons.notifications_outlined),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: AppTheme.danger,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _HeroBalance(
                      goldStock: summary.goldStock,
                      silverStock: summary.silverStock,
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Overview'),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      children: [
                        StatCard(
                          icon: Icons.south_west,
                          label: 'Total Receivables',
                          value:
                              '₹${summary.totalReceivables.toStringAsFixed(2)}',
                          tint: const Color(0xFFE8F6EF),
                          iconColor: AppTheme.success,
                        ),
                        StatCard(
                          icon: Icons.north_east,
                          label: 'Total Payables',
                          value: '₹${summary.totalPayables.toStringAsFixed(2)}',
                          tint: const Color(0xFFFDEAE6),
                          iconColor: AppTheme.danger,
                        ),
                        StatCard(
                          icon: Icons.arrow_downward,
                          label: 'Gold Stock',
                          value: '${summary.goldStock.toStringAsFixed(2)} g',
                          tint: const Color(0xFFFFF6D6),
                          iconColor: AppTheme.goldDark,
                        ),
                        StatCard(
                          icon: Icons.arrow_upward,
                          label: 'Gold Stock',
                          value: '${summary.silverStock.toStringAsFixed(2)} g',
                          tint: const Color(0xFFEDE7FE),
                          iconColor: const Color(0xFF6E48C9),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Quick Actions'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _QuickAction(
                          icon: Icons.add_box_outlined,
                          label: 'Stock In',
                          onTap: () => _go(
                            context,
                            const AddStockScreen(
                              initialTransactionType: TransactionType.stockIn,
                            ),
                          ),
                        ),
                        _QuickAction(
                          icon: Icons.indeterminate_check_box_outlined,
                          label: 'Stock Out',
                          onTap: () => _go(
                            context,
                            const AddStockScreen(
                              initialTransactionType: TransactionType.stockOut,
                            ),
                          ),
                        ),
                        _QuickAction(
                          icon: Icons.person_add_alt,
                          label: 'New Customer',
                          onTap: () => _go(context, const AddCustomerScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle('Recent Transactions'),
                    const SizedBox(height: 12),
                    if (summary.recentTransactions.isEmpty)
                      const Text('No recent transactions')
                    else
                      ...summary.recentTransactions.map((t) => _TxTile(tx: t)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _go(BuildContext c, Widget w) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => w));
}

class _HeroBalance extends StatelessWidget {
  final double goldStock;
  final double silverStock;

  const _HeroBalance({required this.goldStock, required this.silverStock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [AppTheme.goldDark, AppTheme.gold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Current Stock Balance',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Gold & Jewellery',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${goldStock.toStringAsFixed(2)} g (Gold)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${silverStock.toStringAsFixed(2)} g (Jewellery)',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              _MiniStat(
                label: 'Stock In',
                value: 'View Details',
                icon: Icons.south_west,
              ),
              SizedBox(width: 24),
              _MiniStat(
                label: 'Stock Out',
                value: 'View Details',
                icon: Icons.north_east,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEFE8D2)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.goldLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.goldDark),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
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
        tx.type == TransactionType.paymentIn ||
        tx.type == TransactionType.stockIn;
    final color = isIn ? AppTheme.success : AppTheme.danger;

    String sub = '';
    String amount = '';
    if (tx.type == TransactionType.paymentIn ||
        tx.type == TransactionType.paymentOut) {
      sub = tx.type == TransactionType.paymentIn
          ? 'Payment Received'
          : 'Payment Sent';
      amount = '₹${tx.amount?.toStringAsFixed(2) ?? "0.00"}';
    } else {
      sub = tx.type == TransactionType.stockIn ? 'Stock In' : 'Stock Out';
      if (tx.metalType != MetalType.none) {
        sub += ' · ${tx.metalType.name.toUpperCase()}';
      }
      amount = '${tx.weight?.toStringAsFixed(2) ?? "0.00"} g';
    }

    amount = (isIn ? '+' : '-') + amount;

    final name =
        tx.customerName ??
        'Customer (${tx.customerId.length > 4 ? tx.customerId.substring(0, 4) : tx.customerId}...)';

    return Container(
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
              'C', // TODO: user's initials
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
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    );
  }
}
