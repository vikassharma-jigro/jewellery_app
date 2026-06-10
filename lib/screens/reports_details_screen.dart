import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/stock_cubit.dart';
import '../blocs/transaction_cubit.dart';
import '../data/models/transaction_model.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String title;

  const ReportDetailsScreen({
    super.key,
    required this.title,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.title == 'Stock Movement Report' || widget.title == 'Stock Summary Report' || widget.title == 'Gold Balance Report') {
        context.read<StockCubit>().fetchStockData();
      }
      if (widget.title == 'Daily Transaction Report' || widget.title == 'Monthly Sales Report') {
        context.read<TransactionCubit>().fetchTransactions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F6F1),
      appBar: AppBar(
        title: Text(widget.title),
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
    switch (widget.title) {

      case 'Customer Ledger Report':
        return [
          _card("Customer Name", "Rahul Sharma", Icons.person),
          _card("Mobile Number", "+91 9876543210", Icons.phone),
          _card("Gold Given", "125.40 gm", Icons.inventory),
          _card("Gold Received", "80.00 gm", Icons.check_circle_outline),
          _card("Balance Gold", "45.40 gm", Icons.account_balance_wallet),
        ];

      case 'Stock Movement Report':
      case 'Stock Summary Report':
        return [
          BlocBuilder<StockCubit, StockState>(
            builder: (context, state) {
              if (state is StockLoading) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator(color: AppTheme.goldDark)),
                );
              }
              if (state is StockLoaded) {
                double stockAdded = 0;
                double stockSold = 0;
                for (var entry in state.ledger) {
                  if (entry.type == TransactionType.stockIn) {
                    stockAdded += entry.weight;
                  } else if (entry.type == TransactionType.stockOut) {
                    stockSold += entry.weight;
                  }
                }
                double closingStock = state.summary.totalGold;
                double openingStock = closingStock - stockAdded + stockSold;

                return Column(
                  children: [
                    _card("Opening Stock", "${openingStock.toStringAsFixed(2)} gm", Icons.inventory),
                    _card("Stock Added", "${stockAdded.toStringAsFixed(2)} gm", Icons.add_circle_outline),
                    _card("Stock Sold", "${stockSold.toStringAsFixed(2)} gm", Icons.remove_circle_outline),
                    _card("Closing Stock", "${closingStock.toStringAsFixed(2)} gm", Icons.inventory_2),
                    _card("Last Updated", DateTime.now().toString().substring(0, 10), Icons.calendar_month),
                  ],
                );
              }
              return const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: Text('Failed to load stock data.')),
              );
            },
          ),
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
          BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) return const Center(child: CircularProgressIndicator(color: AppTheme.goldDark));
              if (state is TransactionLoaded) {
                final now = DateTime.now();
                final todayTx = state.transactions.where((t) => t.createdAt.year == now.year && t.createdAt.month == now.month && t.createdAt.day == now.day).toList();
                
                double todaySale = 0;
                double todayPurchase = 0;
                double cashReceived = 0;
                
                for (var t in todayTx) {
                   if (t.type == TransactionType.stockOut) todaySale += (t.amount ?? 0);
                   else if (t.type == TransactionType.stockIn) todayPurchase += (t.amount ?? 0);
                   else if (t.type == TransactionType.paymentIn) cashReceived += (t.amount ?? 0);
                }
                
                return Column(
                  children: [
                    _card("Today's Sale", "₹${todaySale.toStringAsFixed(2)}", Icons.trending_up),
                    _card("Today's Purchase", "₹${todayPurchase.toStringAsFixed(2)}", Icons.shopping_cart),
                    _card("Cash Received", "₹${cashReceived.toStringAsFixed(2)}", Icons.payments),
                    _card("Total Transactions", "${todayTx.length}", Icons.receipt_long),
                    _card("Date", now.toString().substring(0, 10), Icons.calendar_month),
                  ]
                );
              }
              return const Center(child: Text('Failed to load transactions.'));
            }
          ),
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
          BlocBuilder<StockCubit, StockState>(
            builder: (context, state) {
              if (state is StockLoading) return const Center(child: CircularProgressIndicator(color: AppTheme.goldDark));
              if (state is StockLoaded) {
                double goldPurchased = 0;
                double goldSold = 0;
                for (var entry in state.ledger) {
                  if (entry.metalType == MetalType.gold) {
                    if (entry.type == TransactionType.stockIn) {
                      goldPurchased += entry.weight;
                    } else if (entry.type == TransactionType.stockOut) {
                      goldSold += entry.weight;
                    }
                  }
                }
                double currentBalance = state.summary.totalGold;
                double openingGold = currentBalance - goldPurchased + goldSold;

                return Column(
                  children: [
                    _card("Opening Gold", "${openingGold.toStringAsFixed(2)} gm", Icons.account_balance_wallet),
                    _card("Gold Purchased", "${goldPurchased.toStringAsFixed(2)} gm", Icons.add_circle_outline),
                    _card("Gold Sold", "${goldSold.toStringAsFixed(2)} gm", Icons.remove_circle_outline),
                    _card("Current Balance", "${currentBalance.toStringAsFixed(2)} gm", Icons.inventory_2),
                  ],
                );
              }
              return const Center(child: Text('Failed to load stock data.'));
            }
          ),
        ];

      case 'Monthly Sales Report':
        return [
          BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) return const Center(child: CircularProgressIndicator(color: AppTheme.goldDark));
              if (state is TransactionLoaded) {
                final now = DateTime.now();
                final monthTx = state.transactions.where((t) => t.createdAt.year == now.year && t.createdAt.month == now.month).toList();
                
                double totalSales = 0;
                double goldSold = 0;
                int transactions = monthTx.length;
                
                for (var t in monthTx) {
                   if (t.type == TransactionType.stockOut) {
                       totalSales += (t.amount ?? 0);
                       if (t.metalType == MetalType.gold) {
                          goldSold += (t.weight ?? 0);
                       }
                   }
                }
                
                return Column(
                  children: [
                    _card("Month", "${now.month}/${now.year}", Icons.calendar_month),
                    _card("Total Sales", "₹${totalSales.toStringAsFixed(2)}", Icons.bar_chart),
                    _card("Gold Sold", "${goldSold.toStringAsFixed(2)} gm", Icons.inventory),
                    _card("Transactions", "$transactions", Icons.receipt_long),
                  ]
                );
              }
              return const Center(child: Text('Failed to load transactions.'));
            }
          ),
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