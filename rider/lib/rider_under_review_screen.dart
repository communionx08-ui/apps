import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RiderUnderReviewScreen extends StatelessWidget {
  const RiderUnderReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pending_actions,
                  size: 60,
                  color: AppColors.primary,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.8, 0.8), delay: 200.ms, duration: 800.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 32),
              
              Text(
                'Application Submitted!',
                style: AppTypography.h1().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 500.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.2, delay: 400.ms, duration: 500.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 16),
              
              Text(
                'Thank you for applying to be a Swift rider. Our team is reviewing your application and documents.',
                style: AppTypography.body()(AppColors.textSecondary).copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.1, delay: 600.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 40),
              
              // Info Cards
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Review Time',
                      value: '24-48 hours',
                    ),
                    const Divider(height: 32),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'We\'ll notify you via',
                      value: 'Email & SMS',
                    ),
                    const Divider(height: 32),
                    _InfoRow(
                      icon: Icons.phone_android,
                      label: 'Questions?',
                      value: 'Call us: 0302 123 456',
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 500.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.95, 0.95), delay: 800.ms, duration: 600.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Make sure your phone number is active so we can reach you with updates.',
                        style: AppTypography.body()(AppColors.primary).copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 400.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const Spacer(),
              
              SwiftButton(
                label: 'Done',
                onPressed: () {
                  // In a real app, this would navigate to home or login
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              )
                  .animate()
                  .fadeIn(delay: 1200.ms, duration: 500.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.1, delay: 1200.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                  .then(delay: 300.ms)
                  .shimmer(duration: 600.ms, color: Colors.white.withOpacity(0.2)),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.body()(AppColors.textMuted).copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTypography.body()(AppColors.textPrimary).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
