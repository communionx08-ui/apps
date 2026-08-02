import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swift_core/swift_core.dart';
import 'package:image/image.dart' as img;
import 'vendor_smileid_selfie_screen.dart';

class VendorSmileIdDocumentCaptureScreen extends StatefulWidget {
  final String vendorType;
  final String businessCategory;
  final String businessName;
  final String givenNames;
  final String lastName;
  final String email;
  final String idType;

  const VendorSmileIdDocumentCaptureScreen({
    super.key,
    required this.vendorType,
    required this.businessCategory,
    required this.businessName,
    required this.givenNames,
    required this.lastName,
    required this.email,
    required this.idType,
  });

  @override
  State<VendorSmileIdDocumentCaptureScreen> createState() =>
      _VendorSmileIdDocumentCaptureScreenState();
}

class _VendorSmileIdDocumentCaptureScreenState
    extends State<VendorSmileIdDocumentCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  
  Uint8List? _frontImageBytes;
  Uint8List? _backImageBytes;
  
  bool _isProcessingFront = false;
  bool _isProcessingBack = false;

  Future<void> _captureFront() async {
    setState(() => _isProcessingFront = true);
    
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 82,
      );
      
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final resized = await _resizeImage(bytes);
        setState(() => _frontImageBytes = resized);
        Haptics.success();
      }
    } catch (e) {
      if (kIsWeb) {
        // On web, show option to skip
        _showWebSkipDialog('front');
      } else {
        _showError('Failed to capture front. Please try again.');
      }
    } finally {
      setState(() => _isProcessingFront = false);
    }
  }

  Future<void> _captureBack() async {
    setState(() => _isProcessingBack = true);
    
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 82,
      );
      
      if (photo != null) {
        final bytes = await photo.readAsBytes();
        final resized = await _resizeImage(bytes);
        setState(() => _backImageBytes = resized);
        Haptics.success();
      }
    } catch (e) {
      if (kIsWeb) {
        // On web, show option to skip
        _showWebSkipDialog('back');
      } else {
        _showError('Failed to capture back. Please try again.');
      }
    } finally {
      setState(() => _isProcessingBack = false);
    }
  }
  
  void _showWebSkipDialog(String side) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Camera Not Available on Web',
          style: AppTypography.h2(AppColors.textPrimary),
        ),
        content: Text(
          'Image capture is not supported in web browsers. Would you like to use mock data for testing?',
          style: AppTypography.body(AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.body(AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _useMockImage(side);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Use Mock Data',
              style: AppTypography.body(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  
  void _useMockImage(String side) {
    // Generate a simple colored rectangle as mock image
    final mockImage = img.Image(width: 800, height: 600);
    img.fill(mockImage, color: side == 'front' 
      ? img.ColorRgb8(100, 150, 200)  // Blue for front
      : img.ColorRgb8(150, 100, 200)); // Purple for back
    
    final bytes = Uint8List.fromList(img.encodeJpg(mockImage, quality: 82));
    
    setState(() {
      if (side == 'front') {
        _frontImageBytes = bytes;
      } else {
        _backImageBytes = bytes;
      }
    });
    
    Haptics.success();
  }

  Future<Uint8List> _resizeImage(Uint8List bytes) async {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;
    
    // Resize if larger than 1024x1024
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
          style: AppTypography.body(Colors.white).copyWith(fontSize: 14),
        ),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Haptics.error();
  }

  void _onContinue() {
    if (_frontImageBytes == null) {
      _showError('Please capture the front of your document');
      return;
    }

    Haptics.success();
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            VendorSmileIdSelfieScreen(
          vendorType: widget.vendorType,
          businessCategory: widget.businessCategory,
          businessName: widget.businessName,
          givenNames: widget.givenNames,
          lastName: widget.lastName,
          email: widget.email,
          idType: widget.idType,
          documentFront: _frontImageBytes!,
          documentBack: _backImageBytes,
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
                            'Document Capture',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2(AppColors.textPrimary)
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
                        value: 0.3, // Step 3 of 10 (30%)
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
                    'Document Photos',
                    style: AppTypography.h1(AppColors.textPrimary).copyWith(
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
                    'Place your document on a flat surface with good lighting.',
                    style: AppTypography.body(AppColors.textSecondary).copyWith(
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
                  
                  // Front Capture
                  Text(
                    'Front of Document *',
                    style: AppTypography.body().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _UploadZone(
                    label: _frontImageBytes == null
                        ? 'Tap to capture front'
                        : 'Front captured',
                    sublabel: 'All corners must be visible',
                    icon: Icons.add_a_photo_outlined,
                    uploaded: _frontImageBytes != null,
                    isProcessing: _isProcessingFront,
                    imageBytes: _frontImageBytes,
                    onTap: _captureFront,
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.95, 0.95),
                          delay: 600.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 24),
                  
                  // Back Capture (Optional)
                  Text(
                    'Back of Document (optional)',
                    style: AppTypography.body().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  _UploadZone(
                    label: _backImageBytes == null
                        ? 'Tap to capture back'
                        : 'Back captured',
                    sublabel: 'Recommended for better accuracy',
                    icon: Icons.add_a_photo_outlined,
                    uploaded: _backImageBytes != null,
                    isProcessing: _isProcessingBack,
                    imageBytes: _backImageBytes,
                    onTap: _captureBack,
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
            label: 'Continue to Selfie',
            onPressed: _frontImageBytes != null ? _onContinue : null,
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

class _UploadZone extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool uploaded;
  final bool isProcessing;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const _UploadZone({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.uploaded,
    required this.isProcessing,
    this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPress(
      onTap: isProcessing ? null : onTap,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 42),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageBytes != null && !isProcessing) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    imageBytes!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (isProcessing)
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                )
              else
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
                isProcessing ? 'Processing...' : label,
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
    );
  }
}
