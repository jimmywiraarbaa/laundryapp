import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundryapp/features/orders/domain/entities/laundry_order.dart';
import 'package:laundryapp/features/orders/presentation/providers/order_providers.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Orders'),
        actions: [
          IconButton(
            onPressed: () => ref.read(ordersNotifierProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ordersState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ErrorState(
          message: 'Gagal memuat pesanan',
          onRetry: () => ref.read(ordersNotifierProvider.notifier).refresh(),
        ),
        data: (orders) => _OrdersList(
          orders: orders,
          onAdd: () => _showAddOrderDialog(context, ref),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOrderDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Pesanan Baru'),
      ),
    );
  }

  Future<void> _showAddOrderDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = TextEditingController();
    final customerName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Pesanan Baru'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Nama pelanggan',
            ),
            onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    final name = customerName?.trim();
    if (name == null || name.isEmpty) {
      return;
    }

    await ref.read(ordersNotifierProvider.notifier).addOrder(
          customerName: name,
        );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.onAdd,
  });

  final List<LaundryOrder> orders;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return _EmptyState(onAdd: onAdd);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        final subtitle =
            '${order.id} | ${_formatTime(order.createdAt)} | ${_statusLabel(order.status)}';
        final initial = order.customerName.trim().isEmpty
            ? '?'
            : order.customerName.trim()[0].toUpperCase();

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(initial),
            ),
            title: Text(order.customerName),
            subtitle: Text(subtitle),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_laundry_service, size: 48),
            const SizedBox(height: 12),
            Text(
              'Belum ada pesanan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Tambahkan pesanan pertama untuk memulai.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onAdd,
              child: const Text('Tambah Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final local = time.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _statusLabel(LaundryOrderStatus status) {
  switch (status) {
    case LaundryOrderStatus.pending:
      return 'Pending';
    case LaundryOrderStatus.washing:
      return 'Cuci';
    case LaundryOrderStatus.finished:
      return 'Selesai';
  }
}
