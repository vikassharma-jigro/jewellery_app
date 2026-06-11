import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../blocs/transaction_cubit.dart';

class StockMovementScreen extends StatefulWidget {
  const StockMovementScreen({super.key});

  @override
  State<StockMovementScreen> createState() => _StockMovementScreenState();
}

class _StockMovementScreenState extends State<StockMovementScreen> {
  String _selectedMetal = 'All Materials';
  String _selectedType = 'ALL'; // ALL | IN | OUT
  int _activePage = 1;

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().fetchTransactions();
  }

  List<dynamic> _getFilteredEntries(List<dynamic> allEntries) {
    return allEntries.where((entry) {
      final metal = entry['metal'] ?? '';
      final matchesMetal =
          _selectedMetal == 'All Materials' || metal == _selectedMetal;
      final matchesType =
          _selectedType == 'ALL' ||
          (entry['type']?.toUpperCase() == _selectedType);
      return matchesMetal && matchesType;
    }).toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedMetal = 'All Materials';
      _selectedType = 'ALL';
      _activePage = 1;
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
                  // Page Header & Actions
                  _buildPageHeader(isDesktop),
                  const SizedBox(height: 24),

                  // Filters Panel
                  _buildFiltersPanel(isDesktop),
                  const SizedBox(height: 24),

                  // Data Table or List Card
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
    final titleWidget = Column(
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

    final buttonsWidget = Row(
      children: [
        Expanded(
          flex: isDesktop ? 0 : 1,
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: kGold,
              side: const BorderSide(color: kGold),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text(
              'EXPORT PDF',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: isDesktop ? 0 : 1,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: const Color(0xFF241A00),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.table_view_outlined, size: 16),
            label: const Text(
              'EXPORT EXCEL',
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
          // Date Range picker mock
          SizedBox(
            width: isDesktop ? 220 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DATE RANGE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: kMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kCardHigh,
                    border: Border(
                      bottom: BorderSide(
                        color: kDivider.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Oct 01, 2023 - Oct 31, 2023',
                        style: TextStyle(fontSize: 13, color: kText),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: kMuted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

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
                          value: '18K Yellow Gold',
                          child: Text('18K Yellow Gold'),
                        ),
                        DropdownMenuItem(
                          value: '22K Yellow Gold',
                          child: Text('22K Yellow Gold'),
                        ),
                        DropdownMenuItem(
                          value: '950 Platinum',
                          child: Text('950 Platinum'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Type toggle
          SizedBox(
            width: isDesktop ? 220 : double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TYPE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: kMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: kCardHigh,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kDivider.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      _buildTypeTab('ALL'),
                      _buildTypeTab('IN'),
                      _buildTypeTab('OUT'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reset button
          GestureDetector(
            onTap: _resetFilters,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.filter_alt_off_outlined, color: kMuted, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'RESET FILTERS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: kMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTab(String type) {
    final active = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active
                ? kGoldContainer.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: active ? kGold.withValues(alpha: 0.4) : Colors.transparent,
            ),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: active ? kGold : kMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataView(bool isDesktop, List<dynamic> entries) {
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
                4: FlexColumnWidth(1.0),
                5: FlexColumnWidth(2.0),
                6: FlexColumnWidth(1.2),
              },
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(
                    color: kCardHigh.withValues(alpha: 0.5),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Text(
                        'QTY (G)',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Text(
                        'RATE',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Text(
                        'STAFF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: kMuted,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
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
                  ],
                ),
                // Table Body Rows
                ...entries.map((entry) {
                  final isIn = entry['type'] == 'IN';
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
                      // Date & Time
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['createdAt'] != null
                                  ? DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(DateTime.parse(entry['createdAt']))
                                  : 'Unknown Date',
                              style: const TextStyle(
                                fontSize: 13,
                                color: kText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              entry['createdAt'] != null
                                  ? DateFormat(
                                      'HH:mm a',
                                    ).format(DateTime.parse(entry['createdAt']))
                                  : 'Unknown Time',
                              style: const TextStyle(
                                fontSize: 11,
                                color: kMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Type (STOCK IN / OUT)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
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
                      // Metal Type
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: kDivider),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry['metal'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 10,
                              color: kText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Qty
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Text(
                          '${isIn ? '+' : '-'} ${entry['amount']?.toString() ?? '0'}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isIn ? kGold : kText,
                          ),
                        ),
                      ),
                      // Rate
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Text(
                          '\$ ${entry['amount']?.toString() ?? '0'}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 13, color: kMuted),
                        ),
                      ),
                      // Staff
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: kGoldContainer.withValues(
                                alpha: 0.2,
                              ),
                              child: Text(
                                entry['entityName'] != null
                                    ? entry['entityName']
                                          .substring(0, 1)
                                          .toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: kGold,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry['entityName'] ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 13,
                                color: kText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (entry['status'] == 'COMPLETED'
                                          ? Colors.greenAccent
                                          : Colors.orangeAccent)
                                      .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: entry['status'] == 'COMPLETED'
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  entry['status'] ?? 'PENDING',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: entry['status'] == 'COMPLETED'
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            _buildPaginationBar(),
          ],
        ),
      );
    } else {
      // Mobile List Card view
      return Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final isIn = entry['type'] == 'IN';
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kDivider.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${entry['date']} • ${entry['time']}',
                          style: const TextStyle(fontSize: 11, color: kMuted),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (entry['status'] == 'COMPLETED'
                                        ? Colors.greenAccent
                                        : Colors.orangeAccent)
                                    .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            entry['status'] ?? 'PENDING',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: entry['status'] == 'COMPLETED'
                                  ? Colors.greenAccent
                                  : Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isIn ? kGold : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${isIn ? '+' : '-'} ${entry['amount']?.toString() ?? '0'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isIn ? kGold : kText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Metal: ${entry['metal']}',
                          style: const TextStyle(fontSize: 12, color: kText),
                        ),
                        Text(
                          'Rate: \$ ${entry['amount']?.toString() ?? '0'}',
                          style: const TextStyle(fontSize: 12, color: kMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: kDivider, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: kGoldContainer.withValues(
                            alpha: 0.2,
                          ),
                          child: Text(
                            entry['entityName'] != null
                                ? entry['entityName']
                                      .substring(0, 1)
                                      .toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: kGold,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry['entityName'] ?? 'Unknown User',
                          style: const TextStyle(fontSize: 12, color: kMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildPaginationBar(),
        ],
      );
    }
  }

  Widget _buildPaginationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: kCard2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Showing 1-4 of 4 entries',
            style: TextStyle(fontSize: 11, color: kMuted),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20, color: kMuted),
                onPressed: null, // disabled
              ),
              _buildPageButton(1),
              _buildPageButton(2),
              _buildPageButton(3),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20, color: kMuted),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(int page) {
    final active = _activePage == page;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activePage = page;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? kGold : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: active ? const Color(0xFF241A00) : kMuted,
          ),
        ),
      ),
    );
  }
}
