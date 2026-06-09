import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/reports_details_screen.dart';
import '../theme/app_theme.dart';

class CustomerReportListScreen extends StatelessWidget {
  final String reportType;

  const CustomerReportListScreen({
    super.key,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    final customers = [
      {
        'name': 'Rahul Sharma',
        'mobile': '9876543210',
        'gold': '125.40 gm',
        'payment': '₹45,000',
      },
      {
        'name': 'Anil Verma',
        'mobile': '9876543211',
        'gold': '80.20 gm',
        'payment': '₹25,000',
      },
      {
        'name': 'Meena Jewellers',
        'mobile': '9876543212',
        'gold': '150.00 gm',
        'payment': '₹65,000',
      },
      {
        'name': 'Vikas Gold',
        'mobile': '9876543213',
        'gold': '95.00 gm',
        'payment': '₹18,000',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF8F6F1),
      appBar: AppBar(
        title: Text(reportType),
        backgroundColor: AppTheme.goldDark,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFEFE8D2),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.goldLight,
                child: const Icon(
                  Icons.person,
                  color: AppTheme.goldDark,
                ),
              ),
              title: Text(
                customer['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                customer['mobile']!,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportDetailsScreen(
                      title: reportType,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}