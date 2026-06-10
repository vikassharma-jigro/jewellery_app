import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../storage/auth_storage.dart';
import '../../data/datasources/customer_api_service.dart';
import '../../data/datasources/auth_api_service.dart';
import '../../data/repositories_impl/customer_repository_impl.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../../presentation/state/customer_cubit.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../presentation/state/auth_cubit.dart';
import '../../data/datasources/dashboard_api_service.dart';
import '../../data/repositories_impl/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/dashboard_usecases.dart';
import '../../presentation/state/dashboard_cubit.dart';
import '../../data/datasources/stock_api_service.dart';
import '../../data/repositories_impl/stock_repository_impl.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/usecases/stock_usecases.dart';
import '../../presentation/state/stock_cubit.dart';
import '../../data/datasources/transaction_api_service.dart';
import '../../data/repositories_impl/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/transaction_usecases.dart';
import '../../presentation/state/transaction_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Core / Storage
  sl.registerLazySingleton<AuthStorage>(() => AuthStorage());

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  // Data sources
  sl.registerLazySingleton<AuthApiService>(
    () => AuthApiService(sl(), sl()),
  );
  sl.registerLazySingleton<DashboardApiService>(
    () => DashboardApiService(sl()),
  );
  sl.registerLazySingleton<StockApiService>(
    () => StockApiService(sl()),
  );
  sl.registerLazySingleton<TransactionApiService>(
    () => TransactionApiService(sl()),
  );
  sl.registerLazySingleton<CustomerApiService>(
    () => CustomerApiService(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<CheckAuthStatusUsecase>(() => CheckAuthStatusUsecase(sl()));
  sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl()));
  sl.registerLazySingleton<UpdateProfileUsecase>(() => UpdateProfileUsecase(sl()));
  sl.registerLazySingleton<GetDashboardSummaryUsecase>(() => GetDashboardSummaryUsecase(sl()));
  sl.registerLazySingleton<GetGlobalBalanceUsecase>(() => GetGlobalBalanceUsecase(sl()));
  sl.registerLazySingleton<GetStockLedgerUsecase>(() => GetStockLedgerUsecase(sl()));
  sl.registerLazySingleton<CreateTransactionUsecase>(() => CreateTransactionUsecase(sl()));
  sl.registerLazySingleton<GetCustomerTransactionsUsecase>(() => GetCustomerTransactionsUsecase(sl()));
  
  sl.registerLazySingleton<GetCustomersUsecase>(
    () => GetCustomersUsecase(sl()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(sl()),
  );
  sl.registerFactory<StockCubit>(
    () => StockCubit(sl(), sl()),
  );
  sl.registerFactory<TransactionCubit>(
    () => TransactionCubit(sl(), sl()),
  );
  sl.registerFactory<CustomerCubit>(
    () => CustomerCubit(sl()),
  );
}
