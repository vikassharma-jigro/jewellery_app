import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title.dart';
import 'add_stock_screen.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Text('Stock Management',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddStockScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.filter_list_rounded)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEFE8D2)),
              ),
              child: TabBar(
                controller: _tab,
                indicator: BoxDecoration(
                  color: AppTheme.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.muted,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Stock In'),
                  Tab(text: 'Stock Out'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _StockList(isIn: true),
                _StockList(isIn: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StockList extends StatelessWidget {
  final bool isIn;
  const _StockList({required this.isIn});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(6, (i) => i);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFE8D2)),
          ),
          child: Row(
            children: [
              _MetricBox(
                  label: 'Total ${isIn ? "In" : "Out"}',
                  value: isIn ? '340.00 g' : '185.25 g'),
              Container(
                  width: 1, height: 36, color: const Color(0xFFEFE8D2)),
              _MetricBox(
                  label: 'Running Balance', value: '1,248.75 g'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Recent Entries'),
        const SizedBox(height: 12),
        ...items.map((i) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFEFE8D2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isIn
                          ? const Color(0xFFE8F6EF)
                          : const Color(0xFFFDEAE6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isIn ? Icons.south_west : Icons.north_east,
                      color: isIn ? AppTheme.success : AppTheme.danger,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isIn ? 'Stock In · Gold' : 'Stock Out · Silver',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                            isIn
                                ? 'Supplier: Anil Verma · 02 Jun 2026'
                                : 'Customer: Rahul Sharma · 02 Jun 2026',
                            style: const TextStyle(
                                color: AppTheme.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    isIn ? '+${(40 + i * 5).toString()}.00 g' : '-${(15 + i * 3).toString()}.50 g',
                    style: TextStyle(
                        color: isIn ? AppTheme.success : AppTheme.danger,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label, value;
  const _MetricBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }
}
