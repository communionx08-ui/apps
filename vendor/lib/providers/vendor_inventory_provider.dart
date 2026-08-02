import 'package:swift_core/swift_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VendorProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final bool isAvailable;
  final String? imageUrl;

  VendorProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.isAvailable = true,
    this.imageUrl,
  });

  VendorProduct copyWith({bool? isAvailable}) {
    return VendorProduct(
      id: id,
      name: name,
      category: category,
      price: price,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl,
    );
  }
}

class VendorInventoryNotifier extends StateNotifier<List<VendorProduct>> {
  VendorInventoryNotifier() : super([]) {
    _loadMocks();
  }

  void _loadMocks() {
    state = [
      VendorProduct(id: 'P1', name: 'Jollof Rice with Chicken', category: 'Main Dishes', price: 45.0),
      VendorProduct(id: 'P2', name: 'Banku & Tilapia', category: 'Main Dishes', price: 55.0),
      VendorProduct(id: 'P3', name: 'Fried Rice & Wings', category: 'Main Dishes', price: 50.0),
      VendorProduct(id: 'P4', name: 'Kelewele', category: 'Sides', price: 15.0),
      VendorProduct(id: 'P5', name: 'Plantain', category: 'Sides', price: 10.0),
      VendorProduct(id: 'P6', name: 'Coca Cola', category: 'Drinks', price: 12.0),
      VendorProduct(id: 'P7', name: 'Fanta', category: 'Drinks', price: 12.0),
    ];
  }

  void toggleAvailability(String productId) {
    final product = state.firstWhere((p) => p.id == productId);
    final newState = !product.isAvailable;
    
    state = [
      for (final p in state)
        if (p.id == productId) p.copyWith(isAvailable: newState) else p,
    ];

    // Synchronize with Customer App real-time registry
    LiveRegistryService().setItemStock('Mama\'s Kitchen', product.name, newState);
    
    HapticService.selection();
  }
}

final vendorInventoryProvider = StateNotifierProvider<VendorInventoryNotifier, List<VendorProduct>>((ref) {
  return VendorInventoryNotifier();
});
