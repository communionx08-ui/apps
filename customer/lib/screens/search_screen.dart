import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'voice_search_screen.dart';
import 'restaurant_screen.dart';
import 'vendor_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Food', 'Groceries', 'Pharmacy', 'Shop', 'Market'];

  final List<String> _recentSearches = ['Jollof Rice', 'Burger', 'Laptop', 'Bread'];

  List<CatalogItem> get _filteredResults {
    final catalog = CatalogService();
    if (_searchController.text.isEmpty) return [];
    
    return catalog.search(_searchController.text).where((item) {
      final matchesFilter = _selectedFilter == 'All' ||
          item.vertical.label == _selectedFilter;
      return matchesFilter;
    }).toList();
  }

  void _navigateToResult(CatalogItem result) {
    if (result.vertical == ServiceType.food) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => RestaurantScreen(restaurantData: {
            'img': result.imageUrl,
            'name': result.vendorName,
            'cat': result.category,
            'time': '20-30 min',
            'fee': '₵12 Delivery',
            'rating': '4.6',
          }),
        ));
    } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const VendorListScreen(serviceType: ServiceType.groceries),
        ));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search restaurants, groceries...',
                    hintStyle: AppFonts.inter(color: const Color(0xFF94A3B8), fontSize: 14),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  child: const Icon(Icons.close, color: Color(0xFF94A3B8), size: 18),
                ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(builder: (_) => const VoiceSearchScreen()),
                  );
                  if (result != null && result.isNotEmpty) {
                    setState(() {
                      _searchController.text = result;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(Icons.mic_outlined, color: const Color(0xFF0068FF), size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0068FF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? const Color(0xFF0068FF) : const Color(0xFFE2E8F0)),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: AppFonts.inter(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Container(height: 1, color: const Color(0xFFF1F5F9)),

          Expanded(
            child: _searchController.text.isEmpty
                ? _buildRecentSearches()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Recent Searches',
          style: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentSearches.map((term) {
            return GestureDetector(
              onTap: () {
                _searchController.text = term;
                _searchController.selection = TextSelection.fromPosition(
                  TextPosition(offset: term.length),
                );
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, color: Color(0xFF94A3B8), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: AppFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredResults;

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 56, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different search term or filter',
              style: AppFonts.inter(
                fontSize: 13,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return GestureDetector(
          onTap: () => _navigateToResult(item),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.vendorName,
                        style: AppFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF0068FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.category,
                        style: AppFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₵${item.price.toStringAsFixed(2)}',
                  style: AppFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
        );
      },
    );
  }
}
