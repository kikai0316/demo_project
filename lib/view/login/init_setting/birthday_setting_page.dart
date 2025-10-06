import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/init_setting/user_name_setteling_page.dart';
import 'package:demo_project/widget/login/init_setting_widget.dart';

final _textController = TextEditingController();

class BirthdayPage extends HookConsumerWidget {
  const BirthdayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final focusNode = useFocusNode();

    useEffect(handleEffect(focusNode), []);
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
                  initSetteingTitle(constraints, ln.pleaseBirth),
                  birthdayInput(
                    context,
                    safeAreaWidth,
                    focusNode,
                    _textController,
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

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(FocusNode focusNode) {
    return () {
      focusNode.requestFocus();
      return null;
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント系
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Function(String)? onChanged(
    BuildContext context,
    ValueNotifier<int> age,
  ) {
    return (value) => context.mounted && value.isNotEmpty
        ? age.value = int.parse(value)
        : null;
  }

  VoidCallback? onDone(BuildContext context) {
    return () {
      final ln = AppLocalizations.of(context)!;
      final value = _textController.text;
      final age = int.parse(value.isNotEmpty ? value : "0");
      if (age < 13) {
        nErrorDialog(context, ln.ageRestriction);
        return;
      }
      final birthday = _birthDateFromAge(age);
      ScreenTransition(context, UserNamePage(birthday: birthday)).normal();
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  String _birthDateFromAge(int age) {
    final now = DateTime.now();
    final birthYear = now.year - age;
    final birthDate = DateTime(birthYear);
    return "${birthDate.year.toString().padLeft(4, '0')}-"
        "${birthDate.month.toString().padLeft(2, '0')}-"
        "${birthDate.day.toString().padLeft(2, '0')}";
  }
}
