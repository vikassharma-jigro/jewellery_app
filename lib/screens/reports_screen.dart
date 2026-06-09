import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/reports_details_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/section_title.dart';
import 'customer_report_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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

    final alerts = [
      (
      'Pending Payment Alert',
      'Rahul Sharma · ₹45,000 overdue',
      Icons.warning_amber_rounded,
      AppTheme.danger
      ),
      (
      'Pending Stock Alert',
      'Anil Verma · 80.20 g pending',
      Icons.inventory_outlined,
      AppTheme.goldDark
      ),
      (
      'Due Transaction',
      'Meena Jewellers · Due tomorrow',
      Icons.event_note_outlined,
      const Color(0xFF6E48C9)
      ),
    ];

    return SafeArea(
      child: ListView(
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
                border: Border.all(
                  color: const Color(0xFFEFE8D2),
                ),
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
                  child: Icon(
                    r.$2,
                    color: AppTheme.goldDark,
                  ),
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
                        builder: (_) => ReportDetailsScreen(
                          title: r.$1,
                        ),
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

          ...alerts.map(
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
                      color: (a.$4 as Color).withOpacity(.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      a.$3,
                      color: a.$4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}