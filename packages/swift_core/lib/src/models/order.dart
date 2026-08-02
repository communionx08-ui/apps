import 'package:swift_core/swift_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'service_type.dart';
import 'vendor.dart';

/// Represents the various states of an order in the Swift ecosystem.
enum OrderStatus {
  created,
  accepted,   // For marketplace orders (Accepted by Vendor)
  preparing,  // For marketplace orders
  assigned,   // Rider assigned (Marketplace or Errand)
  pickedUp,   // Rider has item/is at errand start
  inTransit,  // Rider moving to dropoff
  arriving,   // Rider near dropoff
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.created: return 'Order Placed';
      case OrderStatus.accepted: return 'Confirmed by Store';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.assigned: return 'Rider Assigned';
      case OrderStatus.pickedUp: return 'Picked Up';
      case OrderStatus.inTransit: return 'On the Way';
      case OrderStatus.arriving: return 'Arriving Soon';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  bool get isTerminal => this == OrderStatus.delivered || this == OrderStatus.cancelled;
  bool get isActive => !isTerminal;
}

enum SubstitutionPreference {
  callMe,
  replaceWithBestMatch,
  doNotSubstitute,
  refund;

  String get label {
    switch (this) {
      case SubstitutionPreference.callMe: return 'Call me';
      case SubstitutionPreference.replaceWithBestMatch: return 'Replace with best match';
      case SubstitutionPreference.doNotSubstitute: return 'Do not substitute';
      case SubstitutionPreference.refund: return 'Refund item';
    }
  }
}

/// A single purchased line in an [Order].
class OrderLineItem {
  final String title;
  final String description;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;
  final String? size;
  final String? color;

  const OrderLineItem({
    required this.title,
    this.description = '',
    required this.unitPrice,
    this.quantity = 1,
    this.imageUrl,
    this.size,
    this.color,
  });

  double get lineTotal => unitPrice * quantity;
}

/// Unified Order model for Marketplace (3-way) and Errand/Parcel (2-way) services.
class Order {
  final String id;
  final String customerId;
  final ServiceType serviceType;
  final OrderStatus status;
  final DateTime createdAt;
  
  // Marketplace fields (null for Errands)
  final Vendor? vendor;
  final String? vendorName;
  final List<OrderLineItem> items;
  
  // Errand/Parcel fields
  final String? errandDescription;
  final ParcelDetails? parcelDetails;
  
  // Pharmacy fields
  final String? prescriptionImageUrl;
  final bool isPrescriptionVerified;

  // Laundry fields
  final double? estimatedWeight;
  final double? actualWeight;

  // Grocery/Market fields
  final SubstitutionPreference? substitutionPreference;

  // Shared Logistics
  final String pickupAddress;
  final String dropoffAddress;
  final String? senderName;
  final String? senderPhone;
  final String? recipientName;
  final String? recipientPhone;
  
  final String? riderId;
  final String? riderName;
  final String? riderPhone;
  final String? riderLocation;
  final String? proofOfDeliveryUrl;

  // Pricing
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double discount;
  final double total;
  final String paymentMethod;

  Order({
    required this.id,
    this.customerId = 'USER_123',
    required this.serviceType,
    this.status = OrderStatus.created,
    DateTime? createdAt,
    this.vendor,
    this.vendorName,
    this.items = const [],
    this.errandDescription,
    this.parcelDetails,
    this.prescriptionImageUrl,
    this.isPrescriptionVerified = false,
    this.estimatedWeight,
    this.actualWeight,
    this.substitutionPreference,
    this.pickupAddress = 'Pickup Address',
    this.dropoffAddress = 'Dropoff Address',
    this.senderName,
    this.senderPhone,
    this.recipientName,
    this.recipientPhone,
    this.riderId,
    this.riderName,
    this.riderPhone,
    this.riderLocation,
    this.proofOfDeliveryUrl,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.serviceFee = 0,
    this.discount = 0,
    this.total = 0,
    this.paymentMethod = 'Cash',
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isMarketplaceOrder => 
      serviceType != ServiceType.errand && serviceType != ServiceType.parcel;

  Order copyWith({
    OrderStatus? status,
    String? riderId,
    String? riderName,
    String? riderPhone,
    String? riderLocation,
    bool? isPrescriptionVerified,
    double? actualWeight,
    double? total,
    String? proofOfDeliveryUrl,
  }) {
    return Order(
      id: id,
      customerId: customerId,
      serviceType: serviceType,
      status: status ?? this.status,
      createdAt: createdAt,
      vendor: vendor,
      vendorName: vendorName,
      items: items,
      errandDescription: errandDescription,
      parcelDetails: parcelDetails,
      prescriptionImageUrl: prescriptionImageUrl,
      isPrescriptionVerified: isPrescriptionVerified ?? this.isPrescriptionVerified,
      estimatedWeight: estimatedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
      substitutionPreference: substitutionPreference,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      senderName: senderName,
      senderPhone: senderPhone,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      riderId: riderId ?? this.riderId,
      riderName: riderName ?? this.riderName,
      riderPhone: riderPhone ?? this.riderPhone,
      riderLocation: riderLocation ?? this.riderLocation,
      proofOfDeliveryUrl: proofOfDeliveryUrl ?? this.proofOfDeliveryUrl,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      serviceFee: serviceFee,
      discount: discount,
      total: total ?? this.total,
      paymentMethod: paymentMethod,
    );
  }

  String get itemsSummary {
    if (items.isEmpty) return errandDescription ?? 'Order Details';
    final totalItems = items.fold(0, (sum, i) => sum + i.quantity);
    if (items.length == 1) {
      return '${items.first.quantity}x ${items.first.title}';
    }
    return '$totalItems items • ₵${total.toStringAsFixed(2)}';
  }
}

class ParcelDetails {
  final String size; // Small, Medium, Large
  final String category; // Documents, Electronics, Food, etc.
  final String? weight;
  final bool isFragile;

  ParcelDetails({
    required this.size,
    required this.category,
    this.weight,
    this.isFragile = false,
  });
}

class OrderIdGenerator {
  static int _counter = 0;

  static String next(ServiceType serviceType) {
    _counter += 1;
    final ms = DateTime.now().millisecondsSinceEpoch;
    final suffix = '${ms % 1000000}${_counter.toString().padLeft(2, '0')}';
    return '#${serviceType.orderPrefix}-$suffix';
  }
}
