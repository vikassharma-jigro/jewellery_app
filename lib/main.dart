import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jewellary_stock/presentation/screens/calculator_screen.dart';

import 'core/api_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/customer_repository.dart';
import 'repositories/transaction_repository.dart';
import 'repositories/stock_repository.dart';
import 'repositories/dashboard_repository.dart';

import 'blocs/auth_cubit.dart';
import 'blocs/customer_cubit.dart';
import 'blocs/transaction_cubit.dart';
import 'blocs/stock_cubit.dart';
import 'blocs/dashboard_cubit.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();

  runApp(MyApp(apiService: apiService));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;

  const MyApp({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository(apiService)),
        RepositoryProvider(create: (context) => CustomerRepository(apiService)),
        RepositoryProvider(
          create: (context) => TransactionRepository(apiService),
        ),
        RepositoryProvider(create: (context) => StockRepository(apiService)),
        RepositoryProvider(
          create: (context) => DashboardRepository(apiService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(context.read<AuthRepository>())..checkAuthStatus(),
          ),
          BlocProvider(
            create: (context) =>
                CustomerCubit(context.read<CustomerRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                TransactionCubit(context.read<TransactionRepository>()),
          ),
          BlocProvider(
            create: (context) => StockCubit(context.read<StockRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                DashboardCubit(context.read<DashboardRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Jewellery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const CalculatorScreen(),
        ),
      ),
    );
  }
}
