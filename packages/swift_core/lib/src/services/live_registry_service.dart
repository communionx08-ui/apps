import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the live operational state of a vendor.
enum StoreStatus {
  open,
  busy,   // Adds to ETA, shows "High Demand"
  closed, // Cannot place orders
}

/// Model for vendor operating hours.
class BusinessDay {
  final String day;
  final String openTime;  // e.g. "08:00"
  final String closeTime; // e.g. "22:00"
  final bool isClosed;

  BusinessDay({required this.day, required this.openTime, required this.closeTime, this.isClosed = false});
}

/// A centralized, real-time registry for vendor status and inventory availability.
/// In production, this would be backed by Firebase Realtime Database or WebSockets.
class LiveRegistryService {
  static final LiveRegistryService _instance = LiveRegistryService._internal();
  factory LiveRegistryService() => _instance;
  LiveRegistryService._internal();

  final _updateController = StreamController<void>.broadcast();
  Stream<void> get updates => _updateController.stream;

  // Real-time state maps
  final Map<String, StoreStatus> _vendorStatuses = {};
  final Map<String, List<BusinessDay>> _vendorHours = {};
  final Map<String, bool> _itemAvailability = {}; // key: "vendorName:itemName"

  /// Update a vendor's live operational status.
  void setVendorStatus(String vendorName, StoreStatus status) {
    _vendorStatuses[vendorName] = status;
    _updateController.add(null);
  }

  StoreStatus getVendorStatus(String vendorName) {
    return _vendorStatuses[vendorName] ?? StoreStatus.open;
  }

  /// Update an item's availability in real-time.
  void setItemStock(String vendorName, String itemName, bool inStock) {
    _itemAvailability['$vendorName:$itemName'] = inStock;
    _updateController.add(null);
  }

  bool isItemInStock(String vendorName, String itemName) {
    return _itemAvailability['$vendorName:$itemName'] ?? true;
  }

  /// Set and get operating hours.
  void setVendorHours(String vendorName, List<BusinessDay> hours) {
    _vendorHours[vendorName] = hours;
    _updateController.add(null);
  }

  bool isStoreWithinHours(String vendorName) {
    // Basic logic: Check current time against schedule
    final now = DateTime.now();
    // Simplified for demo: assume open if not explicitly set
    return true; 
  }
}

final liveRegistryProvider = Provider((ref) => LiveRegistryService());
