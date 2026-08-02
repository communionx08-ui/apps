import 'package:swift_core/swift_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistoryNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    final backend = ref.watch(unifiedBackendProvider);
    backend.ordersStream.listen((orders) {
       state = orders.where((o) => o.customerId == 'USER_123').toList();
    });
    return backend.currentOrders.where((o) => o.customerId == 'USER_123').toList();
  }

  void placeOrder(Order order) {
    ref.read(unifiedBackendProvider).placeOrder(order);
  }

  void updateStatus(String orderId, OrderStatus status) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: status);
  }

  void cancelOrder(String orderId) {
    updateStatus(orderId, OrderStatus.cancelled);
  }

  Order? byId(String orderId) {
    try {
      return state.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  List<Order> get activeOrders => state.where((o) => o.isActive).toList();
  List<Order> get pastOrders => state.where((o) => !o.isActive).toList();
}

final orderHistoryProvider =
    NotifierProvider<OrderHistoryNotifier, List<Order>>(OrderHistoryNotifier.new);
