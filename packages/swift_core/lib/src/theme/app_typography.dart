import 'package:flutter/material.dart';

/// Typography tokens for the Swift Inter-based type system.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static TextStyle display([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: c,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle h1([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: c,
        height: 1.25,
      );

  static TextStyle h2([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: c,
        height: 1.3,
      );

  static TextStyle h3([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: c,
        height: 1.35,
      );

  static TextStyle bodyLg([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: c,
        height: 1.4,
      );

  static TextStyle body([Color c = const Color(0xFF0F172A)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: c,
        height: 1.45,
      );

  static TextStyle bodySm([Color c = const Color(0xFF64748B)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: c,
        height: 1.4,
      );

  static TextStyle caption([Color c = const Color(0xFF94A3B8)]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: c,
        letterSpacing: 0.5,
        height: 1.3,
      );

  static TextStyle button([Color c = Colors.white]) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: c,
        letterSpacing: 0.2,
      );
}
