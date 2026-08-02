import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'bank_details_screen.dart';

class DocumentUploadScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String ownerName;
  
  const DocumentUploadScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    required this.ownerName,
  });

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Required documents state
  String? _businessRegDoc;
  String? _ghanaCardFront;
  String? _ghanaCardBack;
  String? _registrationNumber;

  // Optional document toggles
  bool _includeTIN = false;
  bool _includeBusinessPhotos = true; // pre-toggled on
  bool _includeVAT = false;

  bool get _canContinue {
    // Business certificate is mandatory for Business Vendors, optional for Individual Vendors
    bool businessCertRequired = widget.vendorType == 'business';
    
    return (businessCertRequired ? _businessRegDoc != null : true) && 
           _ghanaCardFront != null && 
           _ghanaCardBack != null &&
           (_registrationNumber != null && _registrationNumber!.trim().isNotEmpty);
  }

  void _simulateUpload(String docType) {
    setState(() {
      switch (docType) {
        case 'businessReg':
          _businessRegDoc = 'business_registration.pdf';
          break;
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
          style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
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
          pageBuilder: (context, animation, secondaryAnimation) => BankDetailsScreen(
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
      );
    } else {
      Haptics.error();
    }
  }

  String _getMissingRequirementsText() {
    List<String> missing = [];
    
    // Business certificate is mandatory for Business Vendors, optional for Individual Vendors
    if (widget.vendorType == 'business' && _businessRegDoc == null) {
      missing.add('Business Registration Certificate');
    }
    if (_ghanaCardFront == null) missing.add('Ghana Card (Front)');
    if (_ghanaCardBack == null) missing.add('Ghana Card (Back)');
    if (_registrationNumber == null || _registrationNumber!.trim().isEmpty) {
      missing.add('Registration Number');
    }
    
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
                        value: 6 / 7, // Step 6 of 7
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
                    'Business Documents',
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
                    'Please provide the necessary legal documents for verification',
                    style: AppTypography.body()(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms, curve: Curves.easeOutCubic),
                      
                  const SizedBox(height: 32),

                  // Vendor-specific info card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: widget.vendorType == 'business' 
                          ? AppColors.primary.withOpacity(0.05)
                          : AppColors.success.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.vendorType == 'business' 
                            ? AppColors.primary.withOpacity(0.2)
                            : AppColors.success.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          widget.vendorType == 'business' ? Icons.business : Icons.person,
                          size: 24,
                          color: widget.vendorType == 'business' ? AppColors.primary : AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.vendorType == 'business'
                                ? 'As a Business Vendor, you\'ll need to provide your business registration certificate and number.'
                                : 'As an Individual Vendor, business registration is optional. You can upgrade to Business Vendor later.',
                            style: AppTypography.body()(
                              widget.vendorType == 'business' ? AppColors.primary : AppColors.success
                            ).copyWith(
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 500.ms, duration: 500.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 32),

                  // Required Documents Section
                  Row(
                    children: [
                      Icon(
                        Icons.description,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Required Documents',
                        style: AppTypography.h2()(AppColors.textPrimary).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 600.ms, duration: 400.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 24),

                  // Business Registration Certificate (conditional based on vendor type)
                  _DocumentSection(
                    title: widget.vendorType == 'business' 
                        ? 'Business Registration Certificate (Required)' 
                        : 'Business Registration Certificate (Optional)',
                    uploadZone: _UploadZone(
                      label: 'Upload or Take Photo',
                      sublabel: 'PDF, JPG or PNG up to 5MB',
                      icon: Icons.file_upload_outlined,
                      uploaded: _businessRegDoc != null,
                      filename: _businessRegDoc,
                      onTap: () => _simulateUpload('businessReg'),
                    ),
                    additionalField: TextFormField(
                      style: AppTypography.bodyLg()(AppColors.textPrimary),
                      initialValue: _registrationNumber,
                      decoration: InputDecoration(
                        labelText: 'Registration Number',
                        hintText: 'e.g. BN-123,456,789',
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
                      onChanged: (value) {
                        setState(() => _registrationNumber = value.trim());
                      },
                    ),
                    index: 0,
                  ),

                  const SizedBox(height: 24),

                  // Ghana Card
                  _DocumentSection(
                    title: "Owner's Ghana Card",
                    uploadZone: Row(
                      children: [
                        Expanded(
                          child: _UploadZone(
                            label: 'Upload front',
                            sublabel: null,
                            icon: Icons.credit_card,
                            uploaded: _ghanaCardFront != null,
                            onTap: () => _simulateUpload('ghanaCardFront'),
                            height: 120,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _UploadZone(
                            label: 'Upload back',
                            sublabel: null,
                            icon: Icons.credit_card,
                            uploaded: _ghanaCardBack != null,
                            onTap: () => _simulateUpload('ghanaCardBack'),
                            height: 120,
                          ),
                        ),
                      ],
                    ),
                    additionalField: null,
                    index: 1,
                  ),

                  const SizedBox(height: 32),

                  // Additional Documents Section
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Additional Documents (Optional)',
                        style: AppTypography.h2()(AppColors.textPrimary).copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 1000.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(begin: 0.1, delay: 1000.ms, duration: 400.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
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
                        _OptionalDocRow(
                          icon: Icons.receipt_long,
                          label: 'TIN Certificate',
                          value: _includeTIN,
                          onChanged: (v) => setState(() => _includeTIN = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: Icons.photo_camera,
                          label: 'Business Photos',
                          value: _includeBusinessPhotos,
                          onChanged: (v) => setState(() => _includeBusinessPhotos = v),
                          showDivider: true,
                        ),
                        _OptionalDocRow(
                          icon: Icons.account_balance,
                          label: 'VAT Registration',
                          value: _includeVAT,
                          onChanged: (v) => setState(() => _includeVAT = v),
                          showDivider: false,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1100.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(begin: const Offset(0.95, 0.95), delay: 1100.ms, duration: 600.ms, curve: Curves.easeOutCubic),

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
              child: Column(
                children: [
                  SwiftButton(
                    label: 'Continue to Step 7',
                    onPressed: _canContinue ? _onContinue : null,
                    variant: _canContinue 
                        ? SwiftButtonVariant.primary 
                        : SwiftButtonVariant.primary, // Will be disabled by null onPressed
                  ),
                  if (!_canContinue) ...[
                    const SizedBox(height: 12),
                    Text(
                      _getMissingRequirementsText(),
                      style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Text(
                      'By continuing, you agree to our Vendor Terms & Conditions',
                      style: AppTypography.bodySm()(AppColors.textMuted).copyWith(
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
              .fadeIn(delay: 1300.ms, duration: 500.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, delay: 1300.ms, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  final String title;
  final Widget uploadZone;
  final Widget? additionalField;
  final int index;

  const _DocumentSection({
    required this.title,
    required this.uploadZone,
    required this.additionalField,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.bodyLg()(AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        uploadZone,
        if (additionalField != null) ...[
          const SizedBox(height: 12),
          additionalField!,
        ],
      ],
    )
        .animate()
        .fadeIn(delay: (700 + (index * 150)).ms, duration: 400.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.98, 0.98), delay: (700 + (index * 150)).ms, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}

class _UploadZone extends StatelessWidget {
  final String label;
  final String? sublabel;
  final IconData icon;
  final bool uploaded;
  final String? filename;
  final VoidCallback onTap;
  final double height;

  const _UploadZone({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.uploaded,
    required this.onTap,
    this.filename,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: uploaded
              ? AppColors.success.withOpacity(0.05)
              : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: uploaded
                ? AppColors.success.withOpacity(0.4)
                : AppColors.primary.withOpacity(0.2),
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: uploaded 
                ? AppColors.success.withOpacity(0.4) 
                : AppColors.primary.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  uploaded ? Icons.check_circle : icon,
                  size: 24,
                  color: uploaded ? AppColors.success : AppColors.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  uploaded ? (filename ?? 'Uploaded') : label,
                  style: AppTypography.bodyLg().copyWith(
                    color: uploaded ? AppColors.success : AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (sublabel != null && !uploaded) ...[
                  const SizedBox(height: 2),
                  Text(
                    sublabel!,
                    style: AppTypography.bodySm()(AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ],
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
    final radius = const Radius.circular(14);
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
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _OptionalDocRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLg()(AppColors.textPrimary).copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
            color: AppColors.primary.withOpacity(0.1),
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}