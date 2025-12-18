import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/domain/repositories/laundry_order_repository.dart';

class CreateOrder {
  const CreateOrder(this.repository);

  final LaundryOrderRepository repository;

  Future<void> call(LaundryOrder order) {
    return repository.createOrder(order);
  }
}
