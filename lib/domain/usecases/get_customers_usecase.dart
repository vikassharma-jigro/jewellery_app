import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class GetCustomersUsecase {
  final CustomerRepository repository;

  GetCustomersUsecase(this.repository);

  Future<List<CustomerEntity>> call() async {
    return await repository.getCustomers();
  }
}
