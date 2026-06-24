import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewellary_stock/screens/add_stock_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title.dart';
import '../blocs/stock_cubit.dart';
import '../data/models/stock_ledger_entry_model.dart';
import '../data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import '../data/models/stock_summary_model.dart';
import 'transaction_detail_screen.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().fetchStockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: BlocBuilder<StockCubit, StockState>(
          builder: (context, state) {
            if (state is StockLoading || state is StockInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StockError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<StockCubit>().fetchStockData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final summary = (state as StockLoaded).summary;
            final ledger = state.ledger;

            final stockInLedger = ledger
                .where((l) => l.type == TransactionType.purchase)
                .toList();
            final stockOutLedger = ledger
                .where((l) => l.type == TransactionType.sales)
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Row(
                    children: [
                      const Text(
                        'Stock Management',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
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
                      _StockList(
                        isIn: true,
                        entries: stockInLedger,
                        summary: summary,
                      ),
                      _StockList(
                        isIn: false,
                        entries: stockOutLedger,
                        summary: summary,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StockList extends StatelessWidget {
  final bool isIn;
  final List<StockLedgerEntryModel> entries;
  final StockSummaryModel summary;

  const _StockList({
    required this.isIn,
    required this.entries,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    double totalValue = isIn
        ? summary.gold.inStock + summary.jewellery.inStock
        : summary.gold.outStock + summary.jewellery.outStock;

    double availableValue =
        summary.gold.available + summary.jewellery.available;

    return Scaffold(
      backgroundColor: kBg,
      body: RefreshIndicator(
        onRefresh: () => context.read<StockCubit>().fetchStockData(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    value: '${totalValue.toStringAsFixed(2)} g',
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: const Color(0xFFEFE8D2),
                  ),
                  _MetricBox(
                    label: 'Current Available Stock',
                    value: '${availableValue.toStringAsFixed(2)} g',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionTitle('Recent Entries'),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              const Center(child: Text('No entries found'))
            else
              ...entries.map(
                (entry) => GestureDetector(
                  onTap: () {
                    if (entry.transactionId == null ||
                        entry.transactionId!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Details not available for legacy entries',
                          ),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailScreen(
                          transactionId: entry.transactionId!,
                        ),
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
                              Text(
                                isIn
                                    ? 'Stock In · ${entry.metalType.name.toUpperCase()}'
                                    : 'Stock Out · ${entry.metalType.name.toUpperCase()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${entry.remark ?? "Entry"} · ${DateFormat('dd MMM yyyy').format(entry.createdAt)}',
                                style: const TextStyle(
                                  color: AppTheme.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isIn ? '+' : '-'}${entry.weight.toStringAsFixed(2)} g',
                          style: TextStyle(
                            color: isIn ? AppTheme.success : AppTheme.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBg,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddStockScreen()));
        },
        child: const Icon(Icons.add),
      ),
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
          Text(
            label,
            style: const TextStyle(color: AppTheme.muted, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
