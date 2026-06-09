import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'customer_ledger_screen.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final String name;
  final String phone;
  final String stock;
  final String payment;

  const CustomerDetailsScreen({
    super.key,
    required this.name,
    required this.phone,
    required this.stock,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("Customer Details"),
        backgroundColor: AppTheme.gold,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Customer Info Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppTheme.goldLight,
                    child: Text(
                      name[0],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.goldDark,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    phone,
                    style: const TextStyle(
                      color: AppTheme.muted,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _infoCard(
                          "Pending Stock",
                          stock,
                          Icons.inventory_2_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoCard(
                          "Pending Payment",
                          payment,
                          Icons.currency_rupee,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Actions
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [

                _actionButton(
                  context,
                  "Add Stock",
                  Icons.add_box,
                  Colors.green,
                ),

                _actionButton(
                  context,
                  "Receive Stock",
                  Icons.inventory,
                  Colors.orange,
                ),

                _actionButton(
                  context,
                  "Add Payment",
                  Icons.account_balance_wallet,
                  Colors.red,
                ),

                _actionButton(
                  context,
                  "Receive Payment",
                  Icons.payments,
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Transaction History
            Row(
              children: const [
                Text(
                  "Transaction History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _historyTile(
              "Stock Added",
              "+15 gm",
              "09 Jun 2026",
              Colors.green,
            ),

            _historyTile(
              "Payment Received",
              "₹10,000",
              "08 Jun 2026",
              Colors.blue,
            ),

            _historyTile(
              "Stock Received",
              "-5 gm",
              "07 Jun 2026",
              Colors.orange,
            ),

            _historyTile(
              "Payment Added",
              "₹20,000",
              "05 Jun 2026",
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffFAF7EF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.gold),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
  Widget _actionButton(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionEntryScreen(
              title: title,
              isStock: title.contains("Stock"),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _historyTile(
      String title,
      String amount,
      String date,
      Color color,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(
            Icons.history,
            color: color,
          ),
        ),
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(
          amount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}