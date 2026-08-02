import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'rider_vehicle_information_screen.dart';

class RiderPersonalInformationScreen extends StatefulWidget {
  final String? verifiedFirstName;
  final String? verifiedLastName;
  final String? verifiedIdNumber;
  final bool isVerificationLocked;

  const RiderPersonalInformationScreen({
    super.key,
    this.verifiedFirstName,
    this.verifiedLastName,
    this.verifiedIdNumber,
    this.isVerificationLocked = false,
  });

  @override
  State<RiderPersonalInformationScreen> createState() => _RiderPersonalInformationScreenState();
}

class _RiderPersonalInformationScreenState extends State<RiderPersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ghanaCardController = TextEditingController();
  final _cityController = TextEditingController();
  final _digitalAddressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedRegion;
  String? _selectedRelationship;
  String _dateOfBirth = 'mm/dd/yyyy';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Pre-fill verified data from SmileID if available
    if (widget.verifiedFirstName != null) {
      _firstNameController.text = widget.verifiedFirstName!;
    } else {
      _firstNameController.text = 'John';
    }
    
    if (widget.verifiedLastName != null) {
      _lastNameController.text = widget.verifiedLastName!;
    } else {
      _lastNameController.text = 'Doe';
    }
    
    if (widget.verifiedIdNumber != null) {
      _ghanaCardController.text = widget.verifiedIdNumber!;
    }
    
    _emailController.text = 'johndoe@example.com';
    _cityController.text = 'Accra';
    _digitalAddressController.text = 'GA-183-9012';
    _landmarkController.text = 'Near Osu Mall';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _ghanaCardController.dispose();
    _cityController.dispose();
    _digitalAddressController.dispose();
    _landmarkController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) {
      Haptics.error();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (!mounted) return;
      
      Haptics.success();
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const RiderVehicleInformationScreen(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0),
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save. Please try again.',
              style: AppTypography.body(Colors.white),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
            style: AppTypography.body().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.body().copyWith(fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: AppTypography.body(AppColors.textMuted).copyWith(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.danger, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14.5),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label,
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
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(hint),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
            ),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            )).toList(),
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down),
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
                            'Rider Setup',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2(AppColors.textPrimary).copyWith(
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
                        value: 0.7, // Step 7 of 10 (70%)
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
                      widget.isVerificationLocked 
                        ? 'Additional Information'
                        : 'Personal Information',
                      style: AppTypography.h1(AppColors.textPrimary).copyWith(
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
                      widget.isVerificationLocked
                        ? 'Your identity has been verified. Please complete the remaining details.'
                        : 'Please provide your legal details for verification.',
                      style: AppTypography.body(AppColors.textSecondary).copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 24),
                    
                    // Basic Details
                    Row(
                      children: [
                        Expanded(child: _buildTextField(
                          label: 'First Name',
                          controller: _firstNameController,
                          hintText: 'John',
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(
                          label: 'Last Name',
                          controller: _lastNameController,
                          hintText: 'Doe',
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Ghana Card Number (locked if verified via SmileID)
                    if (widget.verifiedIdNumber != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 6),
                            child: Row(
                              children: [
                                Text(
                                  'Ghana Card Number',
                                  style: AppTypography.body().copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified, size: 12, color: AppColors.success),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: AppTypography.bodySm(AppColors.success).copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.success.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline, size: 16, color: AppColors.success),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _ghanaCardController.text,
                                    style: AppTypography.body(AppColors.textPrimary).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 6),
                                child: Text(
                                  'Date of Birth',
                                  style: AppTypography.body().copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 17),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _dateOfBirth,
                                      style: AppTypography.body(AppColors.textPrimary).copyWith(fontSize: 16),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.calendar_today, size: 20, color: AppColors.textMuted),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdown(
                          label: 'Gender',
                          hint: 'Select',
                          value: _selectedGender,
                          items: ['Male', 'Female', 'Other'],
                          onChanged: (v) => setState(() => _selectedGender = v),
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Email Address',
                      controller: _emailController,
                      hintText: 'johndoe@example.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Required';
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)) return 'Invalid email';
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Phone Number',
                            style: AppTypography.body().copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted),
                              const SizedBox(width: 8),
                              Text(
                                '+233 24 000 0000',
                                style: AppTypography.body(AppColors.textSecondary).copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Residential Address
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Residential Address',
                          style: AppTypography.h3().copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(child: _buildDropdown(
                          label: 'Region',
                          hint: 'Select Region',
                          value: _selectedRegion,
                          items: ['Greater Accra', 'Ashanti', 'Central', 'Eastern'],
                          onChanged: (v) => setState(() => _selectedRegion = v),
                        )),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(
                          label: 'City/Town',
                          controller: _cityController,
                          hintText: 'Accra',
                        )),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Digital Address (GhanaPost GPS)',
                      controller: _digitalAddressController,
                      hintText: 'GA-183-9012',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: 'Street / Landmark',
                      controller: _landmarkController,
                      hintText: 'Near Osu Mall',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Emergency Contact
                    Row(
                      children: [
                        const Icon(Icons.emergency, size: 18, color: AppColors.danger),
                        const SizedBox(width: 8),
                        Text(
                          'Emergency Contact',
                          style: AppTypography.h3().copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            label: 'Contact Name',
                            controller: _emergencyNameController,
                            hintText: 'Full name of contact',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildDropdown(
                                label: 'Relationship',
                                hint: 'Select',
                                value: _selectedRelationship,
                                items: ['Parent', 'Sibling', 'Spouse', 'Friend'],
                                onChanged: (v) => setState(() => _selectedRelationship = v),
                              )),
                              const SizedBox(width: 16),
                              Expanded(child: _buildTextField(
                                label: 'Phone (+233)',
                                controller: _emergencyPhoneController,
                                hintText: '24 123 4567',
                                keyboardType: TextInputType.phone,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
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
                label: 'Continue to Step 8',
                onPressed: _isLoading ? null : _onContinue,
                isLoading: _isLoading,
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
