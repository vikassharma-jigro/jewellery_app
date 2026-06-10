import 'package:flutter/material.dart';
import 'package:jewellary_stock/screens/reports_details_screen.dart';
import '../theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/customer_cubit.dart';

class CustomerReportListScreen extends StatelessWidget {
  final String reportType;

  const CustomerReportListScreen({
    super.key,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F6F1),
      appBar: AppBar(
        title: Text(reportType),
        backgroundColor: AppTheme.goldDark,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.goldDark),
            );
          } else if (state is CustomerLoaded) {
            final customers = state.customers;

            if (customers.isEmpty) {
              return const Center(
                child: Text('No customers found.', style: TextStyle(color: AppTheme.muted)),
              );
            }

            return ListView.builder(
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
                      customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      customer.phone ?? 'N/A',
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
            );
          } else {
            return const Center(
              child: Text('Failed to load customers.', style: TextStyle(color: Colors.red)),
            );
          }
        },
      ),
    );
  }
}