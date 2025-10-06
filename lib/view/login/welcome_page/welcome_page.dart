import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/gradient_loop_button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/utility/path_provider_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/phone_login/phone_login_page.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final ln = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final safeAreaWidth = constraints.maxWidth;
          final safeAreaHeight = constraints.maxHeight;
          return nContainer(
            gradient: mainGradation(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: SafeArea(
                  child: Column(
                    children: [
                      nContainer(
                        margin: nSpacing(top: safeAreaHeight * 0.2),
                        squareSize: safeAreaWidth * 0.5,
                        image: assetImg("image/logo3.png"),
                      ),
                      const Spacer(),
                      GradientLoopButton(
                        onTap: onStart(context),
                        text: ln.getStarted,
                        fontSize: safeAreaWidth / 22,
                        margin: nSpacing(bottom: safeAreaWidth * 0.1),
                        safeAreaWidth: safeAreaWidth,
                        beginColor: const Color.fromARGB(255, 0, 217, 255),
                        endColor: const Color.fromARGB(255, 75, 147, 255),
                        height: safeAreaWidth * 0.18,
                        bold: 900,
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // タップイベント
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onStart(BuildContext context) {
    return () {
      isFirstLaunch = false;
      localWriteFirstActions(startup: false);
      ScreenTransition(context, const PhoneLoginPage()).top();
    };
  }
}
