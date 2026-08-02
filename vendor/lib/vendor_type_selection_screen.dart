import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'business_category_screen.dart';

class VendorTypeSelectionScreen extends StatefulWidget {
  const VendorTypeSelectionScreen({super.key});

  @override
  State<VendorTypeSelectionScreen> createState() => _VendorTypeSelectionScreenState();
}

class _VendorTypeSelectionScreenState extends State<VendorTypeSelectionScreen> {
  String? selectedVendorType;

  void _onContinue() {
    if (selectedVendorType != null) {
      Haptics.medium();
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BusinessCategoryScreen(
            vendorType: selectedVendorType!,
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
                        value: 1 / 7, // Step 1 of 7
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
                    'What type of vendor\nare you?',
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
                    'This helps us understand your registration requirements',
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 40),

                  // Individual Vendor Option
                  _VendorTypeCard(
                    vendorType: VendorType(
                      id: 'individual',
                      title: 'Individual Vendor',
                      description: 'For individuals selling without formal business registration',
                      features: [
                        'No business registration required',
                        'Perfect for home cooks & small sellers',
                        'Quick and easy setup',
                        'Start selling immediately'
                      ],
                      icon: Icons.person,
                      color: const Color(0xFF10B981),
                    ),
                    isSelected: selectedVendorType == 'individual',
                    onTap: () {
                      setState(() => selectedVendorType = 'individual');
                      Haptics.light();
                    },
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.98, 0.98), delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 20),

                  // Business Vendor Option
                  _VendorTypeCard(
                    vendorType: VendorType(
                      id: 'business',
                      title: 'Business Vendor',
                      description: 'For registered businesses with official documentation',
                      features: [
                        'Business registration documents required',
                        'For restaurants, shops & pharmacies',
                        'Professional vendor dashboard',
                        'Advanced business tools & analytics'
                      ],
                      icon: Icons.business,
                      color: AppColors.primary,
                    ),
                    isSelected: selectedVendorType == 'business',
                    onTap: () {
                      setState(() => selectedVendorType = 'business');
                      Haptics.light();
                    },
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.98, 0.98), delay: 700.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 32),

                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 24,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can upgrade from Individual to Business Vendor later by providing business registration documents.',
                            style: AppTypography.body(AppColors.primary).copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 800.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 24),
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
                label: 'Continue to Step 2',
                onPressed: selectedVendorType != null ? _onContinue : null,
                variant: selectedVendorType != null 
                    ? SwiftButtonVariant.primary 
                    : SwiftButtonVariant.primary, // Will be disabled by null onPressed
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class VendorType {
  final String id;
  final String title;
  final String description;
  final List<String> features;
  final IconData icon;
  final Color color;

  const VendorType({
    required this.id,
    required this.title,
    required this.description,
    required this.features,
    required this.icon,
    required this.color,
  });
}

class _VendorTypeCard extends StatelessWidget {
  final VendorType vendorType;
  final bool isSelected;
  final VoidCallback onTap;

  const _VendorTypeCard({
    required this.vendorType,
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected
              ? vendorType.color.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? vendorType.color : const Color(0xFFE2E8F0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                // Icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: vendorType.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    vendorType.icon,
                    size: 24,
                    color: vendorType.color,
                  ),
                ),
                const SizedBox(width: 16),

                // Title and selection indicator
                Expanded(
                  child: Text(
                    vendorType.title,
                    style: AppTypography.h2(AppColors.textPrimary).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Selection indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? vendorType.color : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? vendorType.color : const Color(0xFFCBD5E1),
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

            const SizedBox(height: 12),

            // Description
            Text(
              vendorType.description,
              style: AppTypography.body(AppColors.textSecondary).copyWith(
                fontSize: 14,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Features list
            ...vendorType.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: vendorType.color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTypography.body(AppColors.textPrimary).copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}