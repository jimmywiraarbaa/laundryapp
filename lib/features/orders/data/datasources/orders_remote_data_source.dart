import 'package:laundryapp/core/config/app_config.dart';
import 'package:laundryapp/core/networking/api_client.dart';
import 'package:laundryapp/features/orders/data/models/laundry_order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<LaundryOrderModel>> fetchOrders();
  Future<void> createOrder(LaundryOrderModel order);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<LaundryOrderModel>> fetchOrders() async {
    final response = await _apiClient.getJson(AppConfig.ordersPath);
    final items = _extractList(response);
    return items.map(LaundryOrderModel.fromJson).toList();
  }

  @override
  Future<void> createOrder(LaundryOrderModel order) async {
    await _apiClient.postJson(
      AppConfig.ordersPath,
      body: order.toCreateJson(),
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic response) {
    final data = response is Map<String, dynamic> && response['data'] is List
        ? response['data']
        : response;

    if (data is! List) {
      throw FormatException('Unexpected orders response');
    }

    return data.map((item) {
      if (item is Map<String, dynamic>) {
        return item;
      }
      if (item is Map) {
        return Map<String, dynamic>.from(item);
      }
      throw FormatException('Invalid order item format');
    }).toList();
  }
}
