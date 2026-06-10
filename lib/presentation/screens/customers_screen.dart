import '../../domain/entities/customer_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme.dart';
import '../widgets/common.dart';
import '../widgets/bottom_nav.dart';
import 'add_customer_screen.dart';
import '../state/customer_cubit.dart';
import '../state/customer_state.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<CustomerCubit>().fetchCustomers();
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    title: 'Customers',
    currentIndex: 2,
    fab: FloatingActionButton.extended(
      backgroundColor: kGold,
      foregroundColor: Colors.black,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddCustomerScreen()),
        ).then((_) {
          if (context.mounted) {
            context.read<CustomerCubit>().fetchCustomers();
          }
        });
      },
      icon: const Icon(Icons.add),
      label: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700)),
    ),
    body: BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoading || state is CustomerInitial) {
          return const Center(child: CircularProgressIndicator(color: kGold));
        } else if (state is CustomerError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: kError)),
          );
        }

        final allCustomers = (state as CustomerLoaded).customers;
        final customers = allCustomers.where((c) {
          final query = _searchQuery.toLowerCase();
          final name = ((c as dynamic)['fullName'] ?? '').toString().toLowerCase();
          final mobile = ((c as dynamic)['mobile'] ?? '').toString().toLowerCase();
          final email = ((c as dynamic)['email'] ?? '').toString().toLowerCase();
          return name.contains(query) ||
              mobile.contains(query) ||
              email.contains(query);
        }).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search customers...',
              ),
            ),
            const SizedBox(height: 16),
            if (customers.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No customers found',
                    style: TextStyle(color: kMuted),
                  ),
                ),
              ),
            ...customers.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SectionCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: kGold.withValues(alpha: .18),
                        child: Text(
                          ((c as dynamic)['fullName']?.toString() ?? '').isNotEmpty
                              ? (c as dynamic)['fullName'].toString()[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: kGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (c as dynamic)['fullName'] ?? 'Unknown',
                              style: const TextStyle(
                                color: kText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              (c as dynamic)['mobile'] ?? (c as dynamic)['email'] ?? 'No contact',
                              style: const TextStyle(
                                color: kMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${(c as dynamic)['outstandingBalance'] ?? 0}',
                            style: const TextStyle(
                              color: kGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GoldChip(
                            ((c as dynamic)['status'] ?? 'ACTIVE').toString().toUpperCase(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
