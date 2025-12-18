enum LaundryOrderStatus { pending, washing, finished }

class LaundryOrder {
  const LaundryOrder({
    required this.id,
    required this.customerName,
    required this.createdAt,
    this.status = LaundryOrderStatus.pending,
  });

  final String id;
  final String customerName;
  final DateTime createdAt;
  final LaundryOrderStatus status;

  LaundryOrder copyWith({
    String? id,
    String? customerName,
    DateTime? createdAt,
    LaundryOrderStatus? status,
  }) {
    return LaundryOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}
