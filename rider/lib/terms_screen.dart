import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback? onBack;

  const TermsScreen({
    super.key,
    required this.onAccept,
    this.onBack,
  });

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;

  bool get _canContinue => _termsAccepted && _privacyAccepted;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onAccept() {
    if (_canContinue) {
      widget.onAccept();
    }
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
                      'Terms & Privacy',
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
          ),

          // Progress Indicator
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: 3 / 11, // Step 3 of 11
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.only(top: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF64748B),
              labelStyle: AppTypography.body()(AppColors.primary).copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.body()(const Color(0xFF64748B)).copyWith(
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Terms of Service'),
                Tab(text: 'Privacy Policy'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTermsTab(),
                _buildPrivacyTab(),
              ],
            ),
          ),

          // Bottom Accept Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Column(
              children: [
                // Terms Checkbox
                _buildCheckbox(
                  'I agree to the Terms of Service',
                  _termsAccepted,
                  (value) => setState(() => _termsAccepted = value),
                ),
                const SizedBox(height: 12),
                
                // Privacy Checkbox
                _buildCheckbox(
                  'I agree to the Privacy Policy',
                  _privacyAccepted,
                  (value) => setState(() => _privacyAccepted = value),
                ),
                const SizedBox(height: 24),

                // Continue Button
                SwiftButton(
                  label: 'Continue',
                  onPressed: _canContinue ? _onAccept : null,
                  variant: SwiftButtonVariant.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, ValueChanged<bool> onChanged) {
    return AnimatedPress(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                color: value ? AppColors.primary : const Color(0xFFD1D5DB),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              color: value ? AppColors.primary : Colors.transparent,
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTypography.body()(AppColors.textPrimary).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsTab() {
    const sections = [
      _Section(
        title: '1. Acceptance of Terms',
        body:
            'By downloading, accessing, or using the Swift application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our services. These terms constitute a legally binding agreement between you and Swift Technologies.',
      ),
      _Section(
        title: '2. Use of Service',
        body:
            'Swift grants you a limited, non-exclusive, non-transferable licence to use our platform for personal, non-commercial purposes. You must be at least 18 years old to create an account. You are responsible for maintaining the confidentiality of your account credentials.',
      ),
      _Section(
        title: '3. Orders and Delivery',
        body:
            'When you place an order through Swift, you enter into a direct agreement with the vendor or service provider. Swift acts as an intermediary platform connecting customers, vendors, and riders. Delivery time estimates may vary due to traffic, weather, or vendor preparation times.',
      ),
      _Section(
        title: '4. Payment',
        body:
            'All payments made through Swift are processed securely via our certified payment partners. We accept MTN Mobile Money, Vodafone Cash, AirtelTigo Money, and cash on delivery where available. Prices displayed include applicable taxes and fees.',
      ),
      _Section(
        title: '5. Cancellation Policy',
        body:
            'Orders may be cancelled free of charge within 2 minutes of placement. After this window, cancellations are subject to a fee depending on order preparation status. Once an order has been picked up by a rider, cancellation may not be possible.',
      ),
      _Section(
        title: '6. Limitation of Liability',
        body:
            'To the maximum extent permitted by applicable law, Swift shall not be liable for any indirect, incidental, special, or consequential damages arising from your use of the platform. Our total liability for any claim shall not exceed the amount you paid for the specific transaction.',
      ),
      _Section(
        title: '7. Changes to Terms',
        body:
            'Swift reserves the right to modify these Terms of Service at any time. We will notify you of significant changes via the app or email at least 14 days before they take effect. Your continued use constitutes acceptance of updated terms.',
      ),
    ];

    return _buildScrollView(sections);
  }

  Widget _buildPrivacyTab() {
    const sections = [
      _Section(
        title: '1. Information We Collect',
        body:
            'We collect information you provide directly, such as your name, phone number, email address, delivery addresses, and payment details. We also collect data automatically when you use our services, including order history, app usage patterns, and device identifiers.',
      ),
      _Section(
        title: '2. How We Use Your Information',
        body:
            'Your information is used to process and fulfil orders, personalise your in-app experience, send order status updates and relevant promotional communications, improve our platform, and detect and prevent fraud.',
      ),
      _Section(
        title: '3. Information Sharing',
        body:
            'We share your information with vendors and riders only to the extent necessary to fulfil your orders, and with payment processors to complete transactions. We do not sell your personal data.',
      ),
      _Section(
        title: '4. Data Security',
        body:
            'We implement industry-standard security measures including TLS encryption in transit, encrypted storage at rest, and regular security audits. Access to personal data is restricted to authorised personnel on a need-to-know basis.',
      ),
      _Section(
        title: '5. Your Rights',
        body:
            'You have the right to access, correct, or delete your personal data at any time from the Profile section of the app. You may also request a portable copy of your data or object to certain types of processing.',
      ),
      _Section(
        title: '6. Contact Us',
        body:
            'If you have questions about this Privacy Policy, please contact our Data Protection team at privacy@swift.app. We take all privacy concerns seriously and will respond promptly.',
      ),
    ];

    return _buildScrollView(sections);
  }

  Widget _buildScrollView(List<_Section> sections) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sections.asMap().entries.map((entry) {
            final idx = entry.key;
            final section = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: AppTypography.bodyLg()(AppColors.textPrimary).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  section.body,
                  style: AppTypography.body()(const Color(0xFF64748B)).copyWith(
                    height: 1.6,
                  ),
                ),
                if (idx < sections.length - 1) ...[
                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFE2E8F0), height: 1),
                  const SizedBox(height: 20),
                ],
              ],
            );
          }),
          const SizedBox(height: 36),
          Center(
            child: Text(
              'Last updated: January 2025',
              style: AppTypography.bodySm()(const Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;
}