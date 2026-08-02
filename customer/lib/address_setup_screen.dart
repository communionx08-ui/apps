import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';

class AddressSetupScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const AddressSetupScreen({
    super.key,
    required this.onNext,
    this.onBack,
  });

  @override
  State<AddressSetupScreen> createState() => _AddressSetupScreenState();
}

class _AddressSetupScreenState extends State<AddressSetupScreen>
    with TickerProviderStateMixin {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  
  String _selectedType = 'Home';
  bool _useCurrentLocation = true;

  @override
  void initState() {
    super.initState();

    // Mock current location if user chooses to use it
    if (_useCurrentLocation) {
      _addressController.text = '123 Main Street, Accra, Ghana';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _landmarkController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _toggleCurrentLocation() {
    setState(() {
      _useCurrentLocation = !_useCurrentLocation;
      if (_useCurrentLocation) {
        // Simulate detecting current location
        _addressController.text = '123 Main Street, Accra, Ghana';
      } else {
        _addressController.clear();
      }
    });
  }

  void _onContinue() {
    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter your delivery address');
      return;
    }
    
    widget.onNext();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFE11D48),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
          SafeArea(
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  AnimatedPress(
                    onTap: widget.onBack ?? () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: Color(0xFF1B1B1B),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Set Delivery Address',
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
          ),

          // Progress Indicator
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 4 / 11, // Step 4 of 11
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Header with modern entrance animation
                  Text(
                    'Set Your Default\nDelivery Address',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                      
                  const SizedBox(height: 8),
                  
                  Text(
                    'We\'ll use this address for all your deliveries',
                    style: AppTypography.bodyLg(const Color(0xFF8A8A8E)).copyWith(
                      height: 1.6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 40),

                  // Current Location Toggle with staggered animation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _useCurrentLocation 
                            ? AppColors.primary.withOpacity(0.3)
                            : const Color(0xFFE9EAEB),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Use Current Location',
                                style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Automatically detect your location',
                                style: AppTypography.body(const Color(0xFF8A8A8E)),
                              ),
                            ],
                          ),
                        ),
                        AnimatedPress(
                          onTap: _toggleCurrentLocation,
                          child: Container(
                            width: 52,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: _useCurrentLocation
                                  ? AppColors.primary
                                  : const Color(0xFFE2E8F0),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _useCurrentLocation
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.98, 0.98), delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 32),

                  // Address Type Selection
                  Text(
                    'Address Type',
                    style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut),
                      
                  const SizedBox(height: 16),
                  
                  Row(
                    children: ['Home', 'Office', 'Other'].asMap().entries.map((entry) {
                      final index = entry.key;
                      final type = entry.value;
                      final bool isSelected = _selectedType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: AnimatedPress(
                          onTap: () => setState(() => _selectedType = type),
                          child: AnimatedContainer(
                            duration: Motion.fast,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Text(
                              type,
                              style: AppTypography.body(
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (900 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.9, 0.9), delay: (900 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOutCubic);
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields with staggered animations
                  _buildInputField(
                    'Full Address',
                    'Enter your complete address',
                    _addressController,
                    maxLines: 2,
                    readOnly: _useCurrentLocation,
                    animationDelay: 1200,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    'Landmark (Optional)',
                    'Nearby landmark or notable place',
                    _landmarkController,
                    animationDelay: 1350,
                  ),
                  const SizedBox(height: 20),

                  _buildInputField(
                    'Delivery Instructions (Optional)',
                    'e.g., Ring the bell, Call when you arrive',
                    _instructionsController,
                    maxLines: 3,
                    animationDelay: 1500,
                  ),
                  const SizedBox(height: 40),

                  // Continue Button with spring animation
                  SwiftButton(
                    label: 'Continue',
                    onPressed: _onContinue,
                    variant: SwiftButtonVariant.primary,
                  )
                      .animate()
                      .fadeIn(delay: 1650.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.9, 0.9), delay: 1650.ms, duration: 700.ms, curve: Curves.elasticOut),
                      
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool readOnly = false,
    int animationDelay = 0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body(AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: readOnly,
            style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyLg(const Color(0xFFA2A0A8)),
              filled: true,
              fillColor: readOnly 
                  ? const Color(0xFFF9F9FA) 
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: animationDelay.ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: animationDelay.ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}