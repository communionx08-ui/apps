import 'package:swift_core/swift_core.dart';
/// Design tokens - spacing, radii, shadows, etc.
class AppTokens {
  AppTokens._();

  // Spacing scale
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;

  // Border radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radius2Xl = 32.0;
  static const double radiusRound = 999.0;

  // Elevation / Shadows
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 8.0;
  static const double elevationHigh = 16.0;

  // Animation / Motion durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 350);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Content Max Width (for readability)
  static const double contentMaxWidth = 600.0;
}
