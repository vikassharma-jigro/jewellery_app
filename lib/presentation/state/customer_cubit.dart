import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  Future<void> addCustomer(dynamic customer) async {}
  final GetCustomersUsecase _getCustomersUsecase;

  CustomerCubit(this._getCustomersUsecase) : super(CustomerInitial());

  Future<void> fetchCustomers() async {
    emit(CustomerLoading());
    try {
      final customers = await _getCustomersUsecase.call();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
