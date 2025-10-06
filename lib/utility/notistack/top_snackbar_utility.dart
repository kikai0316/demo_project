import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';

// 現在表示中のスナックバーを管理するグローバル変数
OverlayEntry? _currentSnackBar;
AnimationController? _currentFadeInController;
AnimationController? _currentSlideController;

void nTopSnackBar(
  BuildContext context,
  double safeAreaWidth, {
  required String message,
  Widget? addRightWidget,
  Widget? addLeftWidget,
  TextAlign textAlign = TextAlign.center,
  Color? textColor,
}) {
  const Duration displayDuration = Duration(seconds: 2);
  final overlay = Overlay.of(context);

  // 前回のスナックバーが表示中なら即座に消す
  if (_currentSnackBar != null) {
    _currentSnackBar!.remove();
    _currentFadeInController?.dispose();
    _currentSlideController?.dispose();
    _currentSnackBar = null;
    _currentFadeInController = null;
    _currentSlideController = null;
  }

  // 表示用のアニメーションコントローラー
  final AnimationController fadeInController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: Navigator.of(context),
  );

  // スライド用のアニメーションコントローラー
  final AnimationController slideController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: Navigator.of(context),
  );

  // フェードインアニメーション
  final Animation<double> fadeInAnimation = CurvedAnimation(
    parent: fadeInController,
    curve: Curves.easeIn,
  );

  // スライドアップアニメーション
  final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -1.5),
  ).animate(
    CurvedAnimation(
      parent: slideController,
      curve: Curves.easeOut,
    ),
  );

  late OverlayEntry overlayEntry;

  // スナックバーを閉じる関数
  Future<void> closeSnackBar() async {
    if (overlayEntry.mounted) {
      await slideController.forward();
      overlayEntry.remove();
      fadeInController.dispose();
      slideController.dispose();

      // グローバル参照をクリア
      if (_currentSnackBar == overlayEntry) {
        _currentSnackBar = null;
        _currentFadeInController = null;
        _currentSlideController = null;
      }
    }
  }

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: fadeInAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Dismissible(
              direction: DismissDirection.up,
              onDismissed: (direction) {
                overlayEntry.remove();
                fadeInController.dispose();
                slideController.dispose();

                // グローバル参照をクリア
                if (_currentSnackBar == overlayEntry) {
                  _currentSnackBar = null;
                  _currentFadeInController = null;
                  _currentSlideController = null;
                }
              },
              key: ValueKey(message),
              child: nContainer(
                alignment: Alignment.center,
                width: safeAreaWidth,
                child: nContainer(
                  padding: nSpacing(allSize: safeAreaWidth * 0.04),
                  radius: 10,
                  color: mainBackgroundColor,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (addLeftWidget != null) addLeftWidget,
                      nContainer(
                        maxWidth: safeAreaWidth * 0.7,
                        child: nText(
                          message,
                          fontSize: safeAreaWidth / 30,
                          color: textColor,
                          isOverflow: false,
                          textAlign: textAlign,
                          height: 1.2,
                        ),
                      ),
                      if (addRightWidget != null) addRightWidget,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // グローバル参照を更新
  _currentSnackBar = overlayEntry;
  _currentFadeInController = fadeInController;
  _currentSlideController = slideController;

  overlay.insert(overlayEntry);

  Future(() async {
    HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });
  fadeInController.forward();

  // 2秒たったらに自動で閉じる
  Future.delayed(displayDuration, closeSnackBar);
}
