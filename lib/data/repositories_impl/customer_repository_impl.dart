import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_api_service.dart';
import '../models/customer_dto.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApiService _apiService;

  CustomerRepositoryImpl(this._apiService);

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    try {
      final dtos = await _apiService.getCustomers();
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CustomerEntity> createCustomer(CustomerEntity customer) async {
    try {
      final dto = CustomerDto.fromEntity(customer);
      final createdDto = await _apiService.createCustomer(dto);
      return createdDto.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
