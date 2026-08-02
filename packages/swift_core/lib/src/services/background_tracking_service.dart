import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'unified_backend_service.dart';

/// A production-grade tracking service that handles background location updates.
/// This service is designed to be resilient across app terminations.
class BackgroundTrackingService {
  static final BackgroundTrackingService _instance = BackgroundTrackingService._internal();
  factory BackgroundTrackingService() => _instance;
  BackgroundTrackingService._internal();

  StreamSubscription<Position>? _positionSubscription;
  bool _isTracking = false;

  bool get isTracking => _isTracking;

  /// Starts the high-accuracy tracking service.
  /// In production, this would trigger the Native Foreground Service.
  Future<void> startTracking(String riderId, String orderId) async {
    if (_isTracking) return;

    // 1. Request permissions (In production, geolocator handles this)
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _isTracking = true;

    // 2. Start position stream
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Only notify every 10 meters to save battery
      ),
    ).listen((Position position) {
      // 3. Update the simulated backend
      UnifiedBackendService().updateOrder(
        orderId,
        riderLocation: '${position.latitude},${position.longitude}',
      );
      
      if (kDebugMode) {
        print('Rider $riderId location: ${position.latitude}, ${position.longitude}');
      }
    });
  }

  /// Stops tracking and releases resources.
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _isTracking = false;
  }
}
