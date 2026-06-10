import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/customer_repository.dart';
import '../data/models/customer_model.dart';
import '../core/exceptions.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  final CustomerRepository _customerRepository;

  CustomerCubit(this._customerRepository) : super(CustomerInitial());

  Future<void> fetchCustomers() async {
    emit(CustomerLoading());
    try {
      final customers = await _customerRepository.getAllCustomers();
      emit(CustomerLoaded(customers));
    } on AppException catch (e) {
      emit(CustomerError(e.message));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> createCustomer({
    required String name,
    required String mobile,
    required String address,
    String? aadhaar,
    String? gst,
    double? goldBalance,
    double? silverBalance,
    double? paymentDue,
  }) async {
    emit(CustomerLoading());
    try {
      await _customerRepository.createCustomer(
        name: name,
        mobile: mobile,
        address: address,
        aadhaar: aadhaar,
        gst: gst,
        goldBalance: goldBalance,
        silverBalance: silverBalance,
        paymentDue: paymentDue,
      );
      emit(const CustomerOperationSuccess('Customer created successfully'));
      fetchCustomers();
    } on AppException catch (e) {
      emit(CustomerError(e.message));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> updateCustomer({
    required String id,
    String? name,
    String? mobile,
    String? address,
    String? aadhaar,
    String? gst,
  }) async {
    emit(CustomerLoading());
    try {
      await _customerRepository.updateCustomer(
        id: id,
        name: name,
        mobile: mobile,
        address: address,
        aadhaar: aadhaar,
        gst: gst,
      );
      emit(const CustomerOperationSuccess('Customer updated successfully'));
      fetchCustomers();
    } on AppException catch (e) {
      emit(CustomerError(e.message));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> deleteCustomer(String id) async {
    emit(CustomerLoading());
    try {
      await _customerRepository.deleteCustomer(id);
      emit(const CustomerOperationSuccess('Customer deleted successfully'));
      fetchCustomers();
    } on AppException catch (e) {
      emit(CustomerError(e.message));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
