import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'add_customer_screen.dart';
import 'customer_details_screen.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = [
      ('Rahul Sharma', '+91 98765 43210', '125.40 g', '₹45,000', true),
      ('Meena Jewellers', '+91 98989 12121', '0.00 g', '₹0', false),
      ('Anil Verma', '+91 91111 22222', '80.20 g', '₹18,500', true),
      ('Suresh Bullion', '+91 90000 11111', '210.75 g', '₹78,000', true),
      ('Pooja Soni', '+91 93333 44444', '15.00 g', '₹2,800', true),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          Row(
            children: [
              const Text('Customers',
                  style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddCustomerScreen(),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by name or mobile',
              prefixIcon: const Icon(Icons.search),
              hintStyle: const TextStyle(color: AppTheme.muted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...customers.map((c) => _CustomerCard(
                name: c.$1,
                phone: c.$2,
                stock: c.$3,
                pay: c.$4,
                hasDue: c.$5,
              )),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final String name, phone, stock, pay;
  final bool hasDue;
  const _CustomerCard(
      {required this.name,
      required this.phone,
      required this.stock,
      required this.pay,
      required this.hasDue});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailsScreen(
              name: name,
              phone: phone,
              stock: stock,
              payment: pay,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFE8D2)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.goldLight,
                  child: Text(name[0],
                      style: const TextStyle(
                          color: AppTheme.goldDark,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(phone,
                          style: const TextStyle(
                              color: AppTheme.muted, fontSize: 12)),
                    ],
                  ),
                ),
                if (hasDue)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFDEAE6),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Due',
                        style: TextStyle(
                            color: AppTheme.danger,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: const Color(0xFFEFE8D2)),
            const SizedBox(height: 12),
            Row(
              children: [
                _MiniInfo(label: 'Pending Stock', value: stock),
                Container(
                    width: 1, height: 28, color: const Color(0xFFEFE8D2)),
                _MiniInfo(label: 'Pending Payment', value: pay),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label, value;
  const _MiniInfo({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: AppTheme.muted, fontSize: 11)),
          const SizedBox(height: 3),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}
