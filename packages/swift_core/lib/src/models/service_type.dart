import 'package:flutter/material.dart';

/// The eight core Swift service verticals.
enum ServiceType {
  food,
  groceries,
  market,
  shop,
  pharmacy,
  laundry,
  parcel,
  errand;

  String get label {
    switch (this) {
      case ServiceType.food:
        return 'Food';
      case ServiceType.groceries:
        return 'Groceries';
      case ServiceType.market:
        return 'Market';
      case ServiceType.shop:
        return 'Shop';
      case ServiceType.pharmacy:
        return 'Pharmacy';
      case ServiceType.laundry:
        return 'Laundry';
      case ServiceType.parcel:
        return 'Parcel';
      case ServiceType.errand:
        return 'Errand';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceType.food:
        return Icons.restaurant_rounded;
      case ServiceType.groceries:
        return Icons.local_grocery_store_rounded;
      case ServiceType.market:
        return Icons.storefront_rounded;
      case ServiceType.shop:
        return Icons.shopping_bag_rounded;
      case ServiceType.pharmacy:
        return Icons.local_pharmacy_rounded;
      case ServiceType.laundry:
        return Icons.local_laundry_service_rounded;
      case ServiceType.parcel:
        return Icons.inventory_2_rounded;
      case ServiceType.errand:
        return Icons.directions_run_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ServiceType.food:
        return const Color(0xFFF97316); // warm orange
      case ServiceType.groceries:
        return const Color(0xFF16A34A); // green
      case ServiceType.market:
        return const Color(0xFFD97706); // amber
      case ServiceType.shop:
        return const Color(0xFF8B5CF6); // violet
      case ServiceType.pharmacy:
        return const Color(0xFF06B6D4); // cyan
      case ServiceType.laundry:
        return const Color(0xFF0EA5E9); // sky blue
      case ServiceType.parcel:
        return const Color(0xFF10B981); // emerald
      case ServiceType.errand:
        return const Color(0xFFEF4444); // red
    }
  }

  String get heroHeadline {
    switch (this) {
      case ServiceType.food:
        return 'Hungry?';
      case ServiceType.groceries:
        return 'Out of something?';
      case ServiceType.market:
        return 'Need to shop?';
      case ServiceType.shop:
        return 'Need to dress up?';
      case ServiceType.pharmacy:
        return 'Not feeling well?';
      case ServiceType.laundry:
        return 'Laundry piling up?';
      case ServiceType.parcel:
        return 'Send a parcel';
      case ServiceType.errand:
        return 'Too busy to run it?';
    }
  }

  String get heroSubheadline {
    switch (this) {
      case ServiceType.food:
        return "Let's find you something";
      case ServiceType.groceries:
        return "Let's restock your kitchen";
      case ServiceType.market:
        return "Let's find your market";
      case ServiceType.shop:
        return "Let's find an outfit";
      case ServiceType.pharmacy:
        return "Let's get your meds";
      case ServiceType.laundry:
        return "Let's pick up & clean";
      case ServiceType.parcel:
        return 'Fast pickup & delivery';
      case ServiceType.errand:
        return 'An agent will run it for you';
    }
  }

  String get searchPlaceholder {
    switch (this) {
      case ServiceType.food:
        return 'Search for food, restaurants…';
      case ServiceType.groceries:
        return 'Search for groceries…';
      case ServiceType.market:
        return 'Search the market…';
      case ServiceType.shop:
        return 'Search for clothes, shoes…';
      case ServiceType.pharmacy:
        return 'Search for medication…';
      case ServiceType.laundry:
        return 'Search laundry services…';
      case ServiceType.parcel:
        return 'Where to?';
      case ServiceType.errand:
        return 'What do you need done?';
    }
  }
}
