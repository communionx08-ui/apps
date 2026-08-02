import 'package:swift_core/swift_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_tokens.dart';
import '../services/haptic_service.dart';

class SwipeToConfirm extends StatefulWidget {
  final String text;
  final VoidCallback onConfirm;
  final bool isLoading;
  final Color? color;

  const SwipeToConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
    this.isLoading = false,
    this.color,
  });

  @override
  State<SwipeToConfirm> createState() => _SwipeToConfirmState();
}

class _SwipeToConfirmState extends State<SwipeToConfirm> with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  late AnimationController _controller;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTokens.durationFast,
    );
    _controller.addListener(() {
      setState(() {
        _dragValue = _controller.value * _dragValue;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isConfirmed || widget.isLoading) return;
    
    setState(() {
      _dragValue += details.primaryDelta! / (maxWidth - 60);
      if (_dragValue < 0) _dragValue = 0;
      if (_dragValue > 1) _dragValue = 1;
    });

    if (_dragValue > 0.1 && _dragValue < 0.15) {
      HapticService.selection();
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isConfirmed || widget.isLoading) return;

    if (_dragValue > 0.9) {
      setState(() {
        _dragValue = 1.0;
        _isConfirmed = true;
      });
      HapticService.heavy();
      widget.onConfirm();
    } else {
      _controller.forward(from: 0.0);
      HapticService.light();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.color ?? AppColors.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final thumbSize = 56.0;
        final trackWidth = maxWidth;
        final movableWidth = trackWidth - thumbSize - 8;

        return Container(
          height: 64,
          width: maxWidth,
          decoration: BoxDecoration(
            color: widget.isLoading ? AppColors.borderLight : themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTokens.radiusRound),
          ),
          child: Stack(
            children: [
              // Track Text
              Center(
                child: Opacity(
                  opacity: (1 - _dragValue).clamp(0.2, 1.0),
                  child: Text(
                    widget.isLoading ? 'Processing...' : widget.text,
                    style: AppTypography.bodyLg()(
                      widget.isLoading ? AppColors.textMuted : themeColor,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Progress Fill
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: thumbSize + (_dragValue * movableWidth) + 8,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTokens.radiusRound),
                  ),
                ),
              ),

              // Thumb
              Positioned(
                left: 4 + (_dragValue * movableWidth),
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) => _onDragUpdate(details, maxWidth),
                  onHorizontalDragEnd: _onDragEnd,
                  child: Container(
                    width: thumbSize,
                    decoration: BoxDecoration(
                      color: widget.isLoading ? AppColors.textMuted : themeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
