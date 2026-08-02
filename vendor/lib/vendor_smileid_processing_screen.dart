import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swift_core/swift_core.dart';
import 'package:lottie/lottie.dart';
import 'owner_information_screen.dart';

class VendorSmileIdProcessingScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String givenNames;
  final String lastName;
  final String email;
  final String idType;
  final Uint8List documentFront;
  final Uint8List? documentBack;
  final Uint8List selfie;
  final List<Uint8List> livenessFrames;

  const VendorSmileIdProcessingScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    required this.givenNames,
    required this.lastName,
    required this.email,
    required this.idType,
    required this.documentFront,
    this.documentBack,
    required this.selfie,
    required this.livenessFrames,
  });

  @override
  State<VendorSmileIdProcessingScreen> createState() =>
      _VendorSmileIdProcessingScreenState();
}

class _VendorSmileIdProcessingScreenState
    extends State<VendorSmileIdProcessingScreen> {
  final MockSmileIdService _service = MockSmileIdService();
  
  VerificationStatus? _currentStatus;
  String? _jobId;
  StreamSubscription? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _submitVerification();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _submitVerification() async {
    try {
      // Submit to mock service
      _jobId = await _service.submitVerification(
        selfie: widget.selfie,
        livenessFrames: widget.livenessFrames,
        documentFront: widget.documentFront,
        documentBack: widget.documentBack,
        givenNames: widget.givenNames,
        lastName: widget.lastName,
        email: widget.email,
        idType: widget.idType,
      );

      // Watch for status updates
      _statusSubscription =
          _service.watchVerificationStatus(_jobId!).listen((status) {
        if (mounted) {
          setState(() => _currentStatus = status);
          
          // Auto-navigate on success after showing result
          if (status.state == VerificationState.clear) {
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) _navigateToPersonalInfo(status);
            });
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStatus = VerificationStatus.error(
            message: 'Submission failed. Please try again.',
          );
        });
      }
    }
  }

  void _navigateToPersonalInfo(VerificationStatus status) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            OwnerInformationScreen(
          vendorType: widget.vendorType,
          businessCategory: widget.businessCategory,
          businessName: widget.businessName,
          verifiedFirstName: status.firstName,
          verifiedLastName: status.lastName,
          verifiedIdNumber: status.idNumber,
        ),
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
      (route) => false, // Remove all previous routes
    );
  }

  void _retry() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon/Animation
              if (_currentStatus == null ||
                  _currentStatus!.state == VerificationState.uploading ||
                  _currentStatus!.state == VerificationState.processing)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      duration: 1200.ms,
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                    )
              else if (_currentStatus!.state == VerificationState.clear)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppColors.success,
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
              else if (_currentStatus!.state == VerificationState.block)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cancel,
                    size: 80,
                    color: AppColors.danger,
                  ),
                )
                    .animate()
                    .shake(duration: 600.ms)
              else if (_currentStatus!.state == VerificationState.underReview)
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pending,
                    size: 80,
                    color: AppColors.warning,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 80,
                    color: AppColors.danger,
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                _getTitleText(),
                style: AppTypography.h1(AppColors.textPrimary).copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.2, delay: 200.ms, duration: 400.ms),
              
              const SizedBox(height: 12),
              
              // Message
              Text(
                _getMessageText(),
                style: AppTypography.body(AppColors.textSecondary).copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(begin: 0.1, delay: 400.ms, duration: 400.ms),
              
              const SizedBox(height: 32),
              
              // Verified Information (on success)
              if (_currentStatus?.state == VerificationState.clear) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.05),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Verified Information',
                        style: AppTypography.body(AppColors.success).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _InfoRow('Full Name',
                          '${_currentStatus!.firstName} ${_currentStatus!.lastName}'),
                      _InfoRow('ID Number', _currentStatus!.idNumber ?? 'N/A'),
                      if (_currentStatus!.dateOfBirth != null)
                        _InfoRow('Date of Birth', _currentStatus!.dateOfBirth!),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .scale(
                        begin: const Offset(0.95, 0.95),
                        delay: 600.ms,
                        duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Continuing automatically...',
                  style: AppTypography.bodySm(AppColors.textMuted).copyWith(
                    fontSize: 14,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 400.ms),
              ],
              
              // Retry button (on failure)
              if (_currentStatus?.state == VerificationState.block ||
                  _currentStatus?.state == VerificationState.error ||
                  _currentStatus?.state == VerificationState.underReview) ...[
                const SizedBox(height: 24),
                SwiftButton(
                  label: _currentStatus!.state == VerificationState.underReview
                      ? 'Continue Anyway'
                      : 'Retry Verification',
                  onPressed: _retry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getTitleText() {
    if (_currentStatus == null) return 'Submitting...';
    
    switch (_currentStatus!.state) {
      case VerificationState.uploading:
        return 'Uploading Documents...';
      case VerificationState.processing:
        return 'Verifying Identity...';
      case VerificationState.clear:
        return 'Verification Successful!';
      case VerificationState.block:
        return 'Verification Failed';
      case VerificationState.underReview:
        return 'Under Review';
      case VerificationState.error:
        return 'Something Went Wrong';
    }
  }

  String _getMessageText() {
    if (_currentStatus == null) {
      return 'Preparing your documents...';
    }
    
    return _currentStatus!.message ?? '';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body(AppColors.textSecondary).copyWith(
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: AppTypography.body(AppColors.textPrimary).copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
