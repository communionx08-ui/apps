import 'package:swift_core/swift_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorOrderNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    final backend = ref.watch(unifiedBackendProvider);
    backend.ordersStream.listen((orders) {
       state = orders.where((o) => o.isMarketplaceOrder).toList();
    });
    return backend.currentOrders.where((o) => o.isMarketplaceOrder).toList();
  }

  void acceptOrder(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.accepted);
    HapticService.success();
  }

  void markAsPreparing(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.preparing);
    HapticService.medium();
  }

  void markAsReady(String orderId) {
     // For vendor, "Ready" means waiting for rider pickup
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.pickedUp);
    HapticService.heavy();
  }

  void verifyPrescription(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, isPrescriptionVerified: true);
    HapticService.success();
  }

  void updateLaundryWeight(String orderId, double weight) {
    // Recalculate total if weight changed significantly
    final order = state.firstWhere((o) => o.id == orderId);
    final newTotal = order.subtotal + (weight * 5.0) + order.deliveryFee; // Mock calculation
    ref.read(unifiedBackendProvider).updateOrder(
      orderId, 
      actualWeight: weight,
      total: newTotal,
    );
    HapticService.medium();
  }

  void cancelOrder(String orderId) {
    ref.read(unifiedBackendProvider).updateOrder(orderId, status: OrderStatus.cancelled);
    HapticService.error();
  }
}

final vendorOrderProvider = NotifierProvider<VendorOrderNotifier, List<Order>>(VendorOrderNotifier.new);
