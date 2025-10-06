import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/initial_page.dart';
import 'package:demo_project/view_model/user_data.dart';

class DataInitializePage extends HookConsumerWidget {
  const DataInitializePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;

    useEffect(handleEffect(context, ref), []);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: nContainer(
          alignment: Alignment.center,
          squareSize: double.infinity,
          gradient: mainGradation(),
          child: Hero(
            tag: "app_logo",
            child: nContainer(
              squareSize: safeAreaWidth * 0.5,
              image: assetImg("image/logo.png"),
            ),
          ),
        ),
      ),
    );
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
////＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(BuildContext context, WidgetRef ref) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        final notifier = ref.read(userDataNotifierProvider.notifier);
        await notifier
            .reFetchStartupData()
            .timeout(const Duration(seconds: 10), onTimeout: () => false);
        if (!context.mounted) return;
        ScreenTransition(context, const InitialPage()).normal(true);
      });
      return null;
    };
  }
}
