import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_core/swift_core.dart';
import 'home_screen.dart';

class AllSetScreen extends StatefulWidget {
  const AllSetScreen({super.key});

  @override
  State<AllSetScreen> createState() => _AllSetScreenState();
}

class _AllSetScreenState extends State<AllSetScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _confettiController;
  late AnimationController _celebrationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    Haptics.success();
    
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _celebrationController,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));

    _celebrationController.forward();
    _confettiController.forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _navigateToHome();
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _celebrationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToHome() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_done', true);
      await prefs.setBool('user_logged_in', true);
    } catch (e) {
      // Continue even if preferences fail
    }
    
    if (!mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 600),
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Confetti particles
          ...List.generate(20, (index) {
            final colors = [
              AppColors.primary,
              AppColors.accent,
              AppColors.success,
              AppColors.food,
              AppColors.parcel,
            ];
            
            final color = colors[index % colors.length];
            final left = (index * 18.0) % MediaQuery.of(context).size.width;
            
            return Positioned(
              left: left,
              top: -50,
              child: RotationTransition(
                turns: _rotateAnimation,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                  ),
                ),
              ),
            )
                .animate()
                .moveY(
                  delay: (index * 100).ms,
                  duration: Duration(milliseconds: 1500 + (index * 50)),
                  begin: -50,
                  end: MediaQuery.of(context).size.height + 50,
                  curve: Curves.easeInOut,
                )
                .fadeOut(
                  delay: Duration(milliseconds: 1000 + (index * 100)),
                  duration: 500.ms,
                );
          }),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Spacer(),
                  
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.accent.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ...List.generate(8, (index) {
                            final radius = 60.0;
                            final x = radius * (index % 2 == 0 ? 0.8 : 1.2) * (index.isEven ? 1 : -1);
                            final y = radius * (index % 2 == 0 ? 0.8 : 1.2) * (index.isOdd ? 1 : -1);
                            
                            return Positioned(
                              left: 70 + x,
                              top: 70 + y,
                              child: Icon(
                                Icons.star,
                                size: 16,
                                color: AppColors.accent,
                              ),
                            )
                                .animate(onPlay: (controller) => controller.repeat())
                                .scale(
                                  delay: (index * 200).ms,
                                  duration: 1000.ms,
                                  curve: Curves.easeInOut,
                                )
                                .fadeIn(
                                  delay: (index * 200).ms,
                                  duration: 500.ms,
                                )
                                .then(delay: 500.ms)
                                .fadeOut(duration: 500.ms);
                          }),
                          
                          Icon(
                            Icons.two_wheeler,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Text(
                    'You\'re Ready to Ride!',
                    style: AppTypography.h1().copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.3, delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic)
                      .then(delay: 200.ms)
                      .shimmer(
                        duration: 1000.ms,
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Welcome to Swift Rider! Start accepting delivery requests and earning in your area.',
                    textAlign: TextAlign.center,
                    style: AppTypography.body(AppColors.textMuted).copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 400.ms)
                      .slideY(begin: 0.2, delay: 800.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFeatureHighlight(
                        icon: Icons.delivery_dining,
                        label: 'Deliveries',
                        color: AppColors.food,
                        delay: 1000,
                      ),
                      _buildFeatureHighlight(
                        icon: Icons.attach_money,
                        label: 'Earnings',
                        color: AppColors.success,
                        delay: 1100,
                      ),
                      _buildFeatureHighlight(
                        icon: Icons.schedule,
                        label: 'Flexible',
                        color: AppColors.accent,
                        delay: 1200,
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  SwiftButton(
                    label: 'Start Earning',
                    onPressed: _navigateToHome,
                  )
                      .animate()
                      .fadeIn(delay: 1400.ms, duration: 400.ms)
                      .slideY(begin: 0.2, delay: 1400.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                      .shimmer(
                        delay: 2000.ms,
                        duration: 800.ms,
                        color: Colors.white.withOpacity(0.3),
                      ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    'Taking you to the app in a moment...',
                    style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                      fontSize: 13,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1600.ms, duration: 300.ms),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlight({
    required IconData icon,
    required String label,
    required Color color,
    required int delay,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTypography.bodySm().copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 300.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          delay: delay.ms,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        )
        .then(delay: 400.ms)
        .shake(
          delay: (delay + 800).ms,
          duration: 400.ms,
          hz: 2,
        );
  }
}
