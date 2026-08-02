import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../motion/motion.dart';
import '../theme/app_colors.dart';
import 'animated_press.dart';

/// A premium primary / secondary / text / loading / success / error button
/// with built-in micro-interactions (press-scale, state morphs with spring, haptic).
class SwiftButton extends StatefulWidget {
  const SwiftButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.variant = SwiftButtonVariant.primary,
    this.color,
    this.textColor,
    this.fullWidth = true,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final SwiftButtonVariant variant;
  final Color? color;
  final Color? textColor;
  final bool fullWidth;
  final double height;

  @override
  State<SwiftButton> createState() => _SwiftButtonState();
}

enum SwiftButtonVariant { primary, secondary, ghost, danger }

class _SwiftButtonState extends State<SwiftButton>
    with TickerProviderStateMixin {
  late final AnimationController _shakeCtrl;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(covariant SwiftButton old) {
    super.didUpdateWidget(old);
    if (widget.isError && !old.isError) {
      Haptics.error();
      _shakeCtrl.forward(from: 0);
    } else if (widget.isSuccess && !old.isSuccess) {
      Haptics.success();
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null &&
        !widget.isLoading &&
        !widget.isSuccess &&
        !widget.isError;

    final Color bg;
    final Color fg;
    final Color? border;

    switch (widget.variant) {
      case SwiftButtonVariant.primary:
        bg = widget.isError
            ? AppColors.danger
            : (widget.color ?? AppColors.primary);
        fg = widget.textColor ?? Colors.white;
        border = null;
        break;
      case SwiftButtonVariant.secondary:
        bg = Colors.white;
        fg = widget.isError ? AppColors.danger : (widget.textColor ?? AppColors.primary);
        border = widget.isError ? AppColors.danger : (widget.color ?? AppColors.primary);
        break;
      case SwiftButtonVariant.ghost:
        bg = Colors.transparent;
        fg = widget.isError ? AppColors.danger : (widget.textColor ?? AppColors.primary);
        border = Colors.transparent;
        break;
      case SwiftButtonVariant.danger:
        bg = AppColors.danger;
        fg = Colors.white;
        border = null;
        break;
    }

    Widget content = AnimatedContainer(
      duration: Motion.normal,
      curve: Motion.standard,
      height: widget.height,
      width: widget.fullWidth ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: widget.fullWidth ? 0 : 24),
      decoration: BoxDecoration(
        color: enabled ? bg : bg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: border == null ? null : Border.all(color: border, width: 1.4),
        boxShadow: (widget.variant == SwiftButtonVariant.primary ||
                widget.variant == SwiftButtonVariant.danger) &&
                enabled
            ? [
                BoxShadow(
                  color: bg.withOpacity(0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                )
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled
              ? () {
                  Haptics.medium();
                  widget.onPressed!();
                }
              : null,
          child: Center(
            child: AnimatedSwitcher(
              duration: Motion.normal,
              switchInCurve: Motion.spring,
              switchOutCurve: Motion.standard,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(fg),
                      ),
                    )
                  : widget.isSuccess
                      ? Icon(Icons.check_rounded, color: fg, size: 26,
                          key: const ValueKey('success'))
                      : widget.isError
                          ? Icon(Icons.error_outline_rounded, color: fg, size: 24,
                              key: const ValueKey('error'))
                          : Row(
                              key: const ValueKey('label'),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, color: fg, size: 20),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.label,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: fg,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
            ),
          ),
        ),
      ),
    );

    if (widget.isError) {
      content = AnimatedBuilder(
        animation: _shakeCtrl,
        builder: (_, child) {
          final v = _shakeCtrl.value;
          final sine = 8.0 * math.sin(v * 3 * 3.1415926) * (1 - v);
          return Transform.translate(offset: Offset(sine, 0), child: child);
        },
        child: content,
      );
    }

    return widget.fullWidth
        ? content
        : Row(mainAxisSize: MainAxisSize.min, children: [content]);
  }
}
