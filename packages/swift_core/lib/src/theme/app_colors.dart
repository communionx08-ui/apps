import 'package:flutter/material.dart';

/// Swift brand palette.
///
/// Primary: deep trustworthy blue (reliability, payments, logistics, brand).
/// Accent:  warm sunny yellow (energy, promos, CTAs, badges).
class AppColors {
  AppColors._();

  // ── Brand ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0068FF);     // Swift blue (matching homescreen)
  static const Color primaryDark = Color(0xFF0052CC); // darker blue (pressed)
  static const Color primaryLight = Color(0xFF3B82F6);// bright blue (highlights/chips)
  static const Color accent = Color(0xFFFACC15);      // warm yellow (badges/promos)
  static const Color accentDark = Color(0xFFEAB308);  // deeper yellow

  // ── Service accents ──────────────────────────────────────────────
  static const Color food = Color(0xFFF97316);        // warm orange (food stays energetic)
  static const Color groceries = Color(0xFF16A34A);   // green (fresh produce)
  static const Color market = Color(0xFFD97706);      // amber (market stalls)
  static const Color shop = Color(0xFF8B5CF6);        // violet (retail variety)
  static const Color pharmacy = Color(0xFF06B6D4);    // cyan (medical/clean)
  static const Color laundry = Color(0xFF0EA5E9);     // sky blue (water/clean)
  static const Color parcel = Color(0xFF10B981);      // emerald (delivery/on-the-way)
  static const Color errand = Color(0xFFEF4444);      // red (urgent)

  // ── Semantic ─────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── Neutrals ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color scrim = Color(0x66000000);
}
