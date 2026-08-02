import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'rider_document_upload_screen.dart';

class RiderVehicleInformationScreen extends StatefulWidget {
  const RiderVehicleInformationScreen({super.key});

  @override
  State<RiderVehicleInformationScreen> createState() => _RiderVehicleInformationScreenState();
}

class _RiderVehicleInformationScreenState extends State<RiderVehicleInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _licensePlateController = TextEditingController();
  
  String? _selectedVehicleType;
  bool _isLoading = false;

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!_formKey.currentState!.validate()) {
      Haptics.error();
      return;
    }

    if (_selectedVehicleType == null) {
      Haptics.error();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a vehicle type',
            style: AppTypography.body()(Colors.white),
          ),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
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
          pageBuilder: (context, animation, secondaryAnimation) => const RiderDocumentUploadScreen(),
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save. Please try again.',
              style: AppTypography.body()(Colors.white),
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
            hintStyle: AppTypography.body()(AppColors.textMuted).copyWith(fontSize: 16),
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
                        value: 0.80, // Step 8 of 10 (80%)
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
                        'Vehicle Information',
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
                        'Tell us about the vehicle you\'ll be using for deliveries.',
                        style: AppTypography.body()(AppColors.textSecondary).copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 32),
                    
                    // Vehicle Type Selection
                    Text(
                      'What will you ride?',
                      style: AppTypography.body().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.1, delay: 600.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _VehicleTypeCard(
                            icon: Icons.pedal_bike,
                            label: 'Bicycle',
                            isSelected: _selectedVehicleType == 'bicycle',
                            onTap: () {
                              setState(() => _selectedVehicleType = 'bicycle');
                              Haptics.light();
                            },
                          )
                              .animate()
                              .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut)
                              .scale(begin: const Offset(0.95, 0.95), delay: 700.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _VehicleTypeCard(
                            icon: Icons.two_wheeler,
                            label: 'Motorbike',
                            isSelected: _selectedVehicleType == 'motorbike',
                            onTap: () {
                              setState(() => _selectedVehicleType = 'motorbike');
                              Haptics.light();
                            },
                          )
                              .animate()
                              .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                              .scale(begin: const Offset(0.95, 0.95), delay: 800.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _VehicleTypeCard(
                            icon: Icons.directions_car,
                            label: 'Car',
                            isSelected: _selectedVehicleType == 'car',
                            onTap: () {
                              setState(() => _selectedVehicleType = 'car');
                              Haptics.light();
                            },
                          )
                              .animate()
                              .fadeIn(delay: 900.ms, duration: 400.ms, curve: Curves.easeOut)
                              .scale(begin: const Offset(0.95, 0.95), delay: 900.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Conditional vehicle details form
                    if (_selectedVehicleType != null && _selectedVehicleType != 'bicycle') ...[
                      Text(
                        'Vehicle Details',
                        style: AppTypography.body().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        label: 'Make',
                        controller: _makeController,
                        hintText: 'e.g. Honda, Toyota',
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        label: 'Model',
                        controller: _modelController,
                        hintText: 'e.g. CB125, Corolla',
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Year',
                              controller: _yearController,
                              hintText: '2020',
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v?.isEmpty ?? true) return 'Required';
                                final year = int.tryParse(v!);
                                if (year == null || year < 1980 || year > DateTime.now().year + 1) {
                                  return 'Invalid year';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              label: 'Color',
                              controller: _colorController,
                              hintText: 'Black',
                              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        label: 'License Plate',
                        controller: _licensePlateController,
                        hintText: 'GR-1234-20',
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ] else if (_selectedVehicleType == 'bicycle') ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
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
                                'Great choice! Bicycles don\'t require registration details. You\'re ready for the next step.',
                                style: AppTypography.body()(AppColors.primary).copyWith(
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
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
            label: 'Continue to Step 9',
            onPressed: _isLoading ? null : _onContinue,
            isLoading: _isLoading,
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 1200.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, delay: 1200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _VehicleTypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleTypeCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
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
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTypography.body().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
