import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AnimatedRiderMarker extends StatelessWidget {
  final LatLng position;
  final Widget child;
  final Duration duration;

  const AnimatedRiderMarker({
    super.key,
    required this.position,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<LatLng>(
      tween: LatLngTween(begin: position, end: position),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        // We use a custom widget or let the parent handle the Marker creation
        // but since flutter_map's Marker needs a point, this builder 
        // will usually be wrapped around the MarkerLayer's marker list logic.
        return child;
      },
    );
  }
}

/// Helper for LatLng interpolation in animations.
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required super.begin, required super.end});

  @override
  LatLng lerp(double t) {
    return LatLng(
      begin!.latitude + (end!.latitude - begin!.latitude) * t,
      begin!.longitude + (end!.longitude - begin!.longitude) * t,
    );
  }
}
