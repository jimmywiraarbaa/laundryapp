import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';

class LaundryOrderModel {
  const LaundryOrderModel({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String customerName;
  final DateTime createdAt;
  final LaundryOrderStatus status;

  LaundryOrder toEntity() {
    return LaundryOrder(
      id: id,
      customerName: customerName,
      createdAt: createdAt,
      status: status,
    );
  }

  factory LaundryOrderModel.fromEntity(LaundryOrder order) {
    return LaundryOrderModel(
      id: order.id,
      customerName: order.customerName,
      createdAt: order.createdAt,
      status: order.status,
    );
  }

  factory LaundryOrderModel.fromJson(Map<String, dynamic> json) {
    final id = _stringFromJson(json, ['id', 'order_id', 'uuid']);
    final customerName =
        _stringFromJson(json, ['customer_name', 'customerName', 'name']);
    final createdAt = _dateFromJson(json, ['created_at', 'createdAt']);
    final status =
        _statusFromJson(_stringFromJson(json, ['status'], fallback: 'pending'));

    return LaundryOrderModel(
      id: id,
      customerName: customerName,
      createdAt: createdAt,
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'created_at': createdAt.toIso8601String(),
      'status': _statusToJson(status),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'customer_name': customerName,
      'status': _statusToJson(status),
    };
  }

  static String _stringFromJson(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
      if (value != null) {
        return value.toString();
      }
    }
    return fallback;
  }

  static DateTime _dateFromJson(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return DateTime.now();
  }
}

LaundryOrderStatus _statusFromJson(String raw) {
  switch (raw.toLowerCase()) {
    case 'washing':
      return LaundryOrderStatus.washing;
    case 'finished':
      return LaundryOrderStatus.finished;
    case 'pending':
    default:
      return LaundryOrderStatus.pending;
  }
}

String _statusToJson(LaundryOrderStatus status) {
  switch (status) {
    case LaundryOrderStatus.washing:
      return 'washing';
    case LaundryOrderStatus.finished:
      return 'finished';
    case LaundryOrderStatus.pending:
      return 'pending';
  }
}
