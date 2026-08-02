import 'package:swift_core/swift_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiderTaskNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    final backend = ref.watch(unifiedBackendProvider);
    backend.ordersStream.listen((orders) {
       state = orders;
    });
    return backend.currentOrders;
  }

  void acceptTask(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(
      orderId, 
      status: OrderStatus.assigned,
      riderId: 'RIDER_123',
      riderName: 'Kwame A.',
    );
    HapticService.success();
  }

  void completePickup(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.pickedUp);
    HapticService.medium();
  }

  void startInTransit(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.inTransit);
    HapticService.selection();
  }

  void markAsDelivered(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.delivered);
    HapticService.heavy();
  }
}

final riderTaskProvider = NotifierProvider<RiderTaskNotifier, List<Order>>(RiderTaskNotifier.new);

final riderStatusProvider = StateProvider<bool>((ref) => false);
