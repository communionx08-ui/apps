import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'terms_screen.dart';
import 'location_permission_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = 'John';
    _lastNameController.text = 'Doe';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) {
      Haptics.error();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      
      if (!mounted) return;
      
      Haptics.success();
      
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => TermsScreen(
            onAccept: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LocationPermissionScreen()),
              );
            },
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save profile. Please try again.',
              style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
            ),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Haptics.error();
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    Widget? suffix,
  }) {
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          validator: validator,
          style: AppTypography.bodyLg()(AppColors.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
            hintText: hintText,
            hintStyle: AppTypography.body()(AppColors.textMuted),
            suffixIcon: suffix,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.danger, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Custom App Bar with Progress (Vendor Style)
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
                            'Rider Setup',
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
                        value: 0.5, // Step progress
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, curve: Curves.easeOut),
            
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      
                      Text(
                        'Complete your profile',
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
                        'Set up your rider profile to start receiving delivery requests',
                        style: AppTypography.body()(AppColors.textSecondary).copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 40),

                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.1),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: AnimatedPress(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Photo upload coming soon!',
                                        style: AppTypography.body()(Colors.white),
                                      ),
                                      backgroundColor: AppColors.textPrimary,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 400.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            delay: 500.ms,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                          ),
                      
                      const SizedBox(height: 40),

                      _buildTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        hintText: 'Enter your first name',
                        readOnly: !_isEditingName,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                        suffix: AnimatedPress(
                          onTap: () {
                            setState(() => _isEditingName = !_isEditingName);
                            Haptics.light();
                          },
                          child: Icon(
                            _isEditingName ? Icons.check : Icons.edit,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.98, 0.98), delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 20),

                      _buildTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        hintText: 'Enter your last name',
                        readOnly: !_isEditingName,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.98, 0.98), delay: 700.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 20),

                      _buildTextField(
                        label: 'Email Address (Optional)',
                        controller: _emailController,
                        hintText: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }
                          }
                          return null;
                        },
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.98, 0.98), delay: 800.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Add your email to receive delivery notifications',
                        style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 300.ms),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ),
          ),
        ],
      ),

      // Bottom Button (Vendor Style)
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
            label: 'Continue',
            isLoading: _isLoading,
            onPressed: _onContinue,
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}
