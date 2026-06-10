import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../widgets/bottom_nav.dart';
import '../state/stock_cubit.dart';
import '../state/stock_state.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().loadStockData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;

    return AppScaffold(
      title: 'Stock Ledger',
      currentIndex: 1,
      fab: FloatingActionButton.extended(
        onPressed: () {
          // Typically here we would navigate to a transaction creation screen
          // Since Stock is purely controlled via Transactions in this architecture.
        },
        backgroundColor: kGold,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'Add Transaction',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          if (state is StockLoading || state is StockInitial) {
            return const Center(
              child: CircularProgressIndicator(color: kGold),
            );
          } else if (state is StockError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: kError)),
            );
          } else if (state is StockLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildBalanceCards(state.balance, isDesktop),
                    const SizedBox(height: 32),
                    _buildLedgerList(state.ledger),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBalanceCards(dynamic balance, bool isDesktop) {
    final goldAvailable = balance.goldAvailable;
    final silverAvailable = balance.silverAvailable;

    final cards = [
      Expanded(
        child: _buildValueCard(
          'Gold Stock',
          '${goldAvailable.toStringAsFixed(3)} g',
          'Available fine gold',
          Icons.diamond_outlined,
          kGold,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: _buildValueCard(
          'Silver Stock',
          '${silverAvailable.toStringAsFixed(3)} g',
          'Available fine silver',
          Icons.diamond_outlined,
          const Color(0xFFC0C0C0),
        ),
      ),
    ];

    return Row(
      children: cards,
    );
  }

  Widget _buildValueCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 12, color: kMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kText)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: kMuted)),
        ],
      ),
    );
  }

  Widget _buildLedgerList(List<dynamic> ledger) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.list_alt_rounded, color: kGold, size: 20),
              SizedBox(width: 10),
              Text(
                'Stock Ledger',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (ledger.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No stock ledger entries', style: TextStyle(color: kMuted)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ledger.length,
              separatorBuilder: (_, __) => Divider(
                color: kDivider.withValues(alpha: 0.1),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final entry = ledger[index];
                final isOut = entry.type == 'OUT';
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kCardHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isOut ? Icons.arrow_upward : Icons.arrow_downward,
                          color: isOut ? kError : kGold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.metalType} Stock ${entry.type}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.createdAt.toString().split(' ')[0],
                              style: const TextStyle(fontSize: 12, color: kMuted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isOut ? '-' : '+'}${entry.weight}g',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOut ? kError : kGold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
