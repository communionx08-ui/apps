import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'all_set_screen.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen>
    with TickerProviderStateMixin {
  
  bool _isRequesting = false;
  late AnimationController _bellController;
  late Animation<double> _bellAnimation;

  @override
  void initState() {
    super.initState();
    
    // Bell shake animation
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _bellAnimation = Tween<double>(
      begin: -0.1,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _bellController,
      curve: Curves.elasticInOut,
    ));
    
    // Start the bell animation after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _bellController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _bellController.dispose();
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    setState(() => _isRequesting = true);
    Haptics.medium();
    
    try {
      // Simulate notification permission request
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      
      // For web/demo, we'll assume permission is granted
      // In a real app, use firebase_messaging or similar
      
      Haptics.success();
      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AllSetScreen(),
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
              'Notifications disabled. You can enable them later in settings.',
              style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
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
              MaterialPageRoute(builder: (_) => const AllSetScreen()),
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
        pageBuilder: (context, animation, secondaryAnimation) => const AllSetScreen(),
        transitionDuration: const Duration(milliseconds: 400),
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
                          .fadeIn(delay: 100.ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.95, 0.95), delay: 100.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                      Expanded(
                        child: Center(
                          child: Text(
                            'Notifications',
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
                  
                  // Progress bar - 4/4 steps (complete)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 1.0, // Final step
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
                    
                    // Animated notification bell
                    RotationTransition(
                      turns: _bellAnimation,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(70),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Notification waves
                            ...List.generate(2, (index) {
                              return Container(
                                width: 140 + (index * 30),
                                height: 140 + (index * 30),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accent.withOpacity(0.3 - (index * 0.1)),
                                    width: 2,
                                  ),
                                ),
                              )
                                  .animate(onPlay: (controller) => controller.repeat())
                                  .scale(
                                    begin: const Offset(0.7, 0.7),
                                    duration: Duration(milliseconds: 1500 + (index * 300)),
                                    curve: Curves.easeOut,
                                  )
                                  .fadeOut(
                                    begin: 0.8,
                                    duration: Duration(milliseconds: 1500 + (index * 300)),
                                  );
                            }),
                            
                            // Main bell icon
                            Icon(
                              Icons.notifications,
                              size: 80,
                              color: AppColors.accent,
                            ),
                            
                            // Notification dot
                            Positioned(
                              top: 25,
                              right: 25,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: AppTypography.bodySm()(Colors.white).copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                .animate(onPlay: (controller) => controller.repeat())
                                .scale(
                                  begin: const Offset(0.8, 0.8),
                                  duration: 800.ms,
                                  curve: Curves.easeInOut,
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
                      'Stay Updated',
                      style: AppTypography.h1().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 600.ms, duration: 600.ms, curve: Curves.elasticOut),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      'Get notified about your order status, special offers, and new restaurants in your area. You can customize these settings later.',
                      textAlign: TextAlign.center,
                      style: AppTypography.body()(AppColors.textMuted).copyWith(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 700.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 40),
                    
                    // Benefits list
                    Column(
                      children: [
                        _buildBenefit(
                          icon: Icons.delivery_dining,
                          title: 'Order status updates',
                          subtitle: 'Track your delivery in real-time',
                          delay: 800,
                        ),
                        const SizedBox(height: 16),
                        _buildBenefit(
                          icon: Icons.local_offer,
                          title: 'Exclusive deals & offers',
                          subtitle: 'Never miss a great discount',
                          delay: 900,
                        ),
                        const SizedBox(height: 16),
                        _buildBenefit(
                          icon: Icons.new_releases,
                          title: 'New restaurants & menus',
                          subtitle: 'Discover fresh options near you',
                          delay: 1000,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Buttons
                    SwiftButton(
                      label: _isRequesting ? 'Enabling...' : 'Enable Notifications',
                      isLoading: _isRequesting,
                      onPressed: _requestNotificationPermission,
                    )
                        .animate()
                        .fadeIn(delay: 1100.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.9, 0.9), delay: 1100.ms, duration: 700.ms, curve: Curves.elasticOut)
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
                          'Skip for now',
                          style: AppTypography.body()(AppColors.textMuted).copyWith(
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
    required String subtitle,
    required int delay,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.accent,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.body().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 300.ms)
        .slideX(begin: 0.2, delay: delay.ms, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}