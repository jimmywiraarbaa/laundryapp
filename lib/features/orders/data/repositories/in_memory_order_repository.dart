import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/domain/repositories/laundry_order_repository.dart';

class InMemoryLaundryOrderRepository implements LaundryOrderRepository {
  InMemoryLaundryOrderRepository()
      : _orders = [
          LaundryOrder(
            id: 'LD-001',
            customerName: 'Alya',
            createdAt: DateTime.now(),
            status: LaundryOrderStatus.pending,
          ),
          LaundryOrder(
            id: 'LD-002',
            customerName: 'Bima',
            createdAt: DateTime.now(),
            status: LaundryOrderStatus.washing,
          ),
        ];

  final List<LaundryOrder> _orders;

  @override
  Future<List<LaundryOrder>> fetchOrders() async {
    return List.unmodifiable(_orders);
  }

  @override
  Future<void> createOrder(LaundryOrder order) async {
    _orders.add(order);
  }
}
