import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'address_setup_screen.dart';
import 'notification_permission_screen.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with TickerProviderStateMixin {
  
  bool _isRequesting = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the location icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _isRequesting = true);
    Haptics.medium();
    
    try {
      // Simulate location permission request
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      
      // For web/demo, we'll assume permission is granted
      // In a real app, use geolocator or location packages
      
      Haptics.success();
      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AddressSetupScreen(
            onNext: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPermissionScreen()),
              );
            },
          ),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
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
    } catch (e) {
      if (mounted) {
        setState(() => _isRequesting = false);
        
        // Show error and continue anyway
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location access denied. You can enable it later in settings.',
              style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.textPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        
        // Continue to next screen after short delay
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => AddressSetupScreen(
                onNext: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationPermissionScreen()),
                  );
                },
              )),
            );
          }
        });
      }
    }
  }

  void _skipForNow() {
    Haptics.light();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddressSetupScreen(
          onNext: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NotificationPermissionScreen()),
            );
          },
        ),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with progress
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedPress(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 300.ms)
                          .slideX(begin: -0.3, delay: 100.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                      Expanded(
                        child: Center(
                          child: Text(
                            'Location Access',
                            style: AppTypography.h3().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 48), // Balance the back button
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Progress bar - 3/4 steps
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.75, // 3 out of 4 steps
                      minHeight: 4,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                      .animate()
                      .scaleX(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    
                    // Animated location icon
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ripple effect
                            ...List.generate(3, (index) {
                              return Container(
                                width: 140 + (index * 20),
                                height: 140 + (index * 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.2 - (index * 0.05)),
                                    width: 1,
                                  ),
                                ),
                              )
                                  .animate(onPlay: (controller) => controller.repeat())
                                  .scale(
                                    begin: const Offset(0.8, 0.8),
                                    duration: Duration(milliseconds: 2000 + (index * 500)),
                                    curve: Curves.easeOut,
                                  )
                                  .fadeOut(
                                    begin: 0.8,
                                    duration: Duration(milliseconds: 2000 + (index * 500)),
                                  );
                            }),
                            
                            // Main icon
                            Icon(
                              Icons.location_on,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 600.ms)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          delay: 300.ms,
                          duration: 600.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    
                    const SizedBox(height: 40),
                    
                    // Title
                    Text(
                      'Enable Location Access',
                      style: AppTypography.h1().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms)
                        .slideY(begin: 0.3, delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      'We need your location to find restaurants, stores, and delivery partners near you. This helps us provide accurate delivery times and costs.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body(AppColors.textMuted).copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms)
                        .slideY(begin: 0.2, delay: 700.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 40),
                    
                    // Benefits list
                    Column(
                      children: [
                        _buildBenefit(
                          icon: Icons.restaurant,
                          title: 'Find nearby restaurants',
                          delay: 800,
                        ),
                        const SizedBox(height: 16),
                        _buildBenefit(
                          icon: Icons.local_shipping,
                          title: 'Accurate delivery times',
                          delay: 900,
                        ),
                        const SizedBox(height: 16),
                        _buildBenefit(
                          icon: Icons.attach_money,
                          title: 'Precise delivery costs',
                          delay: 1000,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Buttons
                    SwiftButton(
                      label: _isRequesting ? 'Enabling...' : 'Enable Location Access',
                      isLoading: _isRequesting,
                      onPressed: _requestLocationPermission,
                    )
                        .animate()
                        .fadeIn(delay: 1100.ms, duration: 400.ms)
                        .slideY(begin: 0.2, delay: 1100.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                        .shimmer(
                          delay: 1600.ms,
                          duration: 600.ms,
                          color: Colors.white.withOpacity(0.2),
                        ),
                    
                    const SizedBox(height: 16),
                    
                    AnimatedPress(
                      onTap: _skipForNow,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Maybe later',
                          style: AppTypography.body(AppColors.textMuted).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1200.ms, duration: 300.ms),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required int delay,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: AppTypography.body().copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 20,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 300.ms)
        .slideX(begin: 0.2, delay: delay.ms, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}