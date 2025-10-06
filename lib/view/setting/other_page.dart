import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/setting/delete_account_page.dart';

class OtherSettingPage extends HookConsumerWidget {
  const OtherSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final ln = AppLocalizations.of(context)!;

    final isLoading = useState<bool>(false);

    if (isLoading.value) return loadinPage(safeAreaWidth);
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: nAppBar(context, safeAreaWidth, title: ln.otherSettings),
      body: nButton(
        safeAreaWidth,
        margin: nSpacing(
          xSize: safeAreaWidth * 0.05,
          top: safeAreaWidth * 0.07,
        ),
        backGroundColor: Colors.white,
        boxShadow: nBoxShadow(shadow: 0.05),
        width: safeAreaWidth,
        text: ln.deleteAccount,
        textColor: redColor,
        radius: 15,
        onTap: onTap(context),
      ),
    );
  }

  VoidCallback onTap(BuildContext context) {
    return () {
      ScreenTransition(context, const DeleteAccountPage()).top();
    };
  }
}
