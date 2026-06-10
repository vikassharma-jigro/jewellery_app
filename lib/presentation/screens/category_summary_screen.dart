import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../theme/theme.dart';
import '../widgets/bottom_nav.dart';
import 'inventory_screen.dart';
import 'new_stock_screen.dart';
import '../state/stock_cubit.dart';
import '../state/stock_state.dart';
import '../state/market_rate_cubit.dart';

class CategorySummaryScreen extends StatefulWidget {
  const CategorySummaryScreen({super.key});

  @override
  State<CategorySummaryScreen> createState() => _CategorySummaryScreenState();
}

class _CategorySummaryScreenState extends State<CategorySummaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StockCubit>().fetchInventory();
    context.read<MarketRateCubit>().fetchRates();
  }

  // --- Helpers to derive category data from raw inventory items ---

  /// Group items by their 'category' field and compute summary stats.
  List<Map<String, dynamic>> _buildCategoryList(List<dynamic> items) {
    final Map<String, List<dynamic>> grouped = {};
    for (final item in items) {
      final cat = (item['category'] ?? 'Other').toString();
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final catItems = entry.value;
      final totalValue = catItems.fold<double>(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['valuation']?.toString() ?? '0') ?? 0),
      );
      final totalWeight = catItems.fold<double>(
        0,
        (sum, item) =>
            sum + (double.tryParse(item['weight']?.toString() ?? '0') ?? 0),
      );

      return {
        'title': entry.key,
        'pieces':
            '${catItems.length} ${catItems.length == 1 ? 'Piece' : 'Pieces'}',
        'metal': entry.key.toUpperCase(),
        'val': _formatCurrency(totalValue),
        'weight': '${totalWeight.toStringAsFixed(2)}g',
      };
    }).toList();
  }

  /// Get the last N items sorted by createdAt descending.
  List<dynamic> _getRecentItems(List<dynamic> items, {int limit = 5}) {
    final sorted = List<dynamic>.from(items);
    sorted.sort((a, b) {
      final dateA = a['createdAt']?.toString() ?? '';
      final dateB = b['createdAt']?.toString() ?? '';
      return dateB.compareTo(dateA);
    });
    return sorted.take(limit).toList();
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    return formatter.format(value);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return dateStr.length > 10 ? dateStr.substring(0, 10) : dateStr;
    }
  }

  // Category icon mapping
  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'gold':
        return Icons.star;
      case 'silver':
        return Icons.brightness_6;
      case 'diamond':
        return Icons.diamond;
      case 'watch':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return AppScaffold(
      title: 'Stock',
      currentIndex: 1,
      body: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          if (state is StockLoading || state is StockInitial) {
            return const Center(child: CircularProgressIndicator(color: kGold));
          } else if (state is StockError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: const TextStyle(color: kError)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<StockCubit>().fetchInventory(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final items = state is StockLoaded ? state.items : [];
          final categories = _buildCategoryList(items);
          final recentItems = _getRecentItems(items);

          return RefreshIndicator(
            color: kGold,
            onRefresh: () async {
              context.read<StockCubit>().fetchInventory();
              context.read<MarketRateCubit>().fetchRates();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    _buildHeader(context, isDesktop),
                    const SizedBox(height: 24),

                    // Categories Grid title
                    Text(
                      'COLLECTION CATEGORIES (${categories.length})',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: kMuted,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Categories Bento Grid
                    if (categories.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: kCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: kDivider.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              color: kMuted,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No inventory items yet',
                              style: TextStyle(color: kMuted, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NewStockScreen(),
                                  ),
                                ).then((_) {
                                  if (context.mounted) {
                                    context
                                        .read<StockCubit>()
                                        .fetchInventory();
                                  }
                                });
                              },
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Add First Item'),
                            ),
                          ],
                        ),
                      )
                    else
                      _buildCategoriesGrid(
                        context,
                        isDesktop,
                        isTablet,
                        categories,
                      ),
                    const SizedBox(height: 32),

                    // Recent Items table
                    _buildRecentItemsCard(isDesktop, recentItems),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'INVENTORY OVERVIEW',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: kGold,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Stock Collection',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: kText,
          ),
        ),
      ],
    );

    final buttonsWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: isDesktop ? 0 : 1,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewStockScreen()),
              ).then((_) {
                if (context.mounted) {
                  context.read<StockCubit>().fetchInventory();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: const Color(0xFF241A00),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text(
              'ADD NEW',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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

  // Widget _buildMarketTicker(bool isDesktop) {
  //   return BlocBuilder<MarketRateCubit, MarketRateState>(
  //     builder: (context, state) {
  //       // Extract rates if available
  //       String goldPrice = '--';
  //       String silverPrice = '--';
  //       String goldChange = '--';
  //       String silverChange = '--';
  //       Color goldChangeColor = kMuted;
  //       Color silverChangeColor = kMuted;

  //       if (state is MarketRateLoaded && state.rates.isNotEmpty) {
  //         final rates = state.rates;
  //         if (rates.containsKey('Gold')) {
  //           final goldRate = rates['Gold']?['ratePerGram'];
  //           goldPrice = '₹${goldRate ?? '--'}';
  //           goldChange = '+0.4%';
  //           goldChangeColor = kGoldSoft;
  //         }
  //         if (rates.containsKey('Silver')) {
  //           final silverRate = rates['Silver']?['ratePerGram'];
  //           silverPrice = '₹${silverRate ?? '--'}';
  //           silverChange = '-0.1%';
  //           silverChangeColor = kError;
  //         }
  //       }
  //     },
  //   );
  // }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> cat) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InventoryScreen()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kDivider.withValues(alpha: 0.3)),
          gradient: LinearGradient(
            colors: [kGold.withValues(alpha: 0.04), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kDivider.withValues(alpha: 0.2)),
                  ),
                  child: Icon(
                    _iconForCategory(cat['title'] ?? ''),
                    color: kGold,
                    size: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cat['weight'] ?? '',
                    style: const TextStyle(
                      color: kGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cat['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cat['pieces'] ?? '',
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kDivider.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cat['metal'] ?? '',
                        style: const TextStyle(
                          fontSize: 9,
                          color: kGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: kDivider, height: 1),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATEGORY VALUE',
                  style: TextStyle(
                    fontSize: 9,
                    color: kMuted,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cat['val'] ?? '₹0.00',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kText,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
    List<Map<String, dynamic>> categories,
  ) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;

    if (isMobile) {
      return Column(
        children: categories
            .map(
              (cat) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCategoryCard(context, cat),
              ),
            )
            .toList(),
      );
    }

    int crossAxisCount = isDesktop ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: isDesktop ? 1.15 : 1.35,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(context, categories[index]);
      },
    );
  }

  Widget _buildRecentItemsCard(bool isDesktop, List<dynamic> recentItems) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.1)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: kCardHigh.withValues(alpha: 0.3),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recently Added Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                Text(
                  '${recentItems.length} items',
                  style: const TextStyle(fontSize: 12, color: kMuted),
                ),
              ],
            ),
          ),
          if (recentItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No items added yet',
                  style: TextStyle(color: kMuted),
                ),
              ),
            )
          else if (isDesktop)
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(2.0),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.0),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1.2),
              },
              children: [
                // Table Header
                TableRow(
                  decoration: BoxDecoration(
                    color: kCardHigh.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: kDivider.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  children: const [
                    _TableHeader('DATE'),
                    _TableHeader('ITEM NAME'),
                    _TableHeader('CATEGORY'),
                    _TableHeader('WEIGHT'),
                    _TableHeader('VALUATION', align: TextAlign.right),
                    _TableHeader('STATUS', align: TextAlign.right),
                  ],
                ),
                // Rows
                ...recentItems.map((item) {
                  final status = (item['status'] ?? 'Available').toString();
                  final statusColor = status.toLowerCase() == 'available'
                      ? Colors.greenAccent
                      : Colors.orangeAccent;

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
                      _TableCell(_formatDate(item['createdAt']?.toString())),
                      _TableCell(item['name']?.toString() ?? 'Unnamed'),
                      _TableCell(item['category']?.toString() ?? 'Other'),
                      _TableCell('${item['weight'] ?? 0}g'),
                      _TableCell(
                        _formatCurrency(
                          double.tryParse(
                                item['valuation']?.toString() ?? '0',
                              ) ??
                              0,
                        ),
                        align: TextAlign.right,
                        color: kGold,
                        bold: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
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
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentItems.length,
              separatorBuilder: (context, index) =>
                  Divider(color: kDivider.withValues(alpha: 0.1), height: 1),
              itemBuilder: (context, index) {
                final item = recentItems[index];
                final status = (item['status'] ?? 'Available').toString();
                final statusColor = status.toLowerCase() == 'available'
                    ? Colors.greenAccent
                    : Colors.orangeAccent;
                final valuation =
                    double.tryParse(item['valuation']?.toString() ?? '0') ?? 0;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name']?.toString() ?? 'Unnamed',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatCurrency(valuation),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kGold,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${_formatDate(item['createdAt']?.toString())} • ${item['category'] ?? 'Other'} • ${item['weight'] ?? 0}g',
                      style: const TextStyle(fontSize: 11, color: kMuted),
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// --- Reusable table cell helpers ---

class _TableHeader extends StatelessWidget {
  final String text;
  final TextAlign align;
  const _TableHeader(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: kMuted,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final TextAlign align;
  final Color? color;
  final bool bold;
  const _TableCell(
    this.text, {
    this.align = TextAlign.left,
    this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: align == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: color ?? kText,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
