import 'package:laundryapp/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:laundryapp/features/orders/data/models/laundry_order_model.dart';
import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/domain/repositories/laundry_order_repository.dart';

class LaundryOrderRepositoryImpl implements LaundryOrderRepository {
  LaundryOrderRepositoryImpl({
    required OrdersRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final OrdersRemoteDataSource _remoteDataSource;

  @override
  Future<List<LaundryOrder>> fetchOrders() async {
    final models = await _remoteDataSource.fetchOrders();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createOrder(LaundryOrder order) async {
    final model = LaundryOrderModel.fromEntity(order);
    await _remoteDataSource.createOrder(model);
  }
}
