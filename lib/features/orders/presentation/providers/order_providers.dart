import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryapp/core/providers/network_providers.dart';
import 'package:laundryapp/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:laundryapp/features/orders/data/repositories/laundry_order_repository_impl.dart';
import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/domain/repositories/laundry_order_repository.dart';
import 'package:laundryapp/features/orders/domain/usecases/create_order.dart';
import 'package:laundryapp/features/orders/domain/usecases/get_orders.dart';

final ordersRemoteDataSourceProvider = Provider<OrdersRemoteDataSource>((ref) {
  return OrdersRemoteDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});

final orderRepositoryProvider = Provider<LaundryOrderRepository>((ref) {
  return LaundryOrderRepositoryImpl(
    remoteDataSource: ref.watch(ordersRemoteDataSourceProvider),
  );
});

final getOrdersProvider = Provider<GetOrders>((ref) {
  return GetOrders(ref.watch(orderRepositoryProvider));
});

final createOrderProvider = Provider<CreateOrder>((ref) {
  return CreateOrder(ref.watch(orderRepositoryProvider));
});

class OrdersNotifier extends StateNotifier<AsyncValue<List<LaundryOrder>>> {
  OrdersNotifier({
    required GetOrders getOrders,
    required CreateOrder createOrder,
  })  : _getOrders = getOrders,
        _createOrder = createOrder,
        super(const AsyncValue.loading()) {
    _load();
  }

  final GetOrders _getOrders;
  final CreateOrder _createOrder;

  Future<void> _load() async {
    state = await AsyncValue.guard(() => _getOrders());
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _load();
  }

  Future<void> addOrder({required String customerName}) async {
    final order = LaundryOrder(
      id: _generateOrderId(),
      customerName: customerName,
      createdAt: DateTime.now(),
      status: LaundryOrderStatus.pending,
    );
    await _createOrder(order);
    await _load();
  }

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'LD-$timestamp';
  }
}

final ordersNotifierProvider =
    StateNotifierProvider<OrdersNotifier, AsyncValue<List<LaundryOrder>>>((ref) {
  return OrdersNotifier(
    getOrders: ref.watch(getOrdersProvider),
    createOrder: ref.watch(createOrderProvider),
  );
});
