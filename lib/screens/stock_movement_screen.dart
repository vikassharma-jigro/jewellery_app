import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../blocs/transaction/transaction_cubit.dart';
import '../data/models/transaction_model.dart';

class StockMovementScreen extends StatefulWidget {
  const StockMovementScreen({super.key});

  @override
  State<StockMovementScreen> createState() => _StockMovementScreenState();
}

class _StockMovementScreenState extends State<StockMovementScreen> {
  String _selectedMetal = 'All Materials';
  String _selectedType = 'ALL'; // ALL | IN | OUT

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().fetchTransactions();
  }

  bool _isTxIn(TransactionModel tx) {
    return tx.type == TransactionType.purchase ||
        tx.type == TransactionType.salesReturn ||
        tx.type == TransactionType.metalJama;
  }

  String _metalString(TransactionModel tx) {
    if (tx.metalType == MetalType.gold) return 'Gold';
    if (tx.metalType == MetalType.jewellery) return 'Jewellery';
    return 'None';
  }

  List<TransactionModel> _getFilteredEntries(List<TransactionModel> allEntries) {
    return allEntries.where((entry) {
      final metal = _metalString(entry);
      final matchesMetal =
          _selectedMetal == 'All Materials' || metal == _selectedMetal;
      final isIn = _isTxIn(entry);
      final matchesType = _selectedType == 'ALL' ||
          (_selectedType == 'IN' && isIn) ||
          (_selectedType == 'OUT' && !isIn);
      return matchesMetal && matchesType;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedMetal = 'All Materials';
      _selectedType = 'ALL';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: kCard2,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: kDivider.withValues(alpha: 0.2), width: 1),
        ),
        title: const Text(
          'Stock Movement Report',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kGold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading || state is TransactionInitial) {
            return const Center(child: CircularProgressIndicator(color: kGold));
          } else if (state is TransactionError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: kError)),
            );
          }

          final allEntries = (state as TransactionLoaded).transactions;
          final filteredEntries = _getFilteredEntries(allEntries);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPageHeader(isDesktop),
                  const SizedBox(height: 24),
                  _buildFiltersPanel(isDesktop),
                  const SizedBox(height: 24),
                  _buildDataView(isDesktop, filteredEntries),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageHeader(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Stock Movement Report',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: kText,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Detailed chronological record of all inventory transactions.',
          style: TextStyle(fontSize: 13, color: kMuted),
        ),
      ],
    );
  }

  Widget _buildFiltersPanel(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.1)),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          // Metal Type Dropdown
          SizedBox(
            width: isDesktop ? 200 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'METAL TYPE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: kMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: kCardHigh,
                    border: Border(
                      bottom: BorderSide(
                        color: kDivider.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMetal,
                      dropdownColor: kCardHigh,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: kGold),
                      style: const TextStyle(color: kText, fontSize: 13),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMetal = newValue;
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'All Materials',
                          child: Text('All Materials'),
                        ),
                        DropdownMenuItem(
                          value: 'Gold',
                          child: Text('Gold'),
                        ),
                        DropdownMenuItem(
                          value: 'Jewellery',
                          child: Text('Jewellery'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Movement Type (ALL | IN | OUT)
          SizedBox(
            width: isDesktop ? 220 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MOVEMENT TYPE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: kMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildTypeToggle('ALL'),
                    const SizedBox(width: 8),
                    _buildTypeToggle('IN'),
                    const SizedBox(width: 8),
                    _buildTypeToggle('OUT'),
                  ],
                ),
              ],
            ),
          ),

          // Reset button
          TextButton.icon(
            onPressed: _resetFilters,
            icon: const Icon(Icons.refresh, size: 16, color: kGold),
            label: const Text('Reset', style: TextStyle(color: kGold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle(String type) {
    final active = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? kGold.withValues(alpha: 0.15) : kCardHigh,
            border: Border.all(
              color: active ? kGold : kDivider.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active ? kGold : kMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataView(bool isDesktop, List<TransactionModel> entries) {
    if (entries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: const [
            Icon(Icons.info_outline, color: kMuted, size: 48),
            SizedBox(height: 12),
            Text(
              'No transactions match the selected filters.',
              style: TextStyle(color: kMuted, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (isDesktop) {
      return Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDivider.withValues(alpha: 0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.8),
                3: FlexColumnWidth(1.2),
                4: FlexColumnWidth(1.2),
                5: FlexColumnWidth(2.0),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: kCardHigh.withValues(alpha: 0.5),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'DATE & TIME',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'METAL TYPE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'WEIGHT (G)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'RATE (₹/G)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text(
                        'CUSTOMER',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                ...entries.map((entry) {
                  final isIn = _isTxIn(entry);
                  final weight = entry.finalWeight ?? entry.weight ?? 0.0;
                  final rate = entry.goldRate ?? 0.0;
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: kDivider.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          DateFormat('MMM dd, yyyy · HH:mm').format(entry.createdAt.toLocal()),
                          style: const TextStyle(fontSize: 13, color: kText),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              isIn ? Icons.south_west : Icons.north_east,
                              color: isIn ? kGold : Colors.redAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isIn ? 'STOCK IN' : 'STOCK OUT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isIn ? kGold : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          _metalString(entry),
                          style: const TextStyle(fontSize: 13, color: kText),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          '${isIn ? '+' : '-'} ${weight.toStringAsFixed(2)} g',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isIn ? kGold : kText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          rate > 0 ? '₹ ${rate.toStringAsFixed(0)}' : '-',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 13, color: kMuted),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Text(
                          entry.customerName ?? 'Customer',
                          style: const TextStyle(fontSize: 13, color: kText),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      );
    } else {
      // Mobile View
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: entries.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final isIn = _isTxIn(entry);
          final weight = entry.finalWeight ?? entry.weight ?? 0.0;
          final rate = entry.goldRate ?? 0.0;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDivider.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy · HH:mm').format(entry.createdAt.toLocal()),
                      style: const TextStyle(fontSize: 11, color: kMuted),
                    ),
                    Row(
                      children: [
                        Icon(
                          isIn ? Icons.south_west : Icons.north_east,
                          color: isIn ? kGold : Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isIn ? 'STOCK IN' : 'STOCK OUT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isIn ? kGold : Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_metalString(entry)} · ${entry.customerName ?? 'Customer'}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '${isIn ? '+' : '-'} ${weight.toStringAsFixed(2)} g',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isIn ? kGold : kText,
                      ),
                    ),
                  ],
                ),
                if (rate > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Rate: ₹ ${rate.toStringAsFixed(0)}/g',
                    style: const TextStyle(fontSize: 11, color: kMuted),
                  ),
                ],
              ],
            ),
          );
        },
      );
    }
  }
}
