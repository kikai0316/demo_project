import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';

OverlayEntry? _currentSnackBar;
AnimationController? _currentAnimationController;

void nShowCenterSnackBar(
  BuildContext context, {
  required String message,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  const Duration displayDuration = Duration(seconds: 2);
  final overlay = Overlay.of(context);

  if (_currentSnackBar != null) {
    _currentSnackBar!.remove();
    _currentAnimationController?.dispose();
    _currentSnackBar = null;
    _currentAnimationController = null;
  }

  final AnimationController animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: Navigator.of(context),
  );

  final Animation<double> fadeInAnimation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeIn,
  );

  final Animation<double> scaleAnimation = Tween<double>(
    begin: 1.3,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ),
  );

  late OverlayEntry overlayEntry;
  Future<void> closeSnackBar() async {
    if (overlayEntry.mounted) {
      await animationController.reverse();
      overlayEntry.remove();
      animationController.dispose();
      if (_currentSnackBar == overlayEntry) {
        _currentSnackBar = null;
        _currentAnimationController = null;
      }
    }
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: screenHeight / 2 - 50,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Opacity(
              opacity: fadeInAnimation.value,
              child: Transform.scale(
                scale: animationController.status == AnimationStatus.reverse
                    ? 1.0
                    : scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Dismissible(
            direction: DismissDirection.up,
            onDismissed: (direction) {
              overlayEntry.remove();
              animationController.dispose();
              if (_currentSnackBar == overlayEntry) {
                _currentSnackBar = null;
                _currentAnimationController = null;
              }
            },
            key: ValueKey(message),
            child: nContainer(
              alignment: Alignment.center,
              width: safeAreaWidth,
              child: nContainer(
                padding: nSpacing(allSize: safeAreaWidth * 0.04),
                radius: 10,
                color: subBackgroundColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nContainer(
                      maxWidth: safeAreaWidth * 0.7,
                      child: nText(
                        message,
                        fontSize: safeAreaWidth / 30,
                        isOverflow: false,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  _currentSnackBar = overlayEntry;
  _currentAnimationController = animationController;
  overlay.insert(overlayEntry);
  animationController.forward();
  Future.delayed(displayDuration, closeSnackBar);
}
