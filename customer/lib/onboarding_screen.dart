import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swift_core/swift_core.dart';
import 'get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _page = PageController();
  int _idx = 0;
  late AnimationController _dotController;
  late Animation<double> _dotAnimation;

  final _pages = const [
    _Page(
      title: 'Food and ',
      highlight: 'Shopping',
      highlightAfter: ' made Easy',
      subtitle: 'Order meals, market items, and shop products from nearby stores.',
      image: 'assets/images/splash1.png',
    ),
    _Page(
      title: 'Your Daily ',
      highlight: 'Essentials',
      highlightAfter: ' Delivered',
      subtitle: 'Get pharmacy, laundry, school, and business services with ease.',
      image: 'assets/images/splash2.png',
    ),
    _Page(
      title: 'We run ',
      highlight: 'Errands',
      highlightAfter: ' for You',
      subtitle: 'Send parcels, move items and complete tasks without stress.',
      image: 'assets/images/splash3.png',
    ),
    _Page(
      title: 'Send and Receive ',
      highlight: 'Parcels',
      highlightAfter: ' Fast',
      subtitle: 'Deliver packages across town safely and on time. We handle all that for you.',
      image: 'assets/images/splash4.png',
    ),
  ];

  bool get _last => _idx == _pages.length - 1;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dotAnimation = CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() { 
    _page.dispose(); 
    _dotController.dispose();
    super.dispose(); 
  }

  Future<void> _finish() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setBool('onboarding_done', true);
    } catch (_) {}
    if (!mounted) return;
    // Navigate to Get Started screen
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const GetStartedScreen(),
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

  void _next() {
    Haptics.light();
    if (_last) { _finish(); return; }
    _page.nextPage(
      duration: const Duration(milliseconds: 400), 
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Skip button (hidden on last page) with fluid entry
            if (!_last)
              Positioned(
                top: 8,
                right: 8,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'Skip',
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1200.ms, duration: 400.ms, curve: Curves.easeOut)
                    .scale(begin: const Offset(0.95, 0.95), delay: 1200.ms, duration: 500.ms, curve: Curves.easeOutCubic),
              ),

            // PageView with smooth transitions (no AnimatedSwitcher to prevent image flash)
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _page,
                    onPageChanged: (i) {
                      setState(() => _idx = i);
                      _dotController.reset();
                      _dotController.forward();
                    },
                    itemCount: _pages.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, i) => _PageView(
                      key: ValueKey(i),
                      page: _pages[i],
                    ),
                  ),
                ),

                // Bottom controls
                Padding(
                  padding: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
                  child: Column(
                    children: [
                      // Smooth pagination dots with PageView listener
                      SizedBox(
                        height: 12,
                        child: AnimatedBuilder(
                          animation: _page,
                          builder: (context, child) {
                            double currentPage = 0;
                            if (_page.hasClients && _page.position.hasContentDimensions) {
                              currentPage = _page.page ?? 0;
                            }
                            
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(_pages.length, (index) {
                                double distance = (currentPage - index).abs();
                                bool isActive = distance < 0.5;
                                double opacity = isActive ? 1.0 : 0.3;
                                double width = isActive ? 32.0 : 16.0;
                                
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  height: 4,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(opacity),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 500.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.95, 0.95), delay: 800.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 40),
                      
                      // Continue / Get Started button with micro-interactions
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _last ? 'Get Started' : 'Continue',
                            style: AppTypography.button(Colors.white).copyWith(
                              fontSize: 19.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.9, 0.9), delay: 1000.ms, duration: 700.ms, curve: Curves.elasticOut)
                          .shimmer(delay: 1500.ms, duration: 600.ms, color: Colors.white.withOpacity(0.2)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({super.key, required this.page});
  final _Page page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Image with gentle entry animation (no shimmer to prevent flashing)
            Image.asset(
              page.image,
              height: 350,
              fit: BoxFit.contain,
            )
                .animate()
                .fadeIn(duration: 400.ms, curve: Curves.easeOut)
                .scale(
                  begin: const Offset(0.9, 0.9),
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),
            
            const SizedBox(height: 40),
            
            // Title with staggered animation
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.h1().copyWith(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(text: page.title),
                  TextSpan(
                    text: page.highlight,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(text: page.highlightAfter),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms, curve: Curves.easeOut)
                .slideY(begin: 0.2, delay: 200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
            
            const SizedBox(height: 16),
            
            // Subtitle with delayed entry
            Text(
              page.subtitle,
              textAlign: TextAlign.center,
              style: AppTypography.body(AppColors.textSecondary).copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 300.ms, curve: Curves.easeOut)
                .slideY(begin: 0.15, delay: 400.ms, duration: 300.ms, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}

class _Page {
  final String title, highlight, highlightAfter, subtitle, image;
  const _Page({
    required this.title,
    required this.highlight,
    required this.highlightAfter,
    required this.subtitle,
    required this.image,
  });
}
