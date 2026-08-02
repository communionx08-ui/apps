import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'restaurant_screen.dart';
import 'laundry_vendors_screen.dart';
import 'errand_selection_screen.dart';
import 'profile_screen.dart';
import 'orders_screen.dart';
import 'location_search_screen.dart';
import 'search_screen.dart';
import 'search_view.dart';
import 'notifications_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/food_cart_provider.dart';
import 'vendor_list_screen.dart';
import 'market_screen.dart';
import 'parcel_selection_screen.dart';
import 'food_detail_screen.dart';
import 'checkout_screen.dart';
import 'order_tracking_screen.dart';
import '../providers/active_order_provider.dart';
import 'market_shopping_list_screen.dart';
import '../providers/notifications_provider.dart';
import '../providers/vendor_stories_provider.dart';
import 'vendor_story_screen.dart';

class HomeScreenV2 extends ConsumerStatefulWidget {
  const HomeScreenV2({super.key});

  @override
  ConsumerState<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends ConsumerState<HomeScreenV2> {
  bool _isLoading = false;
  int _selectedTab = 0;
  int _selectedNav = 0;
  int _promoIndex = 0;
  final PageController _promoController = PageController();
  String _locationName = 'Obuasi, Kumasi';
  final Set<String> _favouriteRestaurants = {};
  ServiceType _selectedServiceType = ServiceType.food;

  final List<String> _groceryFilterTabs = ['All', 'Supermarket', 'Dairy & Eggs', 'Frozen Foods'];
  final List<String> _marketFilterTabs = ['All', 'Electronics', 'Clothing', 'Footwear', 'Accessories'];
  final List<String> _shopFilterTabs = ['All', 'Clothing', 'Electronics', 'Shoes', 'Accessories'];
  final List<String> _pharmacyFilterTabs = ['All', 'Meds', 'Health', 'First Aid'];
  final List<String> _filterTabs = ['All', 'Restaurants', 'Local Foods', 'Pastries', 'Soup'];

  final List<Map<String, dynamic>> _allGroceryVendors = [
    {
      'img': 'https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=800',
      'name': 'MaxMart Supermarket',
      'cat': 'Supermarket',
      'time': '30-40 min',
      'fee': '₵15 Delivery',
      'rating': '4.7',
      'price': '₵150'
    },
    {
      'img': 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?q=80&w=800',
      'name': 'Shoprite',
      'cat': 'Supermarket',
      'time': '20-30 min',
      'fee': '₵12 Delivery',
      'rating': '4.8',
      'price': '₵200'
    },
  ];

  final List<Map<String, dynamic>> _allPharmacyVendors = [
    {
      'img': 'https://images.unsplash.com/photo-1586015555751-63bb77f4322a?q=80&w=800',
      'name': 'Ernest Chemists',
      'cat': 'Pharmacy',
      'time': '15-25 min',
      'fee': '₵10 Delivery',
      'rating': '4.9',
      'price': '₵45'
    },
  ];

  final List<Map<String, dynamic>> _restaurants = [
    {
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=800',
      'name': 'Pizza Hut',
      'cat': 'Pizza',
      'time': '30-40 min',
      'fee': '₵15 Delivery',
      'rating': '4.5',
      'price': '₵120'
    },
    {
      'img': 'https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?q=80&w=800',
      'name': 'Papaye Fast Food',
      'cat': 'Main Course',
      'time': '25-35 min',
      'fee': '₵10 Delivery',
      'rating': '4.6',
      'price': '₵45'
    },
    {
      'img': 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=800',
      'name': 'KFC',
      'cat': 'Burgers',
      'time': '20-30 min',
      'fee': '₵12 Delivery',
      'rating': '4.3',
      'price': '₵75'
    },
    {
      'img': 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?q=80&w=800',
      'name': 'Mama\'s Kitchen',
      'cat': 'Local Foods',
      'time': '30-45 min',
      'fee': '₵8 Delivery',
      'rating': '4.7',
      'price': '₵55'
    },
  ];

  static const _serviceTabs = [
    {'name': 'Food', 'type': ServiceType.food},
    {'name': 'Groceries', 'type': ServiceType.groceries},
    {'name': 'Market', 'type': ServiceType.market},
    {'name': 'Shop', 'type': ServiceType.shop},
    {'name': 'Pharmacy', 'type': ServiceType.pharmacy},
    {'name': 'Laundry', 'type': ServiceType.laundry},
    {'name': 'Parcel', 'type': ServiceType.parcel},
    {'name': 'Errand', 'type': ServiceType.errand},
  ];

  @override
  Widget build(BuildContext context) {
    // Watch Registry for Real-time Synchronization
    ref.watch(liveRegistryProvider).updates;
    
    final activeOrder = ref.watch(activeOrderProvider);
    final cartItems = ref.watch(foodCartProvider);
    final cartCount = cartItems.length;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      floatingActionButton: _buildCartFab(cartCount),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedNav == 4 ? 2 : (_selectedNav == 3 ? 1 : 0),
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  _buildServiceStrip(),
                  if (_isLoading)
                    _buildSkeletonSliver()
                  else
                    _buildVerticalFeed(),
                  const SliverToBoxAdapter(child: SizedBox(height: 180)),
                ],
              ),
              const OrdersScreen(),
              const ProfileScreen(),
            ],
          ),
          if (activeOrder != null) _buildLiveActivity(activeOrder),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _onAddressTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DELIVERING TO', style: AppTypography.caption(AppColors.textMuted)),
                      Row(
                        children: [
                          Text(_locationName, style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.bold)),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildHeaderIcon(Icons.notifications_none_rounded),
              ],
            ),
            const SizedBox(height: 24),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text('Search for anything...', style: AppTypography.body()(AppColors.textMuted)),
          const Spacer(),
          const Icon(Icons.mic_none_rounded, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildServiceStrip() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _serviceTabs.length,
          itemBuilder: (context, i) {
            final type = _serviceTabs[i]['type'] as ServiceType;
            final isSelected = _selectedServiceType == type;
            return AnimatedPress(
              onTap: () {
                 if (isSelected) return;
                 setState(() {
                   _isLoading = true;
                   _selectedServiceType = type;
                 });
                 Future.delayed(const Duration(milliseconds: 600), () => setState(() => _isLoading = false));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(25),
                  border: isSelected ? null : Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Center(child: Text(_serviceTabs[i]['name'] as String, style: AppTypography.bodySm()(isSelected ? Colors.white : AppColors.textMuted).copyWith(fontWeight: FontWeight.bold))),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalFeed() {
    final list = _selectedServiceType == ServiceType.groceries
        ? _allGroceryVendors
        : _selectedServiceType == ServiceType.pharmacy
            ? _allPharmacyVendors
            : _restaurants;

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => _buildVendorCard(list[i]),
          childCount: list.length,
        ),
      ),
    );
  }

  Widget _buildVendorCard(Map<String, dynamic> vendor) {
    final registry = ref.watch(liveRegistryProvider);
    final status = registry.getVendorStatus(vendor['name']);
    final bool isClosed = status == StoreStatus.closed;
    final bool isBusy = status == StoreStatus.busy;
    
    return GestureDetector(
      onTap: isClosed ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurantData: vendor))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Opacity(
          opacity: isClosed ? 0.6 : 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(vendor['img'], height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  if (isClosed)
                    Positioned.fill(child: Container(color: Colors.black45, child: Center(child: Text('CLOSED', style: AppTypography.h2()(Colors.white))))),
                  if (isBusy && !isClosed)
                    Positioned(top: 12, left: 12, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)), child: Text('BUSY • +15M', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(vendor['name'], style: AppTypography.h3()),
                        Row(children: [const Icon(Icons.star_rounded, color: Colors.amber, size: 18), Text(vendor['rating'], style: AppTypography.bodySm().copyWith(fontWeight: FontWeight.bold))]),
                      ],
                    ),
                    Text('${vendor['cat']} • ${isBusy ? "45-55 mins" : vendor['time']}', style: AppTypography.bodySm()(AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveActivity(ActiveOrder order) {
    return Positioned(
      bottom: 110, left: 16, right: 16,
      child: AnimatedPress(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: order.orderId))),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 20, offset: const Offset(0, 10))]),
          child: Row(
            children: [
              const Icon(Icons.delivery_dining_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(order.statusMessage, style: AppTypography.bodySm()(Colors.white).copyWith(fontWeight: FontWeight.bold)), Text('Arriving in ~8 mins', style: AppTypography.bodySm()(Colors.white70))])),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.5, curve: Curves.easeOutBack);
  }

  Widget _buildCartFab(int count) {
    return Container(
      height: 64, width: 64,
      decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
      child: IconButton(onPressed: () {}, icon: Stack(clipBehavior: Clip.none, children: [const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28), if (count > 0) Positioned(top: -4, right: -4, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Text('$count', style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold))))])),
    );
  }

  Widget _buildBottomNav() {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: BottomAppBar(
        height: 80, color: Colors.white,
        notchMargin: 8, shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navIcon(Icons.home_filled, 0, 'Home'),
            _navIcon(Icons.receipt_long_rounded, 3, 'Orders'),
            const SizedBox(width: 48),
            _navIcon(Icons.bar_chart_rounded, 2, 'History'),
            _navIcon(Icons.person_rounded, 4, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index, String label) {
    final isSelected = _selectedNav == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNav = index),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 24), Text(label, style: AppTypography.bodySm()(isSelected ? AppColors.primary : AppColors.textMuted))]),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle), child: Icon(icon, size: 20));
  }

  Widget _buildSkeletonSliver() {
    return SliverToBoxAdapter(child: Shimmer.fromColors(baseColor: Colors.grey[200]!, highlightColor: Colors.grey[50]!, child: Column(children: List.generate(3, (i) => Container(height: 200, margin: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))))));
  }

  void _onAddressTap() async {
    final result = await Navigator.of(context).push<Address>(MaterialPageRoute(builder: (_) => const LocationSearchScreen()));
    if (result != null) setState(() => _locationName = result.displayLabel);
  }
}
