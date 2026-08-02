import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'otp_verification_screen.dart';

class PhoneCollectionScreen extends StatefulWidget {
  final String? email;
  final String? name;
  final String? socialProvider; // 'google', 'apple', etc.
  
  const PhoneCollectionScreen({
    super.key,
    this.email,
    this.name,
    this.socialProvider,
  });

  @override
  State<PhoneCollectionScreen> createState() => _PhoneCollectionScreenState();
}

class _PhoneCollectionScreenState extends State<PhoneCollectionScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  bool _isLoading = false;
  String? _phoneError;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    Haptics.medium();
    final raw = _phoneCtrl.text.trim().replaceAll(RegExp(r'[-\s]'), '');
    String digits = raw.startsWith('0') ? raw.substring(1) : raw;
    if (digits.length < 9) {
      setState(() => _phoneError = 'Enter a valid 9-digit phone number');
      Haptics.error();
      return;
    }
    setState(() => _phoneError = null);
    final fullPhone = '+233$digits';
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OTPVerificationScreen(phoneNumber: fullPhone),
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

  String get _providerText {
    if (widget.socialProvider == 'google') return 'Google';
    if (widget.socialProvider == 'apple') return 'Apple';
    if (widget.email != null) return 'email';
    return 'account';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
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
                        'Phone Number Required',
                        style: AppTypography.h3().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    
                    // Phone icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(
                        Icons.phone_android,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          delay: 200.ms,
                          duration: 600.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    
                    const SizedBox(height: 32),
                    
                    // Title
                    Text(
                      'Almost Done!',
                      style: AppTypography.h1().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 400.ms, duration: 600.ms, curve: Curves.elasticOut),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Text.rich(
                      TextSpan(
                        style: AppTypography.body()(AppColors.textMuted).copyWith(
                          fontSize: 16,
                          height: 1.6,
                        ),
                        children: [
                          const TextSpan(text: 'Your '),
                          TextSpan(
                            text: _providerText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const TextSpan(text: ' account is ready! We need your phone number for delivery notifications and order updates.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 500.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 40),
                    
                    // Benefits
                    Column(
                      children: [
                        _buildBenefit(
                          icon: Icons.notifications_active,
                          title: 'Delivery notifications',
                          delay: 600,
                        ),
                        const SizedBox(height: 12),
                        _buildBenefit(
                          icon: Icons.phone,
                          title: 'Driver contact',
                          delay: 700,
                        ),
                        const SizedBox(height: 12),
                        _buildBenefit(
                          icon: Icons.security,
                          title: 'Account security',
                          delay: 800,
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                    
                    // Phone input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _phoneError != null ? AppColors.danger : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/ghana_flag.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '+233',
                            style: AppTypography.bodyLg().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '|',
                            style: AppTypography.bodyLg()(AppColors.textMuted),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              style: AppTypography.bodyLg().copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone number',
                                hintStyle: AppTypography.bodyLg()(AppColors.textMuted),
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (_) {
                                if (_phoneError != null) {
                                  setState(() => _phoneError = null);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 400.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.98, 0.98), delay: 900.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                    
                    // Error message
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _phoneError != null
                          ? Padding(
                              key: const ValueKey('error'),
                              padding: const EdgeInsets.only(top: 8, left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _phoneError!,
                                  style: AppTypography.bodySm()(AppColors.danger).copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('no-error')),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Continue button
                    SwiftButton(
                      label: 'Verify Phone Number',
                      isLoading: _isLoading,
                      onPressed: _onContinue,
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.9, 0.9), delay: 1000.ms, duration: 700.ms, curve: Curves.elasticOut)
                        .shimmer(
                          delay: 1500.ms,
                          duration: 600.ms,
                          color: Colors.white.withOpacity(0.2),
                        ),
                    
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTypography.body().copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 18,
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: delay.ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}