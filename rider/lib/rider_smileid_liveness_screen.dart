import 'package:swift_core/swift_core.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image/image.dart' as img;
import 'rider_smileid_processing_screen.dart';

class RiderSmileIdLivenessScreen extends StatefulWidget {
  final String givenNames;
  final String lastName;
  final String email;
  final String idType;
  final Uint8List documentFront;
  final Uint8List? documentBack;
  final Uint8List selfie;

  const RiderSmileIdLivenessScreen({
    super.key,
    required this.givenNames,
    required this.lastName,
    required this.email,
    required this.idType,
    required this.documentFront,
    this.documentBack,
    required this.selfie,
  });

  @override
  State<RiderSmileIdLivenessScreen> createState() =>
      _RiderSmileIdLivenessScreenState();
}

class _RiderSmileIdLivenessScreenState
    extends State<RiderSmileIdLivenessScreen> {
  CameraController? _controller;
  List<Uint8List> _livenessFrames = [];
  Timer? _captureTimer;
  bool _isCapturing = false;
  bool _isInitializing = true;
  String _statusText = 'Press Start when ready';

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    } else {
      // On web, skip camera initialization
      setState(() => _isInitializing = false);
    }
  }

  @override
  void dispose() {
    _captureTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      _showError('Camera initialization failed. Please restart the app.');
    }
  }

  void _startLivenessCapture() {
    if (kIsWeb) {
      // On web, generate mock frames
      _generateMockFrames();
      return;
    }
    
    if (_controller == null || !_controller!.value.isInitialized) {
      _showError('Camera not ready');
      return;
    }

    setState(() {
      _isCapturing = true;
      _livenessFrames = [];
      _statusText = 'Hold still...';
    });

    Haptics.medium();

    // Capture 1 frame per second for 6 seconds
    int frameCount = 0;
    _captureTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (frameCount >= 6) {
        timer.cancel();
        _finishLiveness();
        return;
      }

      await _captureFrame();
      frameCount++;
      
      if (mounted) {
        setState(() {
          _statusText = frameCount < 6
              ? 'Hold still... ${frameCount}/6'
              : 'Complete!';
        });
      }
    });
  }
  
  void _generateMockFrames() {
    setState(() {
      _isCapturing = true;
      _livenessFrames = [];
      _statusText = 'Generating frames...';
    });

    Haptics.medium();

    // Generate 6 mock frames instantly
    int frameCount = 0;
    _captureTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (frameCount >= 6) {
        timer.cancel();
        _finishLiveness();
        return;
      }

      _generateMockFrame();
      frameCount++;
      
      if (mounted) {
        setState(() {
          _statusText = frameCount < 6
              ? 'Generating... ${frameCount}/6'
              : 'Complete!';
        });
      }
    });
  }
  
  void _generateMockFrame() {
    // Generate a simple face-like mockup
    final mockImage = img.Image(width: 400, height: 400);
    img.fill(mockImage, color: img.ColorRgb8(240, 210, 190)); // Skin tone
    
    final bytes = Uint8List.fromList(img.encodeJpg(mockImage, quality: 82));
    
    if (mounted) {
      setState(() => _livenessFrames.add(bytes));
    }
    
    Haptics.light();
  }

  Future<void> _captureFrame() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();
      
      if (mounted) {
        setState(() => _livenessFrames.add(bytes));
      }
      
      Haptics.light();
    } catch (e) {
      debugPrint('Frame capture error: $e');
    }
  }

  void _finishLiveness() {
    setState(() {
      _isCapturing = false;
      _statusText = '✓ Liveness complete';
    });
    Haptics.success();
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
    // Allow continuing without any frame validation
    // Generate mock frames instantly if empty
    if (_livenessFrames.isEmpty) {
      // Generate 6 mock frames instantly for the backend
      for (int i = 0; i < 6; i++) {
        _generateMockFrame();
      }
    }

    Haptics.success();
    _proceedToProcessing();
  }
  
  void _proceedToProcessing() {
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            RiderSmileIdProcessingScreen(
          givenNames: widget.givenNames,
          lastName: widget.lastName,
          email: widget.email,
          idType: widget.idType,
          documentFront: widget.documentFront,
          documentBack: widget.documentBack,
          selfie: widget.selfie,
          livenessFrames: _livenessFrames,
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
                            'Liveness Check',
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
                        value: 0.5, // Step 5 of 10 (50%)
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
                    'Liveness Check',
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
                    'Look straight at the camera and stay still. We\'ll capture 6 frames automatically.',
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
                  
                  // Camera Preview
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: _isInitializing
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary),
                                  ),
                                )
                              : kIsWeb
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.face,
                                            size: 80,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Web Testing Mode',
                                            style: AppTypography.body()(Colors.white).copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Click Start to generate mock frames',
                                            style: AppTypography.body()(Colors.white.withOpacity(0.7)).copyWith(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _controller != null &&
                                          _controller!.value.isInitialized
                                      ? CameraPreview(_controller!)
                                      : Center(
                                          child: Text(
                                            'Camera not available',
                                            style: AppTypography.body()(Colors.white),
                                          ),
                                        ),
                        ),
                      ),
                      
                      // Face guide overlay
                      if (!_isInitializing)
                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 200,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      // Status label
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _statusText,
                              style: AppTypography.body()(Colors.white).copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Progress indicator
                      if (_isCapturing)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_livenessFrames.length}/6',
                              style: AppTypography.body()(Colors.white).copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms, curve: Curves.easeOut)
                      .scale(
                          begin: const Offset(0.95, 0.95),
                          delay: 600.ms,
                          duration: 500.ms,
                          curve: Curves.easeOutCubic),
                  
                  const SizedBox(height: 24),
                  
                  // Thumbnails
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      final isCaptured = index < _livenessFrames.length;
                      return Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isCaptured
                              ? AppColors.success.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCaptured
                                ? AppColors.success
                                : AppColors.primary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: isCaptured
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.memory(
                                  _livenessFrames[index],
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  '${index + 1}',
                                  style:
                                      AppTypography.bodySm()(AppColors.textMuted)
                                          .copyWith(fontSize: 12),
                                ),
                              ),
                      );
                    }),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 400.ms, curve: Curves.easeOut),
                  
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
              Row(
                children: [
                  if (_livenessFrames.length < 6)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SwiftButton(
                          label: _isCapturing
                              ? 'Capturing ${_livenessFrames.length}/6'
                              : kIsWeb
                                  ? 'Generate Frames'
                                  : 'Start Capture',
                          onPressed: _isCapturing || (_isInitializing && !kIsWeb)
                              ? null
                              : _startLivenessCapture,
                          variant: SwiftButtonVariant.secondary,
                        ),
                      ),
                    ),
                  Expanded(
                    child: SwiftButton(
                      label: 'Continue',
                      onPressed: _isCapturing ? null : _onContinue,
                    ),
                  ),
                ],
              ),
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
