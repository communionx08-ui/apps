import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'business_location_screen.dart';

class BusinessInformationScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  
  const BusinessInformationScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
  });

  @override
  State<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _businessNameCtrl = TextEditingController();
  final TextEditingController _businessDescCtrl = TextEditingController();
  final TextEditingController _businessPhoneCtrl = TextEditingController();
  final TextEditingController _businessEmailCtrl = TextEditingController();

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _businessDescCtrl.dispose();
    _businessPhoneCtrl.dispose();
    _businessEmailCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      Haptics.medium();
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => BusinessLocationScreen(
            vendorType: widget.vendorType,
            businessCategory: widget.businessCategory,
            businessName: _businessNameCtrl.text,
          ),
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
      Haptics.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom App Bar with Progress
          SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Top row with back button and title
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        AnimatedPress(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 24,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Vendor Setup',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2()(AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),
                  
                  // Progress Indicator
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 3 / 7, // Step 3 of 7
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    
                    // Header with modern entrance animation
                    Text(
                      'Tell us about your\nbusiness',
                      style: AppTypography.h1()(AppColors.textPrimary).copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                        
                    const SizedBox(height: 8),
                    
                    Text(
                      'Help us understand your business better with some basic details',
                      style: AppTypography.body()(AppColors.textSecondary).copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                        
                    const SizedBox(height: 32),

                    // Business Info Section
                    _SectionHeader(
                      title: 'Basic Information',
                      index: 0,
                    ),
                    
                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Business Name',
                      child: TextFormField(
                        controller: _businessNameCtrl,
                        style: AppTypography.bodyLg()(AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'e.g., Papaye Fast Food',
                          hintStyle: AppTypography.body()(AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Business name is required';
                          }
                          return null;
                        },
                      ),
                      index: 1,
                    ),

                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Business Description',
                      child: TextFormField(
                        controller: _businessDescCtrl,
                        style: AppTypography.bodyLg()(AppColors.textPrimary),
                        maxLines: 4,
                        maxLength: 200,
                        decoration: InputDecoration(
                          hintText: 'Tell us about your services and what makes you special...',
                          hintStyle: AppTypography.body()(AppColors.textMuted),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Business description is required';
                          }
                          return null;
                        },
                      ),
                      index: 2,
                    ),

                    const SizedBox(height: 24),

                    // Contact Information Section
                    _SectionHeader(
                      title: 'Contact Information',
                      index: 3,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'Business Phone',
                            child: TextFormField(
                              controller: _businessPhoneCtrl,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: InputDecoration(
                                hintText: '20 123 4567',
                                hintStyle: AppTypography.body()(AppColors.textMuted),
                                prefixText: '+233 ',
                                prefixStyle: AppTypography.bodyLg()(AppColors.textPrimary),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                if (value.trim().length < 9) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),
                            index: 4,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'Business Email',
                            child: TextFormField(
                              controller: _businessEmailCtrl,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'contact@business.com',
                                hintStyle: AppTypography.body()(AppColors.textMuted),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            index: 5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Info Card about location
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 24,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Next, we\'ll help you set up your business location for accurate delivery',
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
                        .scale(begin: const Offset(0.95, 0.95), delay: 1000.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              top: false,
              child: SwiftButton(
                label: 'Continue to Step 4',
                onPressed: _onContinue,
                variant: SwiftButtonVariant.primary,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int index;

  const _SectionHeader({
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.h2()(AppColors.textPrimary).copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    )
        .animate()
        .fadeIn(delay: (600 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, delay: (600 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final Widget child;
  final int index;

  const _FormField({
    required this.label,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLg()(AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: (700 + (index * 120)).ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: (700 + (index * 120)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}