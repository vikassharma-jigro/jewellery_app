import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReportDetailsScreen extends StatelessWidget {
  final String title;

  const ReportDetailsScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F6F1),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.goldDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._getReportData(),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export Feature Coming Soon'),
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Export Report'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldDark,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getReportData() {
    switch (title) {

      case 'Customer Ledger Report':
        return [
          _card("Customer Name", "Rahul Sharma", Icons.person),
          _card("Mobile Number", "+91 9876543210", Icons.phone),
          _card("Gold Given", "125.40 gm", Icons.inventory),
          _card("Gold Received", "80.00 gm", Icons.check_circle_outline),
          _card("Balance Gold", "45.40 gm", Icons.account_balance_wallet),
        ];

      case 'Stock Movement Report':
        return [
          _card("Opening Stock", "5,250 gm", Icons.inventory),
          _card("Stock Added", "250 gm", Icons.add_circle_outline),
          _card("Stock Sold", "175 gm", Icons.remove_circle_outline),
          _card("Closing Stock", "5,325 gm", Icons.inventory_2),
          _card("Last Updated", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'Payment Report':
        return [
          _card("Customer Name", "Rahul Sharma", Icons.person),
          _card("Total Amount", "₹80,000", Icons.currency_rupee),
          _card("Paid Amount", "₹35,000", Icons.payments),
          _card("Pending Amount", "₹45,000", Icons.warning_amber),
          _card("Last Payment", "05 Jun 2026", Icons.calendar_today),
        ];

      case 'Pending Stock Report':
        return [
          _card("Customer Name", "Anil Verma", Icons.person),
          _card("Pending Stock", "80.20 gm", Icons.inventory),
          _card("Due Date", "15 Jun 2026", Icons.event),
          _card("Status", "Pending", Icons.hourglass_bottom),
        ];

      case 'Daily Transaction Report':
        return [
          _card("Today's Sale", "₹1,25,000", Icons.trending_up),
          _card("Today's Purchase", "₹75,000", Icons.shopping_cart),
          _card("Cash Received", "₹50,000", Icons.payments),
          _card("Total Transactions", "28", Icons.receipt_long),
          _card("Date", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'All Customer Outstanding':
        return [
          _card("Total Customers", "25", Icons.people),
          _card("Outstanding Amount", "₹4,50,000", Icons.currency_rupee),
          _card("Pending Gold", "320 gm", Icons.inventory),
          _card("Last Updated", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'Gold Balance Report':
        return [
          _card("Opening Gold", "5000 gm", Icons.account_balance_wallet),
          _card("Gold Purchased", "350 gm", Icons.add_circle_outline),
          _card("Gold Sold", "220 gm", Icons.remove_circle_outline),
          _card("Current Balance", "5130 gm", Icons.inventory_2),
        ];

      case 'Monthly Sales Report':
        return [
          _card("Month", "June 2026", Icons.calendar_month),
          _card("Total Sales", "₹12,50,000", Icons.bar_chart),
          _card("Gold Sold", "850 gm", Icons.inventory),
          _card("Transactions", "145", Icons.receipt_long),
        ];

      case 'Customer Payment History':
        return [
          _card("Customer Name", "Rahul Sharma", Icons.person),
          _card("Total Amount", "₹80,000", Icons.currency_rupee),
          _card("Paid Amount", "₹65,000", Icons.payments),
          _card("Pending Amount", "₹15,000", Icons.warning_amber),
          _card("Last Payment Date", "05 Jun 2026", Icons.history),
        ];

      case 'Customer Wise Stock Report':
        return [
          _card("Customer Name", "Anil Verma", Icons.person),
          _card("Issued Stock", "150 gm", Icons.inventory),
          _card("Received Stock", "70 gm", Icons.check_circle_outline),
          _card("Pending Stock", "80 gm", Icons.hourglass_bottom),
          _card("Status", "Pending", Icons.info_outline),
        ];
      case 'Today Collection Report':
        return [
          _card("Today's Collection", "₹75,000", Icons.payments),
          _card("Cash Collection", "₹45,000", Icons.currency_rupee),
          _card("Online Collection", "₹30,000", Icons.account_balance),
          _card("Transactions", "18", Icons.receipt_long),
          _card("Date", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'Gold Purchase Report':
        return [
          _card("Gold Purchased", "450 gm", Icons.shopping_bag),
          _card("Purchase Amount", "₹28,50,000", Icons.currency_rupee),
          _card("Supplier", "Shree Gold Traders", Icons.business),
          _card("Purchase Date", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'Gold Sales Report':
        return [
          _card("Gold Sold", "325 gm", Icons.sell),
          _card("Sales Amount", "₹22,80,000", Icons.currency_rupee),
          _card("Total Bills", "35", Icons.receipt),
          _card("Date", "09 Jun 2026", Icons.calendar_month),
        ];

      case 'Customer Due Report':
        return [
          _card("Customer Name", "Rahul Sharma", Icons.person),
          _card("Due Amount", "₹45,000", Icons.warning_amber),
          _card("Due Date", "15 Jun 2026", Icons.event),
          _card("Status", "Overdue", Icons.error_outline),
        ];

      case 'Stock Summary Report':
        return [
          _card("Opening Stock", "5000 gm", Icons.inventory),
          _card("Stock Purchased", "450 gm", Icons.add_circle_outline),
          _card("Stock Sold", "325 gm", Icons.remove_circle_outline),
          _card("Current Stock", "5125 gm", Icons.inventory_2),
          _card("Last Updated", "09 Jun 2026", Icons.calendar_month),
        ];
      default:
        return [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                "No Data Available",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ];
    }
  }

  Widget _card(
      String title,
      String value,
      IconData icon,
      ) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.goldDark,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: AppTheme.muted,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      // trailing: const Icon(
      //   Icons.chevron_right,
      //   color: AppTheme.muted,
      // ),
    );
  }
}