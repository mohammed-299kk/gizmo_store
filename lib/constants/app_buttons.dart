import 'package:flutter/material.dart';
import 'app_spacing.dart';
import 'app_colors.dart';

/// نظام الأزرار الموحد للتطبيق
class AppButtons {
  AppButtons._();

  // أنماط الأزرار الأساسية
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationMD,
        padding: AppSpacing.buttonPaddingLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  static ButtonStyle get secondaryButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onSecondary,
        elevation: AppSpacing.elevationSM,
        padding: AppSpacing.buttonPaddingLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      );

  static ButtonStyle get outlinedButton => OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: AppSpacing.buttonPaddingLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        side: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  static ButtonStyle get textButton => TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: AppSpacing.buttonPaddingMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  // أزرار بأحجام مختلفة
  static ButtonStyle get smallButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationSM,
        padding: AppSpacing.buttonPaddingSmall,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSM,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        minimumSize: const Size(80, 36),
      );

  static ButtonStyle get largeButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationLG,
        padding: AppSpacing.buttonPaddingXLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        minimumSize: const Size(200, 56),
      );

  // أزرار خاصة
  static ButtonStyle get dangerButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.onError,
        elevation: AppSpacing.elevationMD,
        padding: AppSpacing.buttonPaddingLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  static ButtonStyle get successButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevationMD,
        padding: AppSpacing.buttonPaddingLarge,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.buttonBorderRadius,
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      );

  // أزرار عائمة
  static ButtonStyle get floatingButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationLG,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLG,
        ),
      );

  // أزرار أيقونة
  static ButtonStyle get iconButton => IconButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: AppColors.surface,
        padding: AppSpacing.paddingMD,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMD,
        ),
      );

  // أزرار مخصصة للحالات الخاصة
  static ButtonStyle get cartButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: AppSpacing.elevationMD,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );

  static ButtonStyle get checkoutButton => ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        elevation: AppSpacing.elevationLG,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        minimumSize: const Size(double.infinity, 56),
      );
}

/// ويدجت أزرار مخصصة مع تأثيرات
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    if (icon != null) {
      button = ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    style?.foregroundColor?.resolve({}) ?? Colors.white,
                  ),
                ),
              )
            : icon!,
        label: Text(text),
        style: style ?? AppButtons.primaryButton,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? AppButtons.primaryButton,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    style?.foregroundColor?.resolve({}) ?? Colors.white,
                  ),
                ),
              )
            : Text(text),
      );
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// زر مخصص مع تأثيرات متقدمة
class AnimatedAppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final Duration animationDuration;

  const AnimatedAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedAppButton> createState() => _AnimatedAppButtonState();
}

class _AnimatedAppButtonState extends State<AnimatedAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.icon != null
                ? ElevatedButton.icon(
                    onPressed: null, // نستخدم GestureDetector بدلاً من ذلك
                    icon: widget.icon!,
                    label: Text(widget.text),
                    style: widget.style ?? AppButtons.primaryButton,
                  )
                : ElevatedButton(
                    onPressed: null, // نستخدم GestureDetector بدلاً من ذلك
                    style: widget.style ?? AppButtons.primaryButton,
                    child: Text(widget.text),
                  ),
          );
        },
      ),
    );
  }
}
