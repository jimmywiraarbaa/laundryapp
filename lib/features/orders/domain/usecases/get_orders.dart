import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/domain/repositories/laundry_order_repository.dart';

class GetOrders {
  const GetOrders(this.repository);

  final LaundryOrderRepository repository;

  Future<List<LaundryOrder>> call() {
    return repository.fetchOrders();
  }
}
