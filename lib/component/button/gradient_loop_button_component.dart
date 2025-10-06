import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';

class GradientLoopButton extends HookWidget {
  const GradientLoopButton({
    super.key,
    required this.text,
    required this.fontSize,
    required this.safeAreaWidth,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.radius,
    this.bold = 700,
    this.beginColor = const Color(0xFF9BF310),
    this.endColor = const Color(0xFFFE4AE5),
  });
  final double safeAreaWidth;
  final String text;
  final VoidCallback? onTap;
  final double fontSize;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final double? radius;
  final double bold;
  final Color beginColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(seconds: 5));
    useEffect(handleEffect(animationController), []);

    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final startOffset = safeAreaWidth * -3;
        final endOffset = safeAreaWidth * -0.5;
        final tween = Tween<Offset>(
          begin: Offset(startOffset, 0),
          end: Offset(endOffset, 0),
        );
        final gradationAnimation = tween.animate(animationController);
        return CustomAnimatedButton(
          onTap: onTap,
          child: nContainer(
            alignment: Alignment.center,
            height: height ?? (safeAreaWidth * 0.15),
            width: width ?? safeAreaWidth * 0.8,
            margin: margin,
            clipBehavior: Clip.hardEdge,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius ?? 15),
              child: LoopBackGround(
                safeAreaWidth: safeAreaWidth,
                gradationAnimation: gradationAnimation,
                animationController: animationController,
                beginColor: beginColor,
                endColor: endColor,
                child: Center(
                  child: nText(
                    text,
                    fontSize: fontSize,
                    bold: bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(AnimationController animationController) {
    return () {
      animationController.repeat();
      return null;
    };
  }
}

class LoopBackGround extends StatelessWidget {
  final double safeAreaWidth;
  final Animation<Offset> gradationAnimation;
  final AnimationController animationController;
  final Widget? child;
  final double? fullWidth;
  final bool isAnimation;
  final Offset? initialOffset;
  final Color beginColor;
  final Color endColor;

  const LoopBackGround({
    required this.safeAreaWidth,
    required this.gradationAnimation,
    required this.animationController,
    required this.beginColor,
    required this.endColor,
    this.child,
    this.fullWidth,
    this.isAnimation = true,
    this.initialOffset,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundBoxDecoration = LinearGradient(
      colors: [beginColor, endColor, beginColor, endColor, beginColor],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
    );

    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, child) {
        return ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: (isAnimation
                    ? gradationAnimation.value.dx + (initialOffset?.dx ?? 0)
                    : initialOffset?.dx ?? 0),
                top: 0,
                child: Container(
                  width: safeAreaWidth * 5,
                  height: 200, // 固定の高さを設定
                  decoration: BoxDecoration(gradient: backgroundBoxDecoration),
                ),
              ),
              // 子ウィジェット
              if (child != null)
                Positioned.fill(
                  child: child,
                ),
            ],
          ),
        );
      },
    );
  }
}
