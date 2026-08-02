import 'package:swift_core/swift_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Applies iOS-style bouncing overscroll everywhere.
///
/// Applied globally via [MaterialApp.scrollBehavior] so we don't have to set
/// [BouncingScrollPhysics] on every [ListView]/[CustomScrollView].
class SwiftScrollBehavior extends MaterialScrollBehavior {
  const SwiftScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };
}
