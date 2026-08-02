import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swift_core/swift_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    
    // Subtle pulse animation for logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    // Auto-advance after splash
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (mounted) {
        HapticFeedback.lightImpact();
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              
              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 450),
          ),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        child: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryLight,
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
              ),
            ),
            child: Stack(
              children: [
                // White glass blobs
                Positioned(
                  left: -100,
                  top: -50,
                  child: Transform.rotate(
                    angle: 0.6,
                    child: Container(
                      width: 250,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: Motion.slow).slideX(begin: -0.3),
                Positioned(
                  right: -100,
                  bottom: -50,
                  child: Transform.rotate(
                    angle: 0.6,
                    child: Container(
                      width: 250,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: Motion.slow).slideX(begin: 0.3),
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with breathing animation
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_pulseController.value * 0.03),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15 + (_pulseController.value * 0.05)),
                                      blurRadius: 20 + (_pulseController.value * 5),
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.flash_on_rounded,
                                    color: AppColors.primary, size: 56),
                              ),
                            );
                          },
                        )
                            .animate()
                            .scale(
                                duration: 600.ms,
                                curve: Curves.easeOutBack,
                                begin: const Offset(0.4, 0.4))
                            .then()
                            .shimmer(
                                duration: 1.seconds,
                                color: Colors.white.withOpacity(0.3)),
                        const SizedBox(height: 24),
                        Text(
                          'swift',
                          style: AppTypography.h1(Colors.white).copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                            .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                        const SizedBox(height: 8),
                        Text(
                          'Delivered fast.',
                          style: AppTypography.bodyLg(Colors.white70),
                        ).animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        ).animate().fadeIn(delay: 600.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
