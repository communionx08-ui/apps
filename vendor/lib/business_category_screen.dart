import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'business_information_screen.dart';

class BusinessCategoryScreen extends StatefulWidget {
  final String vendorType;
  
  const BusinessCategoryScreen({
    super.key,
    required this.vendorType,
  });

  @override
  State<BusinessCategoryScreen> createState() => _BusinessCategoryScreenState();
}

class _BusinessCategoryScreenState extends State<BusinessCategoryScreen> {
  String? selectedCategory;

  final List<BusinessCategory> businessCategories = [
    const BusinessCategory(
      id: 'restaurant',
      label: 'Restaurant / Food',
      sub: 'Restaurants, chop bars, fast food, home kitchens',
      icon: Icons.restaurant,
    ),
    const BusinessCategory(
      id: 'groceries',
      label: 'Groceries',
      sub: 'Supermarkets, mini-marts, provision stores',
      icon: Icons.local_grocery_store,
    ),
    const BusinessCategory(
      id: 'market',
      label: 'Market Vendor',
      sub: 'Fresh produce, bulk goods, market stalls',
      icon: Icons.storefront,
    ),
    const BusinessCategory(
      id: 'pharmacy',
      label: 'Pharmacy',
      sub: 'Licensed pharmacies, health stores',
      icon: Icons.local_pharmacy,
    ),
    const BusinessCategory(
      id: 'retail',
      label: 'Shop / Retail',
      sub: 'Electronics, fashion, beauty, general retail',
      icon: Icons.shopping_bag,
    ),
    const BusinessCategory(
      id: 'laundry',
      label: 'Laundry Services',
      sub: 'Laundry, dry cleaning, wash & fold',
      icon: Icons.local_laundry_service,
    ),
  ];

  void _onContinue() {
    if (selectedCategory != null) {
      Haptics.medium();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BusinessInformationScreen(
            vendorType: widget.vendorType,
            businessCategory: selectedCategory!,
          ),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom App Bar with Progress
          SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Top row with back button and title
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        AnimatedPress(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 24,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Vendor Setup',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2(AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),
                  
                  // Progress Indicator
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 2 / 7, // Step 2 of 7
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  // Header with modern entrance animation
                  Text(
                    'What type of business\ndo you have?',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                      
                  const SizedBox(height: 8),
                  
                  Text(
                    'Choose the category that best describes your business',
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 32),

                  // Business category options with staggered animations
                  ...businessCategories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final businessCategory = entry.value;
                    final isSelected = selectedCategory == businessCategory.id;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _BusinessCategoryCard(
                        businessCategory: businessCategory,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() => selectedCategory = businessCategory.id);
                          Haptics.light();
                        },
                      )
                          .animate()
                          .fadeIn(delay: (600 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.98, 0.98), delay: (600 + (index * 100)).ms, duration: 500.ms, curve: Curves.easeOutCubic),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Button
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              top: false,
              child: SwiftButton(
                label: 'Continue to Step 3',
                onPressed: selectedCategory != null ? _onContinue : null,
                variant: selectedCategory != null 
                    ? SwiftButtonVariant.primary 
                    : SwiftButtonVariant.primary, // Will be disabled by null onPressed
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class BusinessCategory {
  final String id;
  final String label;
  final String sub;
  final IconData icon;

  const BusinessCategory({
    required this.id,
    required this.label,
    required this.sub,
    required this.icon,
  });
}

class _BusinessCategoryCard extends StatelessWidget {
  final BusinessCategory businessCategory;
  final bool isSelected;
  final VoidCallback onTap;

  const _BusinessCategoryCard({
    required this.businessCategory,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                businessCategory.icon,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessCategory.label,
                    style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    businessCategory.sub,
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}