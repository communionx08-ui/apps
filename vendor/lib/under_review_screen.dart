import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'home_screen.dart';

class UnderReviewScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String ownerName;
  
  const UnderReviewScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    required this.ownerName,
  });

  @override
  State<UnderReviewScreen> createState() => _UnderReviewScreenState();
}

class _UnderReviewScreenState extends State<UnderReviewScreen>
    with TickerProviderStateMixin {
  bool _refreshing = false;
  late AnimationController _pulseController;
  late AnimationController _starController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _starController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _starController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    setState(() => _refreshing = true);
    Haptics.light();
    
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _refreshing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Status is still under review. We'll notify you once complete.",
              style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.textPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void _handleContactSupport() {
    Haptics.light();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening support chat...',
          style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _goToDashboard() {
    Haptics.medium();
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
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
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom App Bar
          SafeArea(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Row(
                children: [
                  AnimatedPress(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Application Status',
                      textAlign: TextAlign.center,
                      style: AppTypography.h2(AppColors.textPrimary).copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
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
                children: [
                  const SizedBox(height: 40),

                  // Hero Icon with Pulsing Animation
                  SizedBox(
                    width: 144,
                    height: 144,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer pulsing ring
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 144 + (20 * _pulseController.value),
                              height: 144 + (20 * _pulseController.value),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3 * (1 - _pulseController.value)),
                                  width: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // Main circle
                        Container(
                          width: 144,
                          height: 144,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                        
                        // Inner circle with icon
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.hourglass_empty,
                            size: 44,
                            color: AppColors.primary,
                          ),
                        ),
                        
                        // Animated stars
                        ...List.generate(3, (index) {
                          final positions = [
                            const Offset(-20, -60), // Top left
                            const Offset(50, -40),  // Top right
                            const Offset(-40, 40),  // Bottom left
                          ];
                          
                          return AnimatedBuilder(
                            animation: _starController,
                            builder: (context, child) {
                              final progress = (_starController.value + (index * 0.3)) % 1.0;
                              return Positioned(
                                left: 72 + positions[index].dx,
                                top: 72 + positions[index].dy,
                                child: Transform.rotate(
                                  angle: progress * 6.28, // Full rotation
                                  child: Opacity(
                                    opacity: 0.3 + (0.7 * (1 - progress)),
                                    child: Icon(
                                      Icons.star,
                                      size: 16 - (4 * progress),
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.8, 0.8), delay: 400.ms, duration: 800.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 32),

                  // Title and description
                  Text(
                    'Your application is\nunder review',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.2, delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 12),

                  Text(
                    "Our team is currently verifying your business details. This usually takes 24–48 business hours. We'll notify you once it's complete.",
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 800.ms, duration: 400.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 32),

                  // Action buttons with staggered animations
                  ...[
                    SwiftButton(
                      label: _refreshing ? 'Checking...' : 'Refresh Status',
                      isLoading: _refreshing,
                      onPressed: _refreshing ? null : _handleRefresh,
                      variant: SwiftButtonVariant.primary,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SwiftButton(
                      label: 'Contact Support',
                      onPressed: _handleContactSupport,
                      variant: SwiftButtonVariant.secondary,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    AnimatedPress(
                      onTap: _goToDashboard,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Go to Dashboard',
                              style: AppTypography.bodyLg(AppColors.primary).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ].asMap().entries.map((entry) {
                    final index = entry.key;
                    final widget = entry.value;
                    return widget
                        .animate()
                        .fadeIn(delay: (1000 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: (1000 + (index * 100)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
                  }).toList(),

                  const SizedBox(height: 32),

                  // Business Summary Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFF1F5F9),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Summary',
                          style: AppTypography.h2(AppColors.textPrimary).copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF9C3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFEAB308),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'PENDING REVIEW',
                                          style: AppTypography.bodySm().copyWith(
                                            color: const Color(0xFFA16207),
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  Text(
                                    widget.businessName,
                                    style: AppTypography.h2(AppColors.textPrimary).copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 4),
                                  
                                  Text(
                                    '${widget.vendorType} • ${widget.businessCategory}',
                                    style: AppTypography.body(AppColors.textSecondary),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: AppColors.textMuted,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Address on file',
                                        style: AppTypography.bodySm(AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Business icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.storefront,
                                size: 32,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1400.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 1400.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}