import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/active_order_provider.dart';
import '../providers/notifications_provider.dart';
import '../providers/order_history_provider.dart';
import '../providers/rider_location_provider.dart';

// ── Step definition ───────────────────────────────────────────────────────

class _SimStep {
  final int delaySeconds;
  final OrderStatus status;
  final String statusMessage;
  final String notifTitle;
  final String notifBody;
  final NotificationType notifType;
  final bool startRiderMovement;

  const _SimStep({
    required this.delaySeconds,
    required this.status,
    required this.statusMessage,
    required this.notifTitle,
    required this.notifBody,
    this.notifType = NotificationType.orderUpdate,
    this.startRiderMovement = false,
  });
}

// ── Steps per service type ────────────────────────────────────────────────

List<_SimStep> _stepsFor(ServiceType t, String? vendorName) {
  final name = vendorName ?? 'Swift Agent';
  switch (t) {
    case ServiceType.errand:
    case ServiceType.parcel:
      return [
        _SimStep(
          delaySeconds: 3,
          status: OrderStatus.assigned,
          statusMessage: 'Rider assigned — heading to pickup',
          notifTitle: 'Rider Assigned',
          notifBody: 'Kwame A. is on the way to pick up your parcel.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 10,
          status: OrderStatus.pickedUp,
          statusMessage: 'Parcel picked up — in transit',
          notifTitle: 'Picked Up',
          notifBody: 'Your rider has picked up the item and is moving.',
        ),
        _SimStep(
          delaySeconds: 15,
          status: OrderStatus.inTransit,
          statusMessage: 'Almost there — arriving soon',
          notifTitle: 'On the Way',
          notifBody: 'Your delivery is arriving in about 5 minutes.',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 10,
          status: OrderStatus.delivered,
          statusMessage: 'Delivery completed! ✅',
          notifTitle: 'Delivered!',
          notifBody: 'Your parcel has been successfully delivered.',
        ),
      ];
    
    default:
      // Marketplace flow (Food, Grocery, etc.)
      return [
        _SimStep(
          delaySeconds: 4,
          status: OrderStatus.accepted,
          statusMessage: '$name is preparing your order',
          notifTitle: 'Order Accepted',
          notifBody: '$name has started preparing your order.',
        ),
        _SimStep(
          delaySeconds: 10,
          status: OrderStatus.assigned,
          statusMessage: 'Rider assigned — heading to $name',
          notifTitle: 'Rider Assigned',
          notifBody: 'A rider is heading to $name to collect your order.',
          notifType: NotificationType.riderUpdate,
          startRiderMovement: true,
        ),
        _SimStep(
          delaySeconds: 12,
          status: OrderStatus.pickedUp,
          statusMessage: 'Rider has picked up your order',
          notifTitle: 'Picked Up',
          notifBody: 'Your order is now with the rider.',
          notifType: NotificationType.riderUpdate,
        ),
        _SimStep(
          delaySeconds: 15,
          status: OrderStatus.delivered,
          statusMessage: 'Enjoy your delivery! 🎉',
          notifTitle: 'Order Delivered!',
          notifBody: 'Your order from $name has arrived.',
        ),
      ];
  }
}

// ── Service ───────────────────────────────────────────────────────────────

class OrderSimulationService {
  static void start({
    required WidgetRef ref,
    required BuildContext context,
    required Order order,
  }) {
    final steps = _stepsFor(order.serviceType, order.vendorName);
    _scheduleSteps(ref, context, order.id, order.serviceType, steps, 0);
  }

  static void _scheduleSteps(
    WidgetRef ref,
    BuildContext context,
    String orderId,
    ServiceType serviceType,
    List<_SimStep> steps,
    int index,
  ) {
    if (index >= steps.length) return;
    final step = steps[index];

    Timer(Duration(seconds: step.delaySeconds), () {
      if (!context.mounted) return;

      ref.read(orderHistoryProvider.notifier).updateStatus(orderId, step.status);
      ref.read(activeOrderProvider.notifier).updateStatus(step.statusMessage);

      if (step.startRiderMovement) {
        ref.read(riderLocationProvider.notifier).startJourney();
      }

      final notif = AppNotification(
        id: '${orderId}_step_$index',
        title: step.notifTitle,
        body: step.notifBody,
        createdAt: DateTime.now(),
        orderId: orderId,
        type: step.notifType,
        serviceType: serviceType,
      );
      ref.read(notificationsProvider.notifier).add(notif);

      NotificationOverlay.show(
        context,
        title: step.notifTitle,
        body: step.notifBody,
        type: step.notifType,
      );

      if (step.status == OrderStatus.delivered) {
        ref.read(activeOrderProvider.notifier).clearOrder();
      }

      _scheduleSteps(ref, context, orderId, serviceType, steps, index + 1);
    });
  }
}
