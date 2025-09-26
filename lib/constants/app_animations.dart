import 'package:flutter/material.dart';

class AppAnimations {
  // مدة الانتقالات
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration normalDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  static const Duration extraSlowDuration = Duration(milliseconds: 800);

  // منحنيات الانتقال
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve smoothCurve = Curves.easeOutCubic;
  static const Curve sharpCurve = Curves.easeInCubic;

  // تأثيرات الصفحات
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            CurveTween(curve: curve),
          ),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget page,
    double begin = 0.0,
    double end = 1.0,
    Duration duration = normalDuration,
    Curve curve = bounceCurve,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        return ScaleTransition(
          scale: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  // تأثيرات الويدجت
  static Widget fadeInUp({
    required Widget child,
    Duration duration = normalDuration,
    Duration delay = Duration.zero,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + delay,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  static Widget slideInLeft({
    required Widget child,
    Duration duration = normalDuration,
    Duration delay = Duration.zero,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + delay,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget scaleIn({
    required Widget child,
    Duration duration = normalDuration,
    Duration delay = Duration.zero,
    Curve curve = bounceCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration + delay,
      tween: Tween(begin: 0.0, end: 1.0),
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // تأثيرات التفاعل
  static Widget rippleEffect({
    required Widget child,
    required VoidCallback onTap,
    Color? rippleColor,
    BorderRadius? borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: rippleColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  static Widget hoverEffect({
    required Widget child,
    double scale = 1.05,
    Duration duration = fastDuration,
    Curve curve = defaultCurve,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TweenAnimationBuilder<double>(
        duration: duration,
        tween: Tween(begin: 1.0, end: 1.0),
        curve: curve,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  // تأثيرات الشحن
  static Widget shimmerEffect({
    required Widget child,
    Color? baseColor,
    Color? highlightColor,
    Duration duration = const Duration(milliseconds: 1500),
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: -1.0, end: 2.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor ?? Colors.grey[300]!,
                highlightColor ?? Colors.grey[100]!,
                baseColor ?? Colors.grey[300]!,
              ],
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // تأثيرات الظهور المتتالي
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration staggerDelay = const Duration(milliseconds: 100),
    Duration animationDuration = normalDuration,
    Curve curve = defaultCurve,
  }) {
    return children.asMap().entries.map((entry) {
      final index = entry.key;
      final child = entry.value;
      final delay = staggerDelay * index;
      
      return fadeInUp(
        child: child,
        duration: animationDuration,
        delay: delay,
        curve: curve,
      );
    }).toList();
  }
}

// ويدجت مخصص للانتقالات
class AnimatedContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool animate;

  const AnimatedContainer({
    Key? key,
    required this.child,
    this.duration = AppAnimations.normalDuration,
    this.curve = AppAnimations.defaultCurve,
    this.animate = true,
  }) : super(key: key);

  @override
  State<AnimatedContainer> createState() => _AnimatedContainerState();
}

class _AnimatedContainerState extends State<AnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Opacity(
            opacity: _animation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}