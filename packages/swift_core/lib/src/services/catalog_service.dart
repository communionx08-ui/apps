import 'package:swift_core/swift_core.dart';

class CatalogItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final ServiceType vertical;
  final String vendorName;
  final String category;
  final List<String>? tags;

  CatalogItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.vertical,
    required this.vendorName,
    required this.category,
    this.tags,
  });
}

class CatalogService {
  static final CatalogService _instance = CatalogService._internal();
  factory CatalogService() => _instance;
  CatalogService._internal();

  final List<CatalogItem> _allItemData = [
    // --- FOOD (Expansion) ---
    CatalogItem(
      id: 'f1',
      title: 'Smoky Jollof Rice Special',
      description: 'Ghanas best smoky jollof rice served with grilled chicken, salad and shito.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Papaye Fast Food',
      category: 'Main Course',
      tags: ['Smoky', 'Spicy', 'Popular'],
    ),
    CatalogItem(
      id: 'f2',
      title: 'Banku and Grilled Tilapia',
      description: 'Fresh tilapia grilled to perfection, served with banku and hot pepper sauce.',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Nana Konadu Joint',
      category: 'Local Dishes',
      tags: ['Authentic', 'Healthy'],
    ),
    CatalogItem(
      id: 'f6',
      title: 'Fufu with Goat Meat Light Soup',
      description: 'Hand-pounded fufu served with rich light soup and tender goat meat.',
      price: 55.00,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Mama\'s Kitchen',
      category: 'Local Dishes',
    ),
    CatalogItem(
      id: 'f7',
      title: 'Assorted Pizza (Large)',
      description: 'Beef, pepperoni, peppers, onions, and extra cheese.',
      price: 120.00,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Pizza Hut',
      category: 'Pizza',
    ),
    CatalogItem(
      id: 'f8',
      title: 'Double Zinger Burger',
      description: 'Two spicy chicken fillets with lettuce and mayo.',
      price: 75.00,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'KFC',
      category: 'Burgers',
    ),
    CatalogItem(
      id: 'f9',
      title: 'Sushi Platter (12pcs)',
      description: 'Assorted maki, nigiri, and sashimi with soy sauce and ginger.',
      price: 180.00,
      imageUrl: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Zen Garden',
      category: 'Asian',
    ),
    CatalogItem(
      id: 'f10',
      title: 'Beef Shawarma Wrap',
      description: 'Grilled beef wrap with veggies and garlic sauce.',
      price: 35.00,
      imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?q=80&w=800',
      vertical: ServiceType.food,
      vendorName: 'Le Levant',
      category: 'Middle Eastern',
    ),

    // --- GROCERIES (Expansion) ---
    CatalogItem(
      id: 'g1',
      title: 'Fresh Tomatoes (Box)',
      description: 'Organic farm-fresh red tomatoes, approximately 5kg.',
      price: 35.00,
      imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f02ac6d31?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'MaxMart Supermarket',
      category: 'Vegetables',
    ),
    CatalogItem(
      id: 'g6',
      title: 'Avocado (3 pack)',
      description: 'Large, creamy Hass avocados.',
      price: 24.00,
      imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'MaxMart Supermarket',
      category: 'Fruits',
    ),
    CatalogItem(
      id: 'g7',
      title: 'Heineken (6 Pack)',
      description: '330ml premium lager beer.',
      price: 90.00,
      imageUrl: 'https://images.unsplash.com/photo-1600718374662-0483d2b9da44?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'Melcom',
      category: 'Alcohol',
    ),
    CatalogItem(
      id: 'g8',
      title: 'Oreo Biscuits (Roll)',
      description: 'Chocolate sandwich cookies with vanilla cream.',
      price: 12.00,
      imageUrl: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'Shoprite',
      category: 'Snacks',
    ),
    CatalogItem(
      id: 'g9',
      title: 'Whole Wheat Bread',
      description: 'Freshly baked artisan whole wheat loaf.',
      price: 18.00,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'Abaawa Groceries',
      category: 'Bakery',
    ),
    CatalogItem(
      id: 'g10',
      title: 'Salmon Fillet (500g)',
      description: 'Fresh Atlantic salmon, skin-on.',
      price: 145.00,
      imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=800',
      vertical: ServiceType.groceries,
      vendorName: 'Shoprite',
      category: 'Meat & Seafood',
    ),

    // --- PHARMACY (Expansion) ---
    CatalogItem(
      id: 'p5',
      title: 'Digital Thermometer',
      description: 'High accuracy instant-read thermometer.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?q=80&w=800',
      vertical: ServiceType.pharmacy,
      vendorName: 'Ernest Chemists',
      category: 'Medical Devices',
    ),
    CatalogItem(
      id: 'p6',
      title: 'Face Masks (50 Pack)',
      description: '3-ply disposable surgical masks.',
      price: 35.00,
      imageUrl: 'https://images.unsplash.com/photo-1586942593568-29361efcd571?q=80&w=800',
      vertical: ServiceType.pharmacy,
      vendorName: 'Ernest Chemists',
      category: 'First Aid',
    ),
    CatalogItem(
      id: 'p7',
      title: 'Whey Protein Powder (2kg)',
      description: 'Vanilla flavored high-protein supplement.',
      price: 650.00,
      imageUrl: 'https://images.unsplash.com/photo-1593095191071-837a59933170?q=80&w=800',
      vertical: ServiceType.pharmacy,
      vendorName: 'GNC Health',
      category: 'Sports Nutrition',
    ),
    CatalogItem(
      id: 'p8',
      title: 'Moisturizing Cream 500g',
      description: 'Deep hydration for sensitive skin.',
      price: 120.00,
      imageUrl: 'https://images.unsplash.com/photo-1556229162-5c63ed9c4ffb?q=80&w=800',
      vertical: ServiceType.pharmacy,
      vendorName: 'Juniper Pharmacy',
      category: 'Skincare',
    ),

    // --- SHOP (Expansion) ---
    CatalogItem(
      id: 's5',
      title: 'Nike Air Max 270',
      description: 'Comfortable and stylish sneakers in black/white.',
      price: 1400.00,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800',
      vertical: ServiceType.shop,
      vendorName: 'The Shoe Box',
      category: 'Footwear',
    ),
    CatalogItem(
      id: 's6',
      title: 'MacBook Air M2 (13-inch)',
      description: 'Powerful laptop for students and professionals.',
      price: 12500.00,
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=800',
      vertical: ServiceType.shop,
      vendorName: 'iPlace Ghana',
      category: 'Electronics',
    ),
    CatalogItem(
      id: 's7',
      title: 'Leather Bi-fold Wallet',
      description: 'Genuine brown leather wallet with RFID protection.',
      price: 150.00,
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?q=80&w=800',
      vertical: ServiceType.shop,
      vendorName: 'Kantanka Fashion',
      category: 'Accessories',
    ),
    CatalogItem(
      id: 's8',
      title: 'Sunglasses - Aviator',
      description: 'Classic gold-frame aviators with polarized lenses.',
      price: 320.00,
      imageUrl: 'https://images.unsplash.com/photo-1511499767390-91f99f73948c?q=80&w=800',
      vertical: ServiceType.shop,
      vendorName: 'Sunglasses Hut',
      category: 'Accessories',
    ),

    // --- LAUNDRY (Expansion) ---
    CatalogItem(
      id: 'l3',
      title: 'Sneaker Deep Clean',
      description: 'Full interior and exterior cleaning for sneakers.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?q=80&w=800',
      vertical: ServiceType.laundry,
      vendorName: 'CleanPro Laundry',
      category: 'Specialty',
    ),
    CatalogItem(
      id: 'l4',
      title: 'Duvet / Comforter Cleaning',
      description: 'Special deep wash for heavy king-size duvets.',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=800',
      vertical: ServiceType.laundry,
      vendorName: 'CleanPro Laundry',
      category: 'Home Items',
    ),
    CatalogItem(
      id: 'l5',
      title: 'Ironing Service Only',
      description: 'Expert steam ironing for shirts and trousers.',
      price: 5.00, // per item
      imageUrl: 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?q=80&w=800',
      vertical: ServiceType.laundry,
      vendorName: 'Elite Dry Cleaners',
      category: 'Pressing',
    ),
  ];

  List<CatalogItem> getAll() => _allItemData;

  List<CatalogItem> search(String query) {
    if (query.isEmpty) return [];
    return _allItemData.where((item) {
      final text = '${item.title} ${item.vendorName} ${item.category}'.toLowerCase();
      return text.contains(query.toLowerCase());
    }).toList();
  }

  List<CatalogItem> getByVertical(ServiceType type) {
    return _allItemData.where((item) => item.vertical == type).toList();
  }

  List<CatalogItem> getByVendor(String vendorName) {
    return _allItemData.where((item) => item.vendorName == vendorName).toList();
  }
  
  List<String> getVendorsForVertical(ServiceType type) {
    return _allItemData
        .where((item) => item.vertical == type)
        .map((item) => item.vendorName)
        .toSet()
        .toList();
  }
}
