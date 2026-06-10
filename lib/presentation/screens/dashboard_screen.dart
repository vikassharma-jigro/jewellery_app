import '../../blocs/transaction_cubit.dart';
import '../../data/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../widgets/bottom_nav.dart';
import '../../blocs/dashboard_cubit.dart';

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
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    final isTablet = size.width > 600 && size.width <= 900;

    return AppScaffold(
      title: 'Aurelian Ledger',
      currentIndex: 0,
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator(color: kGold));
          } else if (state is DashboardError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: kError)),
            );
          }

          final data = (state as DashboardLoaded).summary;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Hero
                  _buildWelcomeHero(context, isDesktop),
                  const SizedBox(height: 24),

                  // Bento Grid Summary Cards
                  _buildSummaryCards(data, isDesktop),
                  const SizedBox(height: 32),

                  // Main Content Grid (Chart + Recent Ledger)
                  _buildRecentLedgerCard(data.recentTransactions),
                  const SizedBox(height: 32),

                  // Material Inventory Showcase Section
                  _buildShowcaseSection(isDesktop),
                  const SizedBox(
                    height: 80,
                  ), // extra padding for fab/bottom bar
                ],
              ),
            ),
          );
        },
      ),
      fab: _buildPremiumFAB(context),
    );
  }

  Widget _buildWelcomeHero(BuildContext context, bool isDesktop) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;

    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'ESTATE OVERVIEW',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: kGold,
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Vault Dashboard',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: kText,
          ),
        ),
      ],
    );

    final dateRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.calendar_today_outlined, size: 14, color: kMuted),
        const SizedBox(width: 6),
        Text(
          '${DateFormat('MMM d, yyyy').format(DateTime.now())} — Real-time',
          style: const TextStyle(fontSize: 12, color: kMuted),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleColumn, const SizedBox(height: 12), dateRow],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [titleColumn, dateRow],
    );
  }

  Widget _buildSummaryCards(dynamic summary, bool isDesktop) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: _buildValueCard(
                  'Receivables',
                  summary.totalReceivables.toString(),
                  'Pending payments from customers',
                  Icons.arrow_downward,
                  kGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildValueCard(
                  'Payables',
                  summary.totalPayables.toString(),
                  'Outstanding payments to suppliers',
                  Icons.arrow_upward,
                  kError,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildValueCard(
                  'Gold Stock',
                  '${summary.totalGold.toStringAsFixed(3)} g',
                  'Total fine gold weight',
                  Icons.diamond_outlined,
                  kGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildValueCard(
                  'Silver Stock',
                  '${summary.totalSilver.toStringAsFixed(3)} g',
                  'Total fine silver weight',
                  Icons.diamond_outlined,
                  const Color(0xFFC0C0C0), // Silver color
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildValueCard(
                    'Receivables',
                    summary.totalReceivables.toString(),
                    'Pending payments',
                    Icons.arrow_downward,
                    kGold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildValueCard(
                    'Payables',
                    summary.totalPayables.toString(),
                    'Outstanding',
                    Icons.arrow_upward,
                    kError,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildValueCard(
                    'Gold',
                    '${summary.totalGold.toStringAsFixed(3)} g',
                    'Fine gold',
                    Icons.diamond_outlined,
                    kGold,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildValueCard(
                    'Silver',
                    '${summary.totalSilver.toStringAsFixed(3)} g',
                    'Fine silver',
                    Icons.diamond_outlined,
                    const Color(0xFFC0C0C0),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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

  Widget _buildRecentLedgerCard(List<dynamic> recentTransactions) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Ledger',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kText,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: kGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentTransactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No recent transactions',
                  style: TextStyle(color: kMuted),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentTransactions.length,
              separatorBuilder: (_, __) => Divider(
                color: kDivider.withValues(alpha: 0.1),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final txn = recentTransactions[index];
                return _buildTransactionItem(txn);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic txn) {
    final isOut = txn.type == 'OUT';
    final amountText = isOut
        ? '-${txn.weight}g ${txn.metalType}'
        : '+${txn.weight}g ${txn.metalType}';

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
                  txn.customerName ?? 'Unknown',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Metal: ${txn.metalType} | Type: ${txn.type}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: kMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOut ? kError : kGold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                txn.createdAt.toString().split(' ')[0], // Date format simple
                style: const TextStyle(
                  fontSize: 12,
                  color: kMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShowcaseSection(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildShowcaseCard(
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCwo-lPRmisGIq7KKVPg_Balfq8HcbO_jy90J9XBDecCfDR1vDmBIsFQYCoUO180SxzChGoaaG-MDZhWT-3qPcwbZ8JQQEPmWL-a-XbVsyhwMpdnCCRHXJO7x0Aw3kOVBJx7iYMZ0ul0_p_LlxFRf2V4LTJD4kobF5FFUiin2zGKCYqP_GEGlZ5Sn1tiCGjo1O96DSoj5LjYQS8IbIam5AmJpClHaPqjoe0rjA7bS2lEu1YiRfFeo7N9Su5YOhg7XUl49wT7qhJparT',
                title: 'Gold Assay Status',
                subtitle: 'Verify purity and hallmarking certifications',
              ),
            ),
            if (isDesktop) const SizedBox(width: 24),
            if (isDesktop)
              Expanded(
                child: _buildShowcaseCard(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuA6FHyt0IIypJYDSyMeY--Ox_Hp8dESl49SFS9rty4mbCSKSGaIi0PByj4E3hmrxg26NzrYXJXDNG4VUR2Z-Rlk6w89gaGbnLrZsZC7SmIBS771kq1d16-7qPUo2Y1C5b2179xogtqOYmvC82fpUeQRMaCKLSZqe8naJW14PnR3orIWXhv2-DFDW-RR7qD-xCr33ghIxvU6EeExkdPfzOFLYVpcL6dnhDCLxgnUdpkjACWr-0rKdYam3kfXLRVG2m4lnK9Yy9nInXN6',
                  title: 'Material Inspection',
                  subtitle: 'Daily quality control for incoming raw inventory',
                ),
              ),
          ],
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 24),
          _buildShowcaseCard(
            imageUrl:
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA6FHyt0IIypJYDSyMeY--Ox_Hp8dESl49SFS9rty4mbCSKSGaIi0PByj4E3hmrxg26NzrYXJXDNG4VUR2Z-Rlk6w89gaGbnLrZsZC7SmIBS771kq1d16-7qPUo2Y1C5b2179xogtqOYmvC82fpUeQRMaCKLSZqe8naJW14PnR3orIWXhv2-DFDW-RR7qD-xCr33ghIxvU6EeExkdPfzOFLYVpcL6dnhDCLxgnUdpkjACWr-0rKdYam3kfXLRVG2m4lnK9Yy9nInXN6',
            title: 'Material Inspection',
            subtitle: 'Daily quality control for incoming raw inventory',
          ),
        ],
      ],
    );
  }

  Widget _buildShowcaseCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kDivider.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: kCardHigh),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: kMuted.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddTransactionDialog(context),
      backgroundColor: kGold,
      foregroundColor: const Color(0xFF241A00),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      icon: const Icon(Icons.add, size: 24),
      label: const Text(
        'ADD TRANSACTION',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final nameController = TextEditingController();
    final metalController = TextEditingController();
    final amountController = TextEditingController();
    final timeController = TextEditingController(text: 'Date Timex');
    String selectedType = 'Sold';

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
                            'Log Vault Transaction',
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
                        'ITEM NAME / DESCRIPTION',
                        style: TextStyle(
                          fontSize: 10,
                          color: kMuted,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(fontSize: 14, color: kText),
                        decoration: const InputDecoration(
                          hintText: 'e.g. Bespoke Wedding Band',
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
                                  'METAL DETAILS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: metalController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kText,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. 18.5g Gold',
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
                                  'TRANSACTION TYPE',
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
                                      value: selectedType,
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
                                            selectedType = newValue;
                                          });
                                        }
                                      },
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'Sold',
                                          child: Text('Sold'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Purchase',
                                          child: Text('Purchase'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Credit',
                                          child: Text('Credit'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Inventory',
                                          child: Text('Inventory'),
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
                                  'PRICE / VALUE (₹)',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kText,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'e.g. 2,450',
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
                                  'TIME / DATE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kMuted,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: timeController,
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );
                                    if (date != null && context.mounted) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (time != null && context.mounted) {
                                        timeController.text =
                                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${time.format(context)}";
                                      }
                                    }
                                  },
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: kText,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: 'Date Time',
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
                                  if (nameController.text.trim().isEmpty ||
                                      metalController.text.trim().isEmpty ||
                                      amountController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please fill out all fields.',
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                    return;
                                  }

                                  final name = nameController.text.trim();
                                  final metal = metalController.text.trim();
                                  final amountText = amountController.text
                                      .trim();
                                  String prefix = '';
                                  if (selectedType == 'Sold') {
                                    prefix = '+';
                                  } else if (selectedType == 'Purchase') {
                                    prefix = '-';
                                  } else if (selectedType == 'Credit') {
                                    prefix = '+';
                                  } else {
                                    prefix = '';
                                  }

                                  final formattedAmount =
                                      '$prefix\$$amountText';

                                  String mappedType = 'Inward';
                                  if (selectedType == 'Sold') {
                                    mappedType = 'Sale';
                                  } else if (selectedType == 'Purchase') {
                                    mappedType = 'Inward';
                                  } else if (selectedType == 'Credit') {
                                    mappedType = 'Outward';
                                  }

                                  context
                                      .read<TransactionCubit>()
                                      .createTransaction(
                                        customerId: '',
                                        type: (mappedType == 'Sale' || mappedType == 'Outward') ? TransactionType.stockOut : TransactionType.stockIn,
                                        metalType: metal.toLowerCase().contains('silver') ? MetalType.silver : MetalType.gold,
                                        amount: double.tryParse(amountText) ?? 0,
                                        remark: 'Entity: $name - Added via Dashboard dialog',
                                      )
                                      .then((_) {
                                        if (!context.mounted) return;
                                        context
                                            .read<DashboardCubit>()
                                            .fetchDashboardSummary();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Logged: $name ($formattedAmount)',
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      });
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
