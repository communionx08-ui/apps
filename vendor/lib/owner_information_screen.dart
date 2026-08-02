import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'document_upload_screen.dart';
import 'vendor_smileid_personal_details_screen.dart';

class OwnerInformationScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String? verifiedFirstName;
  final String? verifiedLastName;
  final String? verifiedIdNumber;
  
  const OwnerInformationScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    this.verifiedFirstName,
    this.verifiedLastName,
    this.verifiedIdNumber,
  });

  @override
  State<OwnerInformationScreen> createState() => _OwnerInformationScreenState();
}

class _OwnerInformationScreenState extends State<OwnerInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _ownerNameCtrl = TextEditingController();
  final TextEditingController _ownerEmailCtrl = TextEditingController();
  final TextEditingController _ghanaCardCtrl = TextEditingController();
  
  String? _selectedRole;
  bool _identityVerified = false;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill verified data if available
    if (widget.verifiedFirstName != null && widget.verifiedLastName != null) {
      _ownerNameCtrl.text = '${widget.verifiedFirstName} ${widget.verifiedLastName}';
      _identityVerified = true;
    }
    if (widget.verifiedIdNumber != null) {
      _ghanaCardCtrl.text = widget.verifiedIdNumber!;
    }
  }

  @override
  void dispose() {
    _ownerNameCtrl.dispose();
    _ownerEmailCtrl.dispose();
    _ghanaCardCtrl.dispose();
    super.dispose();
  }

  void _onVerifyIdentity() {
    // Navigate to SmileID verification flow
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VendorSmileIdPersonalDetailsScreen(
          vendorType: widget.vendorType,
          businessCategory: widget.businessCategory,
          businessName: widget.businessName,
        ),
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
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_identityVerified) {
        Haptics.error();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Identity verification is required to proceed',
              style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(milliseconds: 2000),
          ),
        );
        return;
      }

      Haptics.medium();
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => DocumentUploadScreen(
            vendorType: widget.vendorType,
            businessCategory: widget.businessCategory,
            businessName: widget.businessName,
            ownerName: _ownerNameCtrl.text,
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
                        value: 5 / 7, // Step 5 of 7
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
                      'Owner Information',
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
                      'Please provide the details of the primary business owner',
                      style: AppTypography.body()(AppColors.textSecondary).copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                        
                    const SizedBox(height: 32),

                    // Owner Details Section
                    _FormField(
                      label: 'Full Name',
                      child: TextFormField(
                        controller: _ownerNameCtrl,
                        style: AppTypography.bodyLg()(_identityVerified 
                            ? AppColors.textPrimary.withOpacity(0.7)
                            : AppColors.textPrimary),
                        enabled: !_identityVerified,
                        decoration: InputDecoration(
                          hintText: 'e.g., Kofi Mensah',
                          hintStyle: AppTypography.body()(AppColors.textMuted),
                          filled: true,
                          fillColor: _identityVerified 
                              ? AppColors.primary.withOpacity(0.05)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: _identityVerified 
                                  ? AppColors.primary.withOpacity(0.3)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: _identityVerified
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.success.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'VERIFIED',
                                          style: AppTypography.bodySm()(AppColors.success).copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      index: 0,
                    ),

                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Role',
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        style: AppTypography.bodyLg()(AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Select role',
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
                        items: [
                          'Owner',
                          'Manager',
                          'Director',
                          'Partner'
                        ].map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        )).toList(),
                        onChanged: (value) {
                          setState(() => _selectedRole = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Role is required';
                          }
                          return null;
                        },
                      ),
                      index: 1,
                    ),

                    const SizedBox(height: 16),

                    // Phone Number (verified)
                    _FormField(
                      label: 'Phone Number',
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '+233 24 123 4567',
                                style: AppTypography.bodyLg()(AppColors.textPrimary.withOpacity(0.7)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.success.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'VERIFIED',
                                    style: AppTypography.bodySm()(AppColors.success).copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      index: 2,
                    ),

                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Email Address',
                      child: TextFormField(
                        controller: _ownerEmailCtrl,
                        style: AppTypography.bodyLg()(AppColors.textPrimary),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'e.g., kofi.mensah@ghana-biz.com',
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
                            return 'Email address is required';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      index: 3,
                    ),

                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Ghana Card Number',
                      child: TextFormField(
                        controller: _ghanaCardCtrl,
                        style: AppTypography.bodyLg()(_identityVerified 
                            ? AppColors.textPrimary.withOpacity(0.7)
                            : AppColors.textPrimary),
                        enabled: !_identityVerified,
                        decoration: InputDecoration(
                          hintText: 'GHA-723145678-9',
                          hintStyle: AppTypography.body()(AppColors.textMuted),
                          filled: true,
                          fillColor: _identityVerified 
                              ? AppColors.primary.withOpacity(0.05)
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: _identityVerified 
                                  ? AppColors.primary.withOpacity(0.3)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          suffixIcon: _identityVerified
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.success.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'VERIFIED',
                                          style: AppTypography.bodySm()(AppColors.success).copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ghana Card number is required';
                          }
                          return null;
                        },
                      ),
                      index: 4,
                    ),

                    const SizedBox(height: 32),

                    // Identity Verification Card
                    _IdentityVerificationCard(
                      verified: _identityVerified,
                      onVerify: _onVerifyIdentity,
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 1000.ms, duration: 600.ms, curve: Curves.easeOutCubic),

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
              child: Column(
                children: [
                  SwiftButton(
                    label: 'Continue to Step 6',
                    onPressed: _identityVerified ? _onContinue : null,
                    variant: _identityVerified 
                        ? SwiftButtonVariant.primary 
                        : SwiftButtonVariant.primary, // Will be disabled by null onPressed
                  ),
                  if (!_identityVerified) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Identity verification is required to proceed to the next step',
                      style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
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
        .fadeIn(delay: (600 + (index * 120)).ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: (600 + (index * 120)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

class _IdentityVerificationCard extends StatelessWidget {
  final bool verified;
  final VoidCallback onVerify;

  const _IdentityVerificationCard({
    required this.verified,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Icon circle
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: verified 
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: verified ? AppColors.success : AppColors.primary,
                width: 2,
              ),
            ),
            child: Icon(
              verified ? Icons.verified_user : Icons.face_retouching_natural,
              size: 32,
              color: verified ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Title & subtitle
          Text(
            verified ? 'Identity Verified' : 'Identity Verification',
            style: AppTypography.h2()(AppColors.textPrimary).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            verified
                ? 'Your identity has been successfully verified'
                : 'Verify your identity with a quick selfie',
            style: AppTypography.body()(AppColors.textSecondary).copyWith(
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          if (!verified) ...[
            // Verify button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: SwiftButton(
                label: 'Verify with Smile ID',
                onPressed: onVerify,
                variant: SwiftButtonVariant.primary,
              ),
            ),
          ] else ...[
            // Verified badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Verified',
                    style: AppTypography.bodyLg()(AppColors.success).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 500.ms, curve: Curves.elasticOut),
          ],
        ],
      ),
    );
  }
}