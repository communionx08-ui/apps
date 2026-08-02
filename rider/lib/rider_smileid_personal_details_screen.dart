import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'rider_smileid_document_capture_screen.dart';

class RiderSmileIdPersonalDetailsScreen extends StatefulWidget {
  const RiderSmileIdPersonalDetailsScreen({super.key});

  @override
  State<RiderSmileIdPersonalDetailsScreen> createState() =>
      _RiderSmileIdPersonalDetailsScreenState();
}

class _RiderSmileIdPersonalDetailsScreenState
    extends State<RiderSmileIdPersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _givenNamesController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedDocType = 'IDENTITY_CARD';
  
  final _docTypeOptions = {
    'IDENTITY_CARD': 'Ghana Card (National ID)',
    'PASSPORT': 'Passport',
    'DRIVERS_LICENSE': 'Driver\'s License',
    'VOTER_ID': 'Voter ID',
  };

  @override
  void dispose() {
    _givenNamesController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) {
      Haptics.error();
      return;
    }

    Haptics.success();
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RiderSmileIdDocumentCaptureScreen(
          givenNames: _givenNamesController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          idType: _selectedDocType,
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
                            'Identity Verification',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2()(AppColors.textPrimary)
                                .copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  
                  // Progress Indicator
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 0.2, // Step 2 of 10 (20%)
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                    
                    // Header
                    Text(
                      'Personal Details',
                      style: AppTypography.h1()(AppColors.textPrimary).copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: 200.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut)
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            delay: 200.ms,
                            duration: 600.ms,
                            curve: Curves.elasticOut),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Enter your details exactly as they appear on your document.',
                      style: AppTypography.body()(AppColors.textSecondary).copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: 400.ms,
                            duration: 400.ms,
                            curve: Curves.easeOut)
                        .slideY(
                            begin: 0.1,
                            delay: 400.ms,
                            duration: 400.ms,
                            curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 24),
                    
                    // Warning Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 24,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Important',
                                  style: AppTypography.body()(AppColors.warning)
                                      .copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter your name EXACTLY as it appears on your ID. SmileID will verify that it matches.',
                                  style:
                                      AppTypography.body()(AppColors.textSecondary)
                                          .copyWith(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: 600.ms,
                            duration: 400.ms,
                            curve: Curves.easeOut)
                        .scale(
                            begin: const Offset(0.95, 0.95),
                            delay: 600.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 32),
                    
                    // Given Names
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Given Names *',
                            style: AppTypography.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _givenNamesController,
                          textCapitalization: TextCapitalization.words,
                          validator: (v) =>
                              v?.trim().isEmpty ?? true ? 'Required' : null,
                          style: AppTypography.body().copyWith(fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'e.g. Kwame Asante',
                            hintStyle: AppTypography.body()(AppColors.textMuted)
                                .copyWith(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.danger, width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 14.5),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Last Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Last Name *',
                            style: AppTypography.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          textCapitalization: TextCapitalization.words,
                          validator: (v) =>
                              v?.trim().isEmpty ?? true ? 'Required' : null,
                          style: AppTypography.body().copyWith(fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'e.g. Mensah',
                            hintStyle: AppTypography.body()(AppColors.textMuted)
                                .copyWith(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.danger, width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 14.5),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Email Address *',
                            style: AppTypography.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) return 'Required';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          style: AppTypography.body().copyWith(fontSize: 16),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'e.g. kwame@example.com',
                            hintStyle: AppTypography.body()(AppColors.textMuted)
                                .copyWith(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.primary, width: 2),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: AppColors.danger, width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 14.5),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Document Type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Document Type *',
                            style: AppTypography.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedDocType,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 12),
                            ),
                            items: _docTypeOptions.entries
                                .map((entry) => DropdownMenuItem(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedDocType = v!),
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Info Note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'SmileID will capture photos of your document and verify your identity in real-time.',
                              style: AppTypography.body()(AppColors.textSecondary)
                                  .copyWith(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Button
      bottomNavigationBar: Container(
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
            label: 'Continue to Document Capture',
            onPressed: _onContinue,
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(
              begin: 0.1,
              delay: 1000.ms,
              duration: 400.ms,
              curve: Curves.easeOutCubic),
    );
  }
}
