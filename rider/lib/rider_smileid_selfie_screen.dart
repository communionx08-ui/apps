import 'package:swift_core/swift_core.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'rider_smileid_liveness_screen.dart';

class RiderSmileIdSelfieScreen extends StatefulWidget {
  final String givenNames;
  final String lastName;
  final String email;
  final String idType;
  final Uint8List documentFront;
  final Uint8List? documentBack;

  const RiderSmileIdSelfieScreen({
    super.key,
    required this.givenNames,
    required this.lastName,
    required this.email,
    required this.idType,
    required this.documentFront,
    this.documentBack,
  });

  @override
  State<RiderSmileIdSelfieScreen> createState() =>
      _RiderSmileIdSelfieScreenState();
}

class _RiderSmileIdSelfieScreenState extends State<RiderSmileIdSelfieScreen> {
  final ImagePicker _picker = ImagePicker();
  
  Uint8List? _selfieBytes;
  bool _isProcessing = false;

  Future<void> _captureSelfie() async {
    setState(() => _isProcessing = true);
    
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 82,
      );
      
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final resized = await _resizeImage(bytes);
        setState(() => _selfieBytes = resized);
        Haptics.success();
      }
    } catch (e) {
      if (kIsWeb) {
        // On web, show option to skip
        _showWebSkipDialog();
      } else {
        _showError('Failed to capture selfie. Please try again.');
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }
  
  void _showWebSkipDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Not Available on Web',
          style: AppTypography.h2()(AppColors.textPrimary),
        ),
        content: Text(
          'Image capture is not supported in web browsers. Would you like to use mock data for testing?',
          style: AppTypography.body()(AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.body()(AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _useMockSelfie();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Use Mock Data',
              style: AppTypography.body()(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  void _useMockSelfie() {
    // Generate a simple oval face mockup as selfie
    final mockImage = img.Image(width: 800, height: 800);
    img.fill(mockImage, color: img.ColorRgb8(250, 220, 200)); // Skin tone
    
    final bytes = Uint8List.fromList(img.encodeJpg(mockImage, quality: 82));
    
    setState(() {
      _selfieBytes = bytes;
    });
    
    Haptics.success();
  }

  Future<Uint8List> _resizeImage(Uint8List bytes) async {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    if (image.width > 1024 || image.height > 1024) {
      final resized = img.copyResize(
        image,
        width: image.width > image.height ? 1024 : null,
        height: image.height > image.width ? 1024 : null,
      );
      return Uint8List.fromList(img.encodeJpg(resized, quality: 82));
    }
    
    return bytes;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.body()(Colors.white).copyWith(fontSize: 14),
        ),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Haptics.error();
  }

  void _onContinue() {
    if (_selfieBytes == null) {
      _showError('Please capture your selfie');
      return;
    }

    Haptics.success();
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RiderSmileIdLivenessScreen(
          givenNames: widget.givenNames,
          lastName: widget.lastName,
          email: widget.email,
          idType: widget.idType,
          documentFront: widget.documentFront,
          documentBack: widget.documentBack,
          selfie: _selfieBytes!,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // App Bar
          SafeArea(
            child: Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
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
                            'Take a Selfie',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2()(AppColors.textPrimary)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Container(
                    height: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 0.4, // Step 4 of 10 (40%)
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                  
                  Text(
                    'Take a Selfie',
                    style: AppTypography.h1()(AppColors.textPrimary).copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.95, 0.95),
                          delay: 200.ms,
                          duration: 600.ms,
                          curve: Curves.elasticOut),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Position your face inside the guide and tap capture.',
                    style: AppTypography.body()(AppColors.textSecondary).copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms, curve: Curves.easeOut)
                      .slideY(
                          begin: 0.1,
                          delay: 400.ms,
                          duration: 400.ms,
                          curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 32),
                  
                  // Selfie Preview or Placeholder
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      color: _selfieBytes == null
                          ? AppColors.primary.withOpacity(0.05)
                          : Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: _selfieBytes == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.3),
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  size: 60,
                                  color: AppColors.primary.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Centre your face',
                                style: AppTypography.body()(AppColors.textSecondary)
                                    .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.memory(
                              _selfieBytes!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.95, 0.95),
                          delay: 600.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 24),
                  
                  // Tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tips for a good selfie',
                              style: AppTypography.body()(AppColors.primary).copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _TipItem('Face the camera directly'),
                        _TipItem('Good lighting on your face'),
                        _TipItem('Remove glasses or hat if possible'),
                        _TipItem('Keep a neutral expression'),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.95, 0.95),
                          delay: 700.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Buttons
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
              if (_selfieBytes == null)
                SwiftButton(
                  label: _isProcessing ? 'Processing...' : 'Capture Selfie',
                  onPressed: _isProcessing ? null : _captureSelfie,
                  icon: Icons.camera_alt,
                )
              else ...[
                SwiftButton(
                  label: 'Continue to Liveness Check',
                  onPressed: _onContinue,
                ),
                const SizedBox(height: 12),
                SwiftButton(
                  label: 'Retake Selfie',
                  onPressed: _captureSelfie,
                ),
              ],
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: 800.ms, duration: 500.ms, curve: Curves.easeOut)
          .slideY(
              begin: 0.1,
              delay: 800.ms,
              duration: 400.ms,
              curve: Curves.easeOutCubic),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body()(AppColors.textSecondary).copyWith(
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
