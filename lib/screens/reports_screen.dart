import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/login_screen.dart';
import 'package:jewellary_stock/screens/reports_details_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title.dart';
import 'customer_report_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/customer_cubit.dart';

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
      context.read<CustomerCubit>().fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reports = [
      ('Customer Ledger Report', Icons.account_balance_wallet_outlined),
      ('Stock Movement Report', Icons.swap_vert_rounded),
      ('Daily Transaction Report', Icons.today_outlined),
      ('All Customer Outstanding', Icons.people_alt_outlined),
      ('Gold Balance Report', Icons.account_balance_wallet_outlined),
      ('Monthly Sales Report', Icons.bar_chart),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, customerState) {
                  final dynamicAlerts = <(String, String, IconData, Color)>[];

                  if (customerState is CustomerLoaded) {
                    for (final c in customerState.customers) {
                      if (c.goldBalance > 0) {
                        dynamicAlerts.add((
                          'Pending Stock Alert',
                          '${c.name} · ${c.goldBalance.toStringAsFixed(2)} g pending',
                          Icons.inventory_outlined,
                          AppTheme.goldDark,
                        ));
                      }

                      if (c.cashBalance > 0) {
                        dynamicAlerts.add((
                          'Pending Payment Alert',
                          '${c.name} · ₹${c.cashBalance.toStringAsFixed(2)} overdue',
                          Icons.warning_amber_rounded,
                          AppTheme.danger,
                        ));
                      }
                    }
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                    children: [
                      const Text(
                        'Reports',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 16),

                      const SectionTitle('Generate Report'),

                      const SizedBox(height: 12),

                      ...reports.map(
                        (r) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEFE8D2)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.goldLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(r.$2, color: AppTheme.goldDark),
                            ),
                            title: Text(
                              r.$1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: AppTheme.muted,
                            ),
                            onTap: () {
                              final customerReports = [
                                'Customer Ledger Report',
                                'All Customer Outstanding',
                                'Customer Payment History',
                                'Customer Wise Stock Report',
                                'Customer Due Report',
                              ];

                              if (customerReports.contains(r.$1)) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomerReportListScreen(
                                      reportType: r.$1,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ReportDetailsScreen(title: r.$1),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const SectionTitle('Notifications'),

                      const SizedBox(height: 12),

                      if (customerState is CustomerLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(
                              color: AppTheme.goldDark,
                            ),
                          ),
                        )
                      else if (dynamicAlerts.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'No pending alerts at this time.',
                            style: TextStyle(color: AppTheme.muted),
                          ),
                        )
                      else
                        ...dynamicAlerts.map(
                          (a) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0xFFEFE8D2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: a.$4.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(a.$3, color: a.$4),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        a.$1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        a.$2,
                                        style: const TextStyle(
                                          color: AppTheme.muted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.goldDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
