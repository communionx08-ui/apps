import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'profile_setup_screen.dart';

class VerifiedSuccessScreen extends StatefulWidget {
  const VerifiedSuccessScreen({super.key});

  @override
  State<VerifiedSuccessScreen> createState() => _VerifiedSuccessScreenState();
}

class _VerifiedSuccessScreenState extends State<VerifiedSuccessScreen>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Success haptic feedback
    Haptics.success();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    ));

    // Start animation
    _controller.forward();

    // Auto-navigate after delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProfileSetupScreen(),
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                
                // Success icon with bouncy animation
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: AppColors.success,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Success text with fade animation
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Verified!',
                        style: AppTypography.h1().copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .shimmer(
                            delay: 800.ms,
                            duration: 800.ms,
                            color: AppColors.success.withOpacity(0.3),
                          ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Your phone number has been\nsuccessfully verified',
                        textAlign: TextAlign.center,
                        style: AppTypography.body(AppColors.textMuted).copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Loading indicator and text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .rotate(duration: 1500.ms),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Setting up your account...',
                        style: AppTypography.body(AppColors.textMuted).copyWith(
                          fontSize: 15,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1200.ms, duration: 400.ms),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
