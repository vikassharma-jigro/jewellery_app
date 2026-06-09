import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_title.dart';
import 'stock_screen.dart';
import 'customers_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.goldLight,
                  child: const Text('JS',
                      style: TextStyle(
                          color: AppTheme.goldDark,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back',
                          style: TextStyle(
                              color: AppTheme.muted, fontSize: 12)),
                      Text('Jigro Jewellers',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Stack(
                    children: const [
                      Icon(Icons.notifications_outlined),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                            radius: 4, backgroundColor: AppTheme.danger),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _HeroBalance(),
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
              children: const [
                StatCard(
                    icon: Icons.south_west,
                    label: 'Total Receivables',
                    value: '₹2,45,000',
                    tint: Color(0xFFE8F6EF),
                    iconColor: AppTheme.success),
                StatCard(
                    icon: Icons.north_east,
                    label: 'Total Payables',
                    value: '₹1,12,500',
                    tint: Color(0xFFFDEAE6),
                    iconColor: AppTheme.danger),
                StatCard(
                    icon: Icons.arrow_downward,
                    label: 'Pending Stock In',
                    value: '120.50 g',
                    tint: Color(0xFFFFF6D6),
                    iconColor: AppTheme.goldDark),
                StatCard(
                    icon: Icons.arrow_upward,
                    label: 'Pending Stock Out',
                    value: '78.25 g',
                    tint: Color(0xFFEDE7FE),
                    iconColor: Color(0xFF6E48C9)),
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const StockScreen();
                    },))),
                _QuickAction(
                    icon: Icons.indeterminate_check_box_outlined,
                    label: 'Stock Out',
                    onTap: () => _go(context, const StockScreen())),
                _QuickAction(
                    icon: Icons.person_add_alt,
                    label: 'New Customer',
                    onTap: () => _go(context, const CustomersScreen())),
              ],
            ),
            const SizedBox(height: 24),
            const SectionTitle('Recent Transactions'),
            const SizedBox(height: 12),
            ..._mockTxs.map((t) => _TxTile(tx: t)),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext c, Widget w) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => w));
}

class _HeroBalance extends StatelessWidget {
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
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Current Stock Balance',
                  style: TextStyle(color: Colors.white70)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Gold',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('1,248.75 g',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          Row(
            children: const [
              _MiniStat(
                  label: 'Stock In', value: '+340.00 g', icon: Icons.south_west),
              SizedBox(width: 24),
              _MiniStat(
                  label: 'Stock Out',
                  value: '-185.25 g',
                  icon: Icons.north_east),
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
  const _MiniStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
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
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

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
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tx {
  final String name, sub, amount;
  final bool isIn;
  _Tx(this.name, this.sub, this.amount, this.isIn);
}

final _mockTxs = [
  _Tx('Rahul Sharma', 'Stock Out · Gold', '-25.40 g', false),
  _Tx('Meena Jewellers', 'Payment Received', '+₹45,000', true),
  _Tx('Anil Verma', 'Stock In · Silver', '+120.00 g', true),
  _Tx('Suresh Bullion', 'Pending Payment', '-₹18,500', false),
];

class _TxTile extends StatelessWidget {
  final _Tx tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final color = tx.isIn ? AppTheme.success : AppTheme.danger;
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
          CircleAvatar(
            backgroundColor: AppTheme.goldLight,
            child: Text(tx.name[0],
                style: const TextStyle(
                    color: AppTheme.goldDark, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(tx.sub,
                    style: const TextStyle(
                        color: AppTheme.muted, fontSize: 12)),
              ],
            ),
          ),
          Text(tx.amount,
              style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
