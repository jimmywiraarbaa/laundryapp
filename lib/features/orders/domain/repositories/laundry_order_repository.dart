import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';

abstract class LaundryOrderRepository {
  Future<List<LaundryOrder>> fetchOrders();
  Future<void> createOrder(LaundryOrder order);
}
