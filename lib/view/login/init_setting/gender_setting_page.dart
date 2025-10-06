import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/init_setting/user_image_setteling.dart';
import 'package:demo_project/widget/login/init_setting_widget.dart';

const dataBaseIndex = [1, 2, 0];

class GenderSettingPage extends HookConsumerWidget {
  const GenderSettingPage({
    super.key,
    required this.birthday,
    required this.userName,
  });

  final String birthday;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectIndex = useState<int?>(null);
    final ln = AppLocalizations.of(context)!;
    final genders = [ln.genderOptionMale, ln.genderOptionFemale, ln.notSet];
    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;
        return PopScope(
          canPop: false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: mainBackgroundColor,
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    initSetteingTitle(constraints, ln.genderTitle),
                    nText(
                      ln.genderNote,
                      padding: nSpacing(allSize: safeAreaWidth * 0.05),
                      fontSize: safeAreaWidth / 23,
                      color: blackColor.withCustomOpacity(0.6),
                      isFit: true,
                    ),
                    SizedBox(height: safeAreaHeight * 0.08),
                    for (int i = 0; i < 3; i++)
                      nButton(
                        safeAreaWidth,
                        margin: nSpacing(ySize: safeAreaWidth * 0.03),
                        backGroundColor: _bgColor(selectIndex, i),
                        border: _border(selectIndex, i),
                        textColor: _textColor(selectIndex, i),
                        boxShadow: _boxShadow(selectIndex, i),
                        width: safeAreaWidth * 0.9,
                        text: genders[i],
                        radius: 15,
                        onTap: () => selectIndex.value = dataBaseIndex[i],
                      ),
                    const Spacer(),
                    Opacity(
                      opacity: selectIndex.value != null ? 1 : 0.3,
                      child: nButton(
                        safeAreaWidth,
                        margin: nSpacing(ySize: safeAreaWidth * 0.03),
                        backGroundColor: Colors.blueAccent,
                        width: safeAreaWidth * 0.9,
                        fontSize: safeAreaWidth / 23,
                        radius: 15,
                        text: ln.done,
                        textColor: Colors.white,
                        onTap: onDone(context, selectIndex),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  VoidCallback? onDone(BuildContext context, ValueNotifier<int?> selectIndex) {
    if (selectIndex.value == null) return null;
    return () => ScreenTransition(
          context,
          UserImagePage(
            birthday: birthday,
            userName: userName,
            gender: selectIndex.value!,
          ),
        ).normal();
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // その他
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Color _bgColor(ValueNotifier<int?> selectIndex, int index) {
    final isSelect = selectIndex.value == dataBaseIndex[index];
    return isSelect ? Colors.blueAccent : const Color(0xFFF5F1E8);
  }

  BoxBorder _border(ValueNotifier<int?> selectIndex, int index) {
    final isSelect = selectIndex.value == dataBaseIndex[index];
    const unColor = Color(0xFFD4C5A9);
    return nBorder(color: isSelect ? Colors.blueAccent : unColor, width: 2);
  }

  Color _textColor(ValueNotifier<int?> selectIndex, int index) {
    final isSelect = selectIndex.value == dataBaseIndex[index];
    return isSelect ? Colors.white : const Color(0xFF6B5B47);
  }

  List<BoxShadow>? _boxShadow(ValueNotifier<int?> selectIndex, int index) {
    final isSelect = selectIndex.value == dataBaseIndex[index];
    final color = Colors.blueAccent.withCustomOpacity(0.4);
    return isSelect ? nBoxShadow(color: color) : null;
  }
}
