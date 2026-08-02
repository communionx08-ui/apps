import 'package:swift_core/swift_core.dart';
import 'package:flutter/services.dart';

/// Service to handle production-grade haptic feedback across the Swift ecosystem.
class HapticService {
  /// Light impact for minor actions (e.g., ticking a checkbox, adding to cart).
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact for standard actions (e.g., button press, tab change).
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact for significant actions (e.g., confirming order, successful payment).
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Success pattern for completed tasks.
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
  }

  /// Error pattern for failed actions.
  static Future<void> error() async {
    await HapticFeedback.vibrate();
  }

  /// Selection click for scrolling/picking.
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }
}

/// Compatibility alias
class Haptics extends HapticService {}
