/// Simple vendor model for the Swift customer app
class SwiftVendor {
  final String id;
  final String name;
  final String? coverUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final String deliveryFeeLabel;
  final String etaLabel;
  final bool isOpen;
  final bool isFeatured;
  final String? promo;

  const SwiftVendor({
    required this.id,
    required this.name,
    this.coverUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.deliveryFeeLabel,
    required this.etaLabel,
    this.isOpen = true,
    this.isFeatured = false,
    this.promo,
  });
}
