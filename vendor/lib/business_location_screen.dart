import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'owner_information_screen.dart';

class BusinessLocationScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  
  const BusinessLocationScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
  });

  @override
  State<BusinessLocationScreen> createState() => _BusinessLocationScreenState();
}

class _BusinessLocationScreenState extends State<BusinessLocationScreen> {
  final TextEditingController _streetAddressCtrl = TextEditingController();
  final TextEditingController _landmarkCtrl = TextEditingController();
  final TextEditingController _digitalAddressCtrl = TextEditingController();
  
  String? _selectedRegion;
  String? _selectedCity;
  
  bool _isAutoDetecting = false;
  bool _locationDetected = false;

  @override
  void dispose() {
    _streetAddressCtrl.dispose();
    _landmarkCtrl.dispose();
    _digitalAddressCtrl.dispose();
    super.dispose();
  }

  void _onAutoDetectLocation() async {
    setState(() => _isAutoDetecting = true);
    Haptics.light();
    
    // Simulate GPS detection
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isAutoDetecting = false;
        _locationDetected = true;
        _selectedRegion = 'Greater Accra';
        _selectedCity = 'Accra';
        _streetAddressCtrl.text = 'Airport Residential Area';
        _landmarkCtrl.text = 'Near Kotoka International Airport';
        _digitalAddressCtrl.text = 'GA-183-1234';
      });
      
      Haptics.success();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Location detected successfully!',
            style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(milliseconds: 2000),
        ),
      );
    }
  }

  void _onContinue() {
    if (_locationDetected) {
      Haptics.medium();
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => OwnerInformationScreen(
            vendorType: widget.vendorType,
            businessCategory: widget.businessCategory,
            businessName: widget.businessName,
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
    }
  }

  List<String> _getCitiesForRegion(String? region) {
    switch (region) {
      case 'Greater Accra':
        return ['Accra', 'Tema', 'Kasoa', 'Madina', 'Adenta'];
      case 'Ashanti':
        return ['Kumasi', 'Obuasi', 'Ejisu', 'Mampong'];
      case 'Central':
        return ['Cape Coast', 'Elmina', 'Winneba'];
      default:
        return [];
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
                        value: 4 / 7, // Step 4 of 7
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  // Header with modern entrance animation
                  Text(
                    'Where is your business\nlocated?',
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
                    'This helps customers find you and ensures accurate delivery',
                    style: AppTypography.body()(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 32),

                  // Auto-detect location card
                  if (!_locationDetected) ...[
                    Container(
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
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: _isAutoDetecting
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  )
                                : Icon(
                                    Icons.my_location,
                                    size: 28,
                                    color: AppColors.primary,
                                  ),
                          ),
                          const SizedBox(height: 16),

                          // Title & subtitle
                          Text(
                            _isAutoDetecting ? 'Detecting Location...' : 'Auto-Detect Location',
                            style: AppTypography.h2()(AppColors.textPrimary).copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isAutoDetecting
                                ? 'Please wait while we detect your business location'
                                : 'For best results, stand at your business location and tap the button below',
                            style: AppTypography.body()(AppColors.textSecondary).copyWith(
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Auto-detect button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: SwiftButton(
                              label: _isAutoDetecting ? 'Detecting...' : 'Use My Current Location',
                              onPressed: _isAutoDetecting ? null : _onAutoDetectLocation,
                              variant: SwiftButtonVariant.primary,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Manual entry option
                          GestureDetector(
                            onTap: () {
                              setState(() => _locationDetected = true);
                              Haptics.light();
                            },
                            child: Text(
                              'Enter address manually instead',
                              style: AppTypography.bodyLg()(AppColors.primary).copyWith(
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 600.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                  ] else ...[
                    // Location detected - show form
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 24,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Location detected successfully! You can review and edit the details below.',
                              style: AppTypography.bodyLg()(AppColors.success).copyWith(
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .scale(begin: const Offset(0.95, 0.95), duration: 500.ms, curve: Curves.easeOutCubic),

                    const SizedBox(height: 24),

                    // Address form
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'Region',
                            child: DropdownButtonFormField<String>(
                              value: _selectedRegion,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Select region',
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
                                'Greater Accra',
                                'Ashanti',
                                'Central',
                                'Eastern',
                                'Northern',
                                'Upper East',
                                'Upper West',
                                'Volta',
                                'Western',
                                'Brong Ahafo'
                              ].map((region) => DropdownMenuItem(
                                value: region,
                                child: Text(region),
                              )).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRegion = value;
                                  _selectedCity = null; // Reset city when region changes
                                });
                              },
                            ),
                            index: 0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'City / Town',
                            child: DropdownButtonFormField<String>(
                              value: _selectedCity,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Select city',
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
                              items: _getCitiesForRegion(_selectedRegion)
                                  .map((city) => DropdownMenuItem(
                                        value: city,
                                        child: Text(city),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _selectedCity = value);
                              },
                            ),
                            index: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _FormField(
                      label: 'Street Address',
                      child: TextFormField(
                        controller: _streetAddressCtrl,
                        style: AppTypography.bodyLg()(AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'House number or street name',
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
                      ),
                      index: 2,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'Landmark',
                            child: TextFormField(
                              controller: _landmarkCtrl,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Near major building',
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
                            ),
                            index: 3,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'Digital Address (GPS)',
                            child: TextFormField(
                              controller: _digitalAddressCtrl,
                              style: AppTypography.bodyLg()(AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'GA-183-1234',
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
                            ),
                            index: 4,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Important note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This location will be used for all deliveries to your business. Make sure it\'s accurate.',
                              style: AppTypography.body()(AppColors.warning).copyWith(
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
                label: _locationDetected ? 'Continue to Step 5' : 'Skip for Now',
                onPressed: _locationDetected ? _onContinue : () {
                  // Skip to next step without location
                  setState(() => _locationDetected = true);
                  _onContinue();
                },
                variant: SwiftButtonVariant.primary,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),
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
        .fadeIn(delay: (800 + (index * 120)).ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: (800 + (index * 120)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}