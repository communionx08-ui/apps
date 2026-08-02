import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'verified_success_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isVerifying = false;
  bool _showError = false;
  String _errorMessage = '';
  int _secondsLeft = 60;
  Timer? _timer;
  String _enteredCode = '';
  
  @override
  void initState() {
    super.initState();
    _startTimer();
    
    // Add listeners to focus nodes for enhanced UX
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus && _showError) {
          setState(() {
            _showError = false;
            _errorMessage = '';
          });
        }
      });
    }
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        if (mounted) setState(() => _secondsLeft--);
      }
    });
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field - hide keyboard and auto-verify
        FocusScope.of(context).unfocus();
        _verifyOTP();
      }
      
      // Haptic feedback for better UX
      Haptics.light();
    }
    
    // Update entered code
    _enteredCode = _controllers.map((c) => c.text).join();
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      Haptics.light();
    }
    
    _enteredCode = _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyOTP() async {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length < 6) {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter the complete 6-digit code';
      });
      Haptics.error();
      return;
    }

    setState(() {
      _isVerifying = true;
      _showError = false;
    });

    try {
      // Simulate API verification
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (!mounted) return;
      
      // Simulate success/failure
      if (code == '123456' || code == '000000') {
        // Success
        Haptics.success();
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const VerifiedSuccessScreen(),
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
      } else {
        // Error
        setState(() {
          _showError = true;
          _errorMessage = 'Invalid code. Please try again.';
          _isVerifying = false;
        });
        
        // Clear fields and refocus first
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        
        Haptics.error();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showError = true;
          _errorMessage = 'Verification failed. Please try again.';
          _isVerifying = false;
        });
        Haptics.error();
      }
    }
  }

  Future<void> _resendCode() async {
    Haptics.medium();
    
    // Clear current code
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
    
    setState(() {
      _showError = false;
      _errorMessage = '';
    });
    
    // Restart timer
    _startTimer();
    
    // Simulate resend API call
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification code sent!',
              style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to resend code. Please try again.',
              style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  String get _formatTime {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              
              // Back button with animation
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
              
              const SizedBox(height: 32),
              
              // Title with staggered animation
              Text(
                'Verification Code',
                style: AppTypography.h1().copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.95, 0.95), delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 8),
              
              // Subtitle with phone number
              RichText(
                text: TextSpan(
                  style: AppTypography.body(AppColors.textMuted).copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'We sent a 6-digit code to '),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms, curve: Curves.easeOut)
                  .slideY(begin: 0.1, delay: 300.ms, duration: 400.ms, curve: Curves.easeOutCubic),
              
              const SizedBox(height: 40),
              
              // OTP Input Fields with enhanced animations
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  final controller = _controllers[index];
                  final focusNode = _focusNodes[index];
                  
                  return Container(
                    width: 52,
                    height: 60,
                    decoration: BoxDecoration(
                      color: focusNode.hasFocus 
                          ? AppColors.primary.withOpacity(0.05) 
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _showError
                            ? AppColors.danger
                            : focusNode.hasFocus
                                ? AppColors.primary
                                : AppColors.border,
                        width: focusNode.hasFocus || _showError ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: AppTypography.h2().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) => _onCodeChanged(value, index),
                        onTap: () {
                          // Clear error on tap
                          if (_showError) {
                            setState(() {
                              _showError = false;
                              _errorMessage = '';
                            });
                          }
                        },
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (400 + (index * 50)).ms, duration: 300.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        delay: (400 + (index * 50)).ms,
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
                      );
                }),
              ),
              
              const SizedBox(height: 16),
              
              // Error message with smooth animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _showError ? 40 : 0,
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _showError ? 1.0 : 0.0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _errorMessage,
                      style: AppTypography.bodySm(AppColors.danger).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Timer and resend section
              Center(
                child: Column(
                  children: [
                    if (_secondsLeft > 0) ...[
                      Text(
                        'Resend code in $_formatTime',
                        style: AppTypography.body(AppColors.textMuted).copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ] else ...[
                      AnimatedPress(
                        onTap: _resendCode,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Resend Code',
                                style: AppTypography.body(AppColors.primary).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 400.ms),
              
              const Spacer(),
              
              // Verify Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SwiftButton(
                  label: _isVerifying ? 'Verifying...' : 'Verify Code',
                  isLoading: _isVerifying,
                  onPressed: _enteredCode.length == 6 ? _verifyOTP : null,
                ),
              )
                  .animate()
                  .fadeIn(delay: 900.ms, duration: 500.ms, curve: Curves.easeOut)
                  .scale(begin: const Offset(0.9, 0.9), delay: 900.ms, duration: 700.ms, curve: Curves.elasticOut)
                  .shimmer(
                    delay: 1400.ms,
                    duration: 600.ms,
                    color: Colors.white.withOpacity(0.2),
                  ),
              
              // Helper text
              Center(
                child: Text(
                  'Didn\'t receive a code? Check your SMS or try calling.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                    height: 1.5,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 1000.ms, duration: 300.ms),
                  
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}