import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'rider_under_review_screen.dart';

class RiderBankDetailsScreen extends StatefulWidget {
  const RiderBankDetailsScreen({super.key});

  @override
  State<RiderBankDetailsScreen> createState() => _RiderBankDetailsScreenState();
}

class _RiderBankDetailsScreenState extends State<RiderBankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberCtrl = TextEditingController();
  final _accountNameCtrl = TextEditingController();
  final _bankNameCtrl = TextEditingController();
  
  bool _isMobileMoney = true;
  String _selectedProvider = 'MTN';
  bool _isLoading = false;

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    _accountNameCtrl.dispose();
    _bankNameCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      Haptics.medium();
      setState(() => _isLoading = true);
      
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Haptics.success();
          
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const RiderUnderReviewScreen(),
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
            (route) => false,
          );
        }
      });
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
                  
                  // Progress Indicator (Complete - 4/4)
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 1.0, // Step 4 of 4 - Complete!
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
                        'Payment Setup',
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
                        'How would you like to receive your earnings?',
                        style: AppTypography.body(AppColors.textSecondary).copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                    
                    const SizedBox(height: 32),

                    // Payment Method Toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _PaymentMethodToggle(
                              label: 'Mobile Money',
                              icon: Icons.phone_android,
                              isSelected: _isMobileMoney,
                              onTap: () => setState(() => _isMobileMoney = true),
                            ),
                          ),
                          Expanded(
                            child: _PaymentMethodToggle(
                              label: 'Bank Account',
                              icon: Icons.account_balance,
                              isSelected: !_isMobileMoney,
                              onTap: () => setState(() => _isMobileMoney = false),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 600.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                    if (_isMobileMoney) ...[
                      Text(
                        'Select Provider',
                        style: AppTypography.body().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _ProviderButton(
                            label: 'MTN',
                            isSelected: _selectedProvider == 'MTN',
                            onTap: () => setState(() => _selectedProvider = 'MTN'),
                          ),
                          const SizedBox(width: 8),
                          _ProviderButton(
                            label: 'Telecel',
                            isSelected: _selectedProvider == 'Telecel',
                            onTap: () => setState(() => _selectedProvider = 'Telecel'),
                          ),
                          const SizedBox(width: 8),
                          _ProviderButton(
                            label: 'AirtelTigo',
                            isSelected: _selectedProvider == 'AirtelTigo',
                            onTap: () => setState(() => _selectedProvider = 'AirtelTigo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Phone Number',
                        style: AppTypography.body().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+233',
                              style: AppTypography.body(AppColors.textSecondary).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _accountNumberCtrl,
                              style: AppTypography.body(),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: InputDecoration(
                                hintText: '24 123 4567',
                                hintStyle: AppTypography.body(AppColors.textMuted),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Phone number is required';
                                if (v.trim().length < 9) return 'Enter a valid phone number';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _FormField(
                        label: 'Bank Name',
                        child: DropdownButtonFormField<String>(
                          value: _bankNameCtrl.text.isEmpty ? null : _bankNameCtrl.text,
                          style: AppTypography.body(),
                          decoration: InputDecoration(
                            hintText: 'Select your bank',
                            hintStyle: AppTypography.body(AppColors.textMuted),
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
                          items: ['GCB Bank', 'Ecobank Ghana', 'Standard Chartered Bank', 'Absa Bank Ghana', 'Fidelity Bank Ghana', 'CAL Bank', 'ADB Bank', 'Zenith Bank Ghana', 'GT Bank Ghana', 'First National Bank']
                              .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
                              .toList(),
                          onChanged: (value) {
                            _bankNameCtrl.text = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Bank name is required';
                            return null;
                          },
                        ),
                        index: 0,
                      ),
                      const SizedBox(height: 16),
                      _FormField(
                        label: 'Account Number',
                        child: TextFormField(
                          controller: _accountNumberCtrl,
                          style: AppTypography.body(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(14),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Enter 10-14 digit account number',
                            hintStyle: AppTypography.body(AppColors.textMuted),
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
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Account number is required';
                            if (v.trim().length < 10) return 'Enter a valid account number';
                            return null;
                          },
                        ),
                        index: 1,
                      ),
                    ],

                    const SizedBox(height: 16),
                    
                    _FormField(
                      label: 'Account Name',
                      child: TextFormField(
                        controller: _accountNameCtrl,
                        style: AppTypography.body(),
                        decoration: InputDecoration(
                          hintText: 'Enter account holder name',
                          hintStyle: AppTypography.body(AppColors.textMuted),
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Account name is required';
                          return null;
                        },
                      ),
                      index: _isMobileMoney ? 1 : 2,
                    ),

                    const SizedBox(height: 4),
                    
                    Text(
                      'Must match the name registered with your ${_isMobileMoney ? 'mobile money provider' : 'bank'}',
                      style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                        height: 1.4,
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
            label: 'Complete Setup',
            isLoading: _isLoading,
            onPressed: _onContinue,
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 1500.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, delay: 1500.ms, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _PaymentMethodToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodToggle({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.body().copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProviderButton({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.body().copyWith(
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
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
          style: AppTypography.body().copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    )
        .animate()
        .fadeIn(delay: (800 + (index * 100)).ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: (800 + (index * 100)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}
