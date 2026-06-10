import '../entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<List<CustomerEntity>> getCustomers();
  Future<CustomerEntity> createCustomer(CustomerEntity customer);
}
