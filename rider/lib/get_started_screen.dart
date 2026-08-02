import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'otp_verification_screen.dart';
import 'rider_smileid_personal_details_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
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
    _showPhoneInputModal();
  }

  void _showPhoneInputModal() {
    Haptics.light();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _PhoneInputFullScreen(
          controller: _phoneCtrl,
          onContinue: (String phone) {
            final fullPhone = '+233$phone';
            // Navigate to SmileID verification flow
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const RiderSmileIdPersonalDetailsScreen(),
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
          },
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _showComingSoon(String message) {
    Haptics.light();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (flipped horizontally like Swift)
          Positioned.fill(
            child: Transform.scale(
              scaleX: -1,
              child: Image.asset(
                'assets/images/get_started_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms, curve: Curves.easeOut)
              .scale(begin: const Offset(1.1, 1.1), duration: 1200.ms, curve: Curves.easeOutCubic),

          // Dark Overlay with subtle animation
          Positioned.fill(
            child: Container(
              color: const Color(0x33000000),
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms),

          // Title Section with staggered animations
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Akwaaba!',
                  style: AppTypography.h1()(Colors.white).copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                    height: 1.2,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms, curve: Curves.easeOut)
                    .slideY(begin: 0.3, delay: 400.ms, duration: 600.ms, curve: Curves.easeOutCubic)
                    .then(delay: 200.ms)
                    .shimmer(duration: 800.ms, color: Colors.white.withOpacity(0.3)),
                
                const SizedBox(height: 8),
                
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: AppTypography.body()(Colors.white).copyWith(fontSize: 16.96),
                    children: const [
                      TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: 'Swift',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ', Login or\nsign up to order.',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms, curve: Curves.easeOut)
                    .slideY(begin: 0.2, delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),
              ],
            ),
          ),

          // Bottom Card with fluid entrance
          Positioned(
            bottom: 31,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Started Now!',
                      style: AppTypography.h1().copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.9, 0.9), delay: 800.ms, duration: 600.ms, curve: Curves.elasticOut),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      'Enter your phone number',
                      style: AppTypography.body()(AppColors.textSecondary).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 900.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 24),

                    // Phone Input - Acts as button with micro-interactions
                    AnimatedPress(
                      onTap: _showPhoneInputModal,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE9EAEB)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/ghana_flag.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '+233',
                                style: AppTypography.bodyLg().copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '|',
                                style: AppTypography.bodyLg()(AppColors.textMuted).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _phoneCtrl.text.isEmpty
                                      ? 'Phone Number'
                                      : _phoneCtrl.text,
                                  style: AppTypography.bodyLg()(_phoneCtrl.text.isEmpty
                                          ? AppColors.textMuted
                                          : AppColors.textPrimary)
                                      .copyWith(
                                    fontWeight: _phoneCtrl.text.isEmpty
                                        ? FontWeight.w400
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 1000.ms, duration: 600.ms, curve: Curves.elasticOut),

                    // Error text with smooth appearance
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: _phoneError != null
                          ? Padding(
                              key: const ValueKey('error'),
                              padding: const EdgeInsets.only(top: 6, left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _phoneError!,
                                  style: AppTypography.bodySm()(AppColors.danger).copyWith(fontSize: 13),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(key: ValueKey('no-error')),
                    ),

                    const SizedBox(height: 16),

                    // Continue Button with loading state
                    SwiftButton(
                      label: 'Continue',
                      isLoading: _isLoading,
                      onPressed: _onContinue,
                    )
                        .animate()
                        .fadeIn(delay: 1100.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.9, 0.9), delay: 1100.ms, duration: 700.ms, curve: Curves.elasticOut)
                        .then(delay: 400.ms)
                        .shimmer(duration: 600.ms, color: Colors.white.withOpacity(0.2)),
                    
                    const SizedBox(height: 16),

                    // OR Divider with staggered animation
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppTypography.body()(AppColors.textMuted).copyWith(
                              fontSize: 16.96,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 1200.ms, duration: 300.ms),

                    const SizedBox(height: 16),

                    // Social Buttons with sequential animations
                    ...[
                      _SocialButton(
                        icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 24),
                        label: 'Continue with Google',
                        onTap: () => _showComingSoon(
                          'Google Sign-In coming soon. Please use your phone number for now.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SocialButton(
                        icon: const Icon(Icons.apple, color: Colors.black, size: 24),
                        label: 'Continue with Apple',
                        onTap: () => _showComingSoon(
                          'Apple Sign-In coming soon. Please use your phone number for now.',
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SocialButton(
                        icon: const Icon(Icons.mail_outline, color: Colors.black, size: 24),
                        label: 'Continue with Email',
                        onTap: () => _showComingSoon(
                          'Email Sign-In coming soon. Please use your phone number for now.',
                        ),
                      ),
                    ].asMap().entries.map((entry) {
                      final index = entry.key;
                      final widget = entry.value;
                      return widget
                          .animate()
                          .fadeIn(delay: (1300 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.95, 0.95), delay: (1300 + (index * 100)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
                    }).toList(),

                    const SizedBox(height: 16),

                    // OR Divider
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: AppTypography.body()(AppColors.textMuted).copyWith(
                              fontSize: 16.96,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: Color(0xFFE2E8F0), thickness: 1)),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 1600.ms, duration: 300.ms),

                    const SizedBox(height: 16),

                    // Find my account
                    AnimatedPress(
                      onTap: () => _showComingSoon('Account recovery coming soon.'),
                      child: Text(
                        'Find my account',
                        style: AppTypography.body()(AppColors.textMuted).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1700.ms, duration: 300.ms),
                  ],
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 500.ms, curve: Curves.easeOut)
                .slideY(begin: 0.3, delay: 700.ms, duration: 600.ms, curve: Curves.easeOutCubic),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodyLg().copyWith(
                fontSize: 19.23,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Full Screen Phone Input (Swiftly Feel + Swift Look)
class _PhoneInputFullScreen extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onContinue;

  const _PhoneInputFullScreen({
    required this.controller,
    required this.onContinue,
  });

  @override
  State<_PhoneInputFullScreen> createState() => _PhoneInputFullScreenState();
}

class _PhoneInputFullScreenState extends State<_PhoneInputFullScreen> {
  String? _phoneError;
  String _verificationMethod = 'SMS';
  bool _isLoading = false;

  void _handleContinue() {
    Haptics.medium();
    final raw = widget.controller.text.trim().replaceAll(RegExp(r'[-\s]'), '');
    String digits = raw.startsWith('0') ? raw.substring(1) : raw;
    if (digits.length < 9) {
      setState(() => _phoneError = 'Enter a valid 9-digit phone number');
      Haptics.error();
      return;
    }
    setState(() => _phoneError = null);
    setState(() => _isLoading = true);
    
    // Simulate API call with smooth loading
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Haptics.success();
        widget.onContinue(digits);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: AnimatedPress(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // Title with animation
              Text(
                'Enter your number',
                style: AppTypography.h1().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.3, delay: 200.ms, duration: 500.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 8),
              
              Text(
                'We\'ll send a code for verification',
                style: AppTypography.body()(AppColors.textMuted).copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms)
                  .slideY(begin: 0.2, delay: 300.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 32),

              // Country Selector + Phone Input with staggered animations
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country selector button
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE9EAEB)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/ghana_flag.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+233',
                          style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideX(begin: -0.2, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(width: 12),

                  // Phone Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: widget.controller,
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                            style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Phone number',
                              hintStyle: AppTypography.bodyLg()(AppColors.textMuted),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.danger, width: 2),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.danger, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            onSubmitted: (_) => _handleContinue(),
                          ),
                        ),
                        
                        // Error text with smooth animation
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: animation,
                            child: FadeTransition(opacity: animation, child: child),
                          ),
                          child: _phoneError != null
                              ? Padding(
                                  key: const ValueKey('error'),
                                  padding: const EdgeInsets.only(top: 6, left: 4),
                                  child: Text(
                                    _phoneError!,
                                    style: AppTypography.bodySm()(AppColors.danger),
                                  ),
                                )
                              : const SizedBox.shrink(key: ValueKey('no-error')),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 400.ms)
                        .slideX(begin: 0.2, delay: 500.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // Verification Method Options with sequential animations
              _VerificationOption(
                label: 'Use SMS',
                isSelected: _verificationMethod == 'SMS',
                onTap: () => setState(() => _verificationMethod = 'SMS'),
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 300.ms)
                  .slideX(begin: 0.1, delay: 600.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 16),
              
              _VerificationOption(
                label: 'Use WhatsApp',
                isSelected: _verificationMethod == 'WhatsApp',
                onTap: () => setState(() => _verificationMethod = 'WhatsApp'),
              )
                  .animate()
                  .fadeIn(delay: 700.ms, duration: 300.ms)
                  .slideX(begin: 0.1, delay: 700.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 24),

              // Privacy text
              Text(
                'Swift will not send anything without your consent.',
                style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 300.ms),

              const Spacer(),

              // Continue Button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SwiftButton(
                  label: 'Continue',
                  isLoading: _isLoading,
                  onPressed: _handleContinue,
                ),
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 400.ms)
                  .slideY(begin: 0.2, delay: 900.ms, duration: 400.ms, curve: Curves.easeOutCubic)
                  .then(delay: 300.ms)
                  .shimmer(duration: 600.ms, color: Colors.white.withOpacity(0.2)),
            ],
          ),
        ),
      ),
    );
  }
}

// Verification Option Widget with micro-interactions
class _VerificationOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VerificationOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: () {
        Haptics.light();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE9EAEB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                color: Colors.white,
              ),
              child: isSelected
                  ? Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.elasticOut,
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.bodyLg().copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}