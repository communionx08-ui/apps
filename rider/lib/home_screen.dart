import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.two_wheeler,
                  size: 80,
                  color: AppColors.success,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    duration: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),
              
              const SizedBox(height: 40),
              
              Text(
                'Welcome to Swift Rider!',
                style: AppTypography.h1().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms)
                  .slideY(begin: 0.3, delay: 300.ms, duration: 500.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 16),
              
              Text(
                'You\'ve successfully completed the onboarding flow!\nThe rider dashboard is coming next.',
                textAlign: TextAlign.center,
                style: AppTypography.body(AppColors.textMuted).copyWith(
                  fontSize: 16,
                  height: 1.6,
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 400.ms)
                  .slideY(begin: 0.2, delay: 500.ms, duration: 400.ms, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }
}
