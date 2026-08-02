import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'providers/vendor_inventory_provider.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(vendorInventoryProvider);
    final categories = products.map((p) => p.category).toSet().toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Menu Management', style: AppTypography.h2()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, catIndex) {
          final category = categories[catIndex];
          final catProducts = products.where((p) => p.category == category).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(category, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold, color: AppColors.textMuted)),
              ),
              ...catProducts.map((product) => _ProductTile(product: product)),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _ProductTile extends ConsumerWidget {
  final VendorProduct product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.borderLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.restaurant_rounded, color: AppColors.textMuted),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.w600)),
                Text('₵${product.price.toStringAsFixed(2)}', style: AppTypography.bodySm()),
              ],
            ),
          ),
          Switch.adaptive(
            value: product.isAvailable,
            activeColor: AppColors.primary,
            onChanged: (_) => ref.read(vendorInventoryProvider.notifier).toggleAvailability(product.id),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}
