import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'under_review_screen.dart';

class BankDetailsScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String ownerName;
  
  const BankDetailsScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    required this.ownerName,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController _accountNumberCtrl = TextEditingController();
  final TextEditingController _accountNameCtrl = TextEditingController();
  final TextEditingController _bankNameCtrl = TextEditingController();
  
  // Payment method selection
  bool _isMobileMoney = true;
  
  // Mobile money provider
  String _selectedProvider = 'MTN';

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
      
      // Navigate to Under Review screen and clear stack
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => UnderReviewScreen(
            vendorType: widget.vendorType,
            businessCategory: widget.businessCategory,
            businessName: widget.businessName,
            ownerName: widget.ownerName,
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
        (route) => false, // Clear all routes
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
                            style: AppTypography.h2(AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),
                  
                  // Progress Indicator (Complete - 7/7)
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 1.0, // Step 7 of 7 - Complete!
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
                      'How would you like to receive payments?',
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

                    const SizedBox(height: 32),

                    // Dynamic form fields based on payment method
                    if (_isMobileMoney) ...[
                      // Mobile Money Form
                      Text(
                        'Select Provider',
                        style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                          .slideY(begin: 0.1, delay: 800.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
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
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 400.ms, curve: Curves.easeOut)
                          .scale(begin: const Offset(0.95, 0.95), delay: 900.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                      
                      const SizedBox(height: 24),
                      
                      // Phone number input
                      Text(
                        'Phone Number',
                        style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
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
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+233',
                              style: AppTypography.bodyLg(AppColors.textSecondary).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _accountNumberCtrl,
                              style: AppTypography.bodyLg(AppColors.textPrimary),
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
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(16),
                                  ),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(16),
                                  ),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(16),
                                  ),
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
                          ),
                        ],
                      ),
                    ] else ...[
                      // Bank Account Form
                      _FormField(
                        label: 'Bank Name',
                        child: DropdownButtonFormField<String>(
                          value: _bankNameCtrl.text.isEmpty ? null : _bankNameCtrl.text,
                          style: AppTypography.bodyLg(AppColors.textPrimary),
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
                          items: [
                            'GCB Bank',
                            'Ecobank Ghana',
                            'Standard Chartered Bank',
                            'Absa Bank Ghana',
                            'Fidelity Bank Ghana',
                            'CAL Bank',
                            'ADB Bank',
                            'Zenith Bank Ghana',
                            'GT Bank Ghana',
                            'First National Bank',
                          ].map((bank) => DropdownMenuItem(
                            value: bank,
                            child: Text(bank),
                          )).toList(),
                          onChanged: (value) {
                            _bankNameCtrl.text = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Bank name is required';
                            }
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
                          style: AppTypography.bodyLg(AppColors.textPrimary),
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Account number is required';
                            }
                            if (value.trim().length < 10) {
                              return 'Enter a valid account number';
                            }
                            return null;
                          },
                        ),
                        index: 1,
                      ),
                    ],

                    const SizedBox(height: 16),

                    // Account name (common for both)
                    _FormField(
                      label: 'Account Name',
                      child: TextFormField(
                        controller: _accountNameCtrl,
                        style: AppTypography.bodyLg(AppColors.textPrimary),
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Account name is required';
                          }
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
                    )
                        .animate()
                        .fadeIn(delay: 1200.ms, duration: 300.ms),

                    const SizedBox(height: 32),

                    // Settlement Information Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SETTLEMENT INFORMATION',
                                style: AppTypography.bodyLg(AppColors.primary).copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _SettlementRow(
                            label: 'Food orders',
                            value: 'Every 7 days',
                          ),
                          const SizedBox(height: 12),
                          _SettlementRow(
                            label: 'High-value goods',
                            value: 'Every 30 days',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(
                              height: 1,
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Minimum payout',
                                style: AppTypography.bodyLg(AppColors.textSecondary),
                              ),
                              Text(
                                'GHS 50.00',
                                style: AppTypography.bodyLg(AppColors.primary).copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1300.ms, duration: 500.ms, curve: Curves.easeOut)
                        .scale(begin: const Offset(0.95, 0.95), delay: 1300.ms, duration: 600.ms, curve: Curves.easeOutCubic),

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
                    label: 'Complete Setup',
                    onPressed: _onContinue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'By clicking complete, you agree to our Vendor Payment Terms',
                    style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1500.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1500.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
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
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodyLg().copyWith(
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
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.bodyLg().copyWith(
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
          style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
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

class _SettlementRow extends StatelessWidget {
  final String label;
  final String value;

  const _SettlementRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLg(AppColors.textSecondary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            value,
            style: AppTypography.bodyLg(AppColors.textPrimary).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}