import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import 'add_customer_screen.dart';
import 'customer_details_screen.dart';
import '../blocs/customer/customer_cubit.dart';
import '../data/models/customer_model.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: BlocConsumer<CustomerCubit, CustomerState>(
          listener: (context, state) {
            if (state is CustomerOperationSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is CustomerError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            List<CustomerModel> customers = [];

            if (state is CustomerLoaded) {
              customers = state.customers;
              if (_searchQuery.isNotEmpty) {
                final query = _searchQuery.toLowerCase();
                customers = customers.where((c) {
                  final nameMatch = c.name.toLowerCase().contains(query);
                  final phoneMatch =
                      c.phone?.toLowerCase().contains(query) ?? false;
                  return nameMatch || phoneMatch;
                }).toList();
              }
            }

            return RefreshIndicator(
              onRefresh: () => context.read<CustomerCubit>().fetchCustomers(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  const Text(
                    'Customers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
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
                  if (state is CustomerLoading || state is CustomerInitial)
                    const Center(child: CircularProgressIndicator())
                  else if (customers.isEmpty)
                    const Center(child: Text('No customers found'))
                  else
                    ...customers.map((c) => _CustomerCard(customer: c)),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBg,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddCustomerScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final stock =
        '${customer.goldBalance.toStringAsFixed(2)}g Gold, ${customer.jewelleryBalance.toStringAsFixed(2)}g Jew.';
    final pay = '₹${customer.cashBalance.toStringAsFixed(2)}';
    final hasDue =
        customer.cashBalance < 0; // assuming negative balance means due

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailsScreen(
              customerId: customer.id,
              name: customer.name,
              phone: customer.phone ?? '',
              stock: stock,
              payment: pay,
            ),
          ),
        );
      },
      child: InkWell(
        onLongPress: () {
          _showCustomerActions(context, customer);
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
                    child: Text(
                      customer.name.isNotEmpty
                          ? customer.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppTheme.goldDark,
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
                          customer.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          customer.phone ?? 'No phone',
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasDue)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDEAE6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Due',
                        style: TextStyle(
                          color: AppTheme.danger,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                    width: 1,
                    height: 28,
                    color: const Color(0xFFEFE8D2),
                  ),
                  _MiniInfo(label: 'Pending Payment', value: pay),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomerActions(BuildContext context, CustomerModel customer) {
    showModalBottomSheet(
      backgroundColor: kBg,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.visibility_outlined),
                  title: const Text('View Details'),
                  onTap: () {
                    Navigator.pop(context);

                    // open details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerDetailsScreen(
                          customerId: customer.id,
                          name: customer.name,
                          phone: customer.phone ?? '',
                          stock:
                              '${customer.goldBalance.toStringAsFixed(2)}g Gold, ${customer.jewelleryBalance.toStringAsFixed(2)}g Jew.',
                          payment:
                              '₹${customer.cashBalance.toStringAsFixed(2)}',
                        ),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit Customer'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AddCustomerScreen(customer: customer, isEdit: true),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Delete Customer',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    _deleteCustomer(context, customer);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteCustomer(BuildContext context, CustomerModel customer) {
    final customerCubit = context.read<CustomerCubit>();

    showDialog(
      barrierColor: kBg,
      barrierDismissible: false,
      barrierLabel: 'Are you sure you want to delete ${customer.name}?',
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: kBg,
        title: const Text('Delete Customer?'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },

            style: TextButton.styleFrom(foregroundColor: AppTheme.muted),
            child: const Text('Cancel'),
          ),

          ElevatedButton(
            onPressed: () {
              customerCubit.deleteCustomer(customer.id);

              Navigator.of(dialogContext).pop();
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
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
          Text(
            label,
            style: const TextStyle(color: AppTheme.muted, fontSize: 11),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
