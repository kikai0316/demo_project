import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/init_setting/gender_setting_page.dart';
import 'package:demo_project/widget/login/init_setting_widget.dart';

final _textController = TextEditingController();

class UserNamePage extends HookConsumerWidget {
  const UserNamePage({
    super.key,
    required this.birthday,
  });

  final String birthday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return PopScope(
          canPop: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: mainBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  initSetteingTitle(constraints, ln.pleaseUserName),
                  nText(
                    ln.userNameExplanation,
                    padding: nSpacing(allSize: safeAreaWidth * 0.05),
                    fontSize: safeAreaWidth / 23,
                    color: blackColor.withCustomOpacity(0.6),
                    isFit: true,
                  ),
                  userNameInput(
                    safeAreaWidth,
                    textController: _textController,
                    onFieldSubmitted: onSubmitted(context),
                  ),
                  const Spacer(),
                  nButton(
                    safeAreaWidth,
                    margin: nSpacing(ySize: safeAreaWidth * 0.03),
                    backGroundColor: Colors.blueAccent,
                    width: safeAreaWidth * 0.9,
                    fontSize: safeAreaWidth / 23,
                    radius: 15,
                    text: ln.done,
                    textColor: Colors.white,
                    onTap: onDone(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void Function(String)? onSubmitted(BuildContext context) {
    return (text) {
      if (text.isEmpty) {
        final ln = AppLocalizations.of(context)!;
        nErrorDialog(context, ln.emptyUserName);
        return;
      }
      final page = GenderSettingPage(birthday: birthday, userName: text);
      ScreenTransition(context, page).normal();
    };
  }

  VoidCallback? onDone(BuildContext context) {
    return () {
      final text = _textController.text;
      if (text.isEmpty) {
        final ln = AppLocalizations.of(context)!;
        nErrorDialog(context, ln.emptyUserName);
        return;
      }
      final page = GenderSettingPage(birthday: birthday, userName: text);
      ScreenTransition(context, page).normal();
    };
  }
}
