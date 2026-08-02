import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A production-grade singleton simulation that acts as the "Backend" for all three apps.
/// In a real app, this would be a combination of REST APIs, WebSockets, and Cloud Functions.
class UnifiedBackendService {
  static final UnifiedBackendService _instance = UnifiedBackendService._internal();
  factory UnifiedBackendService() => _instance;
  UnifiedBackendService._internal();

  final _ordersController = StreamController<List<Order>>.broadcast();
  List<Order> _orders = [];

  Stream<List<Order>> get ordersStream => _ordersController.stream;
  List<Order> get currentOrders => _orders;

  /// Place a new order into the system.
  void placeOrder(Order order) {
    _orders = [..._orders, order];
    _notify();
  }

  /// Update an existing order status or logistics data.
  void updateOrder(String orderId, {
    OrderStatus? status,
    String? riderId,
    String? riderName,
    String? riderLocation,
  }) {
    _orders = [
      for (final order in _orders)
        if (order.id == orderId)
          order.copyWith(
            status: status,
            riderId: riderId,
            riderName: riderName,
            riderLocation: riderLocation,
          )
        else
          order,
    ];
    _notify();
  }

  void _notify() {
    _ordersController.add(_orders);
  }

  /// Helper to get a single order stream (simulating a WebSocket subscription).
  Stream<Order?> watchOrder(String orderId) {
    return ordersStream.map((list) => list.firstWhere((o) => o.id == orderId));
  }
}

final unifiedBackendProvider = Provider((ref) => UnifiedBackendService());
