import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'rider_bank_details_screen.dart';

class RiderDocumentUploadScreen extends StatefulWidget {
  const RiderDocumentUploadScreen({super.key});

  @override
  State<RiderDocumentUploadScreen> createState() => _RiderDocumentUploadScreenState();
}

class _RiderDocumentUploadScreenState extends State<RiderDocumentUploadScreen> {
  final _ghanaCardNumberController = TextEditingController();
  
  // Ghana Card uploads (required)
  String? _ghanaCardFront;
  String? _ghanaCardBack;
  
  // Optional document toggles
  bool _includeDriversLicense = false;
  bool _includeRoadworthy = false;
  bool _includeInsurance = false;
  
  bool get _canContinue {
    return (_ghanaCardNumberController.text.trim().isNotEmpty &&
            _ghanaCardFront != null &&
            _ghanaCardBack != null);
  }

  @override
  void dispose() {
    _ghanaCardNumberController.dispose();
    super.dispose();
  }

  void _simulateUpload(String docType) {
    setState(() {
      switch (docType) {
        case 'ghanaCardFront':
          _ghanaCardFront = 'ghana_card_front.jpg';
          break;
        case 'ghanaCardBack':
          _ghanaCardBack = 'ghana_card_back.jpg';
          break;
      }
    });

    Haptics.light();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Document uploaded successfully',
          style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _onContinue() {
    if (_canContinue) {
      Haptics.medium();
      
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const RiderBankDetailsScreen(),
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
    } else {
      Haptics.error();
    }
  }

  String _getMissingRequirementsText() {
    List<String> missing = [];
    
    if (_ghanaCardNumberController.text.trim().isEmpty) {
      missing.add('Ghana Card Number');
    }
    if (_ghanaCardFront == null) missing.add('Ghana Card (Front)');
    if (_ghanaCardBack == null) missing.add('Ghana Card (Back)');
    
    if (missing.isEmpty) return 'All requirements met';
    
    if (missing.length == 1) {
      return 'Please complete: ${missing.first}';
    } else {
      return 'Please complete: ${missing.join(', ')}';
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
                  
                  // Progress Indicator
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 0.90, // Step 9 of 10 (90%)
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
                  
                  // Header
                  Text(
                    'Upload Documents',
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
                    'Please provide the necessary documents for verification.',
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 32),
                  
                  // Ghana Card Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ghana Card',
                        style: AppTypography.h2().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'Required',
                          style: AppTypography.body(AppColors.primary).copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 200.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 16),
                  
                  // Ghana Card Number Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ghana Card Number',
                        style: AppTypography.body(AppColors.textSecondary).copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _ghanaCardNumberController,
                        style: AppTypography.body().copyWith(fontSize: 16),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'GHA-700000000-0',
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14.5),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.98, 0.98), delay: 300.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 16),
                  
                  // Front Upload
                  _UploadZone(
                    label: 'Front of Ghana Card',
                    sublabel: 'Clear photo, all corners visible',
                    icon: Icons.add_a_photo_outlined,
                    uploaded: _ghanaCardFront != null,
                    onTap: () => _simulateUpload('ghanaCardFront'),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 400.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 16),
                  
                  // Back Upload
                  _UploadZone(
                    label: 'Back of Ghana Card',
                    sublabel: 'Clear photo, all corners visible',
                    icon: Icons.add_a_photo_outlined,
                    uploaded: _ghanaCardBack != null,
                    onTap: () => _simulateUpload('ghanaCardBack'),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 500.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 32),
                  
                  // Other Documents Section
                  Text(
                    'Other Documents',
                    style: AppTypography.h2().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 600.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _OptionalDocRow(
                          icon: Icons.credit_card,
                          label: 'Driver\'s License',
                          sublabel: 'Class A or higher',
                          value: _includeDriversLicense,
                          onChanged: (v) => setState(() => _includeDriversLicense = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: Icons.assignment_turned_in_outlined,
                          label: 'Roadworthy Certificate',
                          sublabel: 'Valid sticker & paper',
                          value: _includeRoadworthy,
                          onChanged: (v) => setState(() => _includeRoadworthy = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: Icons.security,
                          label: 'Insurance Policy',
                          sublabel: 'Valid comprehensive or 3rd party',
                          value: _includeInsurance,
                          onChanged: (v) => setState(() => _includeInsurance = v),
                          showDivider: false,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 700.ms, duration: 600.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 16),
                  
                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(17),
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
                            'Your documents will be reviewed by our team within 24-48 hours. Ensure they are clear and not expired.',
                            style: AppTypography.body(AppColors.textSecondary).copyWith(
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 800.ms, duration: 500.ms, curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 24),
                ],
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwiftButton(
                label: 'Continue to Step 10',
                onPressed: _canContinue ? _onContinue : null,
              ),
              if (!_canContinue) ...[
                const SizedBox(height: 12),
                Text(
                  _getMissingRequirementsText(),
                  style: AppTypography.bodySm(AppColors.textMuted).copyWith(
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
          .fadeIn(delay: 1000.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),
    );
  }
}

class _UploadZone extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;

  const _UploadZone({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.uploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        decoration: BoxDecoration(
          color: uploaded
              ? AppColors.success.withOpacity(0.05)
              : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: uploaded
                ? AppColors.success.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.3),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: uploaded 
                ? AppColors.success.withOpacity(0.3) 
                : AppColors.primary.withOpacity(0.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 42),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    uploaded ? Icons.check_circle : icon,
                    size: 24,
                    color: uploaded ? AppColors.success : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: AppTypography.body().copyWith(
                    color: uploaded ? AppColors.success : AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  sublabel,
                  style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final radius = const Radius.circular(10);
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class _OptionalDocRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _OptionalDocRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.primary.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTypography.body(AppColors.textPrimary).copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      sublabel,
                      style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppColors.primary.withOpacity(0.05),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
