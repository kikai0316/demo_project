import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/user_data.dart';

TextEditingController? textController;

class EditHeighatPage extends HookConsumerWidget {
  const EditHeighatPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataNotifierProvider).value;
    final ln = AppLocalizations.of(context)!;
    final isCm = useState<bool>(true);
    final inputValue = useState<String>(user?.height.toString() ?? "");
    final isLoading = useState<bool>(false);
    final isSave = useState<bool>(true);

    useEffect(handleEffect(user?.height), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return Stack(
          children: [
            Scaffold(
              appBar: nAppBar(context, safeAreaWidth, title: ln.height),
              backgroundColor: mainBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    nContainer(
                      margin: nSpacing(
                        top: safeAreaWidth * 0.05,
                        bottom: safeAreaWidth * 0.03,
                      ),
                      width: safeAreaWidth * 0.8,
                      padding: nSpacing(
                        ySize: safeAreaWidth * 0.01,
                        xSize: safeAreaWidth * 0.03,
                      ),
                      boxShadow: nBoxShadow(shadow: 0.05),
                      border: nBorder(color: Colors.black, isOnlyBottom: true),
                      child: Row(
                        children: [
                          nTextFormField(
                            textController: textController,
                            keyboardType: TextInputType.number,
                            fontSize: safeAreaWidth / 9,
                            textColor: blackColor,
                            maxLength: isCm.value ? 3 : 4,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            onChanged: onChanged(isCm, inputValue, isSave),
                            hintText: isCm.value ? "150.0" : "5'0\"",
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 2; i++)
                          nTextButton(
                            safeAreaWidth,
                            padding: nSpacing(
                              ySize: safeAreaWidth * 0.03,
                              xSize: safeAreaWidth * 0.05,
                            ),
                            backgroundColor: backgroundColor(isCm, i),
                            color: textColor(isCm, i),
                            border:
                                nBorder(color: boderColor(isCm, i), width: 2),
                            margin: nSpacing(xSize: safeAreaWidth * 0.03),
                            radius: 10,
                            onTap: onUint(inputValue, isCm, i == 0),
                            text: ["cm", "ft/in"][i],
                            fontSize: safeAreaWidth / 25,
                          ),
                      ],
                    ),
                    const Spacer(),
                    Opacity(
                      opacity: isSave.value ? 1 : 0.3,
                      child: nButton(
                        safeAreaWidth,
                        margin: nSpacing(bottom: safeAreaWidth * 0.03),
                        backGroundColor: Colors.blueAccent,
                        width: safeAreaWidth * 0.9,
                        radius: 15,
                        text: ln.save,
                        textColor: Colors.white,
                        onTap: isSave.value
                            ? onSave(context, ref, isCm, isLoading)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(int? initValue) {
    return () {
      final text = (initValue ?? 0) != 0 ? initValue.toString() : null;
      textController = TextEditingController(text: text);
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onSave(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isCm,
    ValueNotifier<bool> isLoading,
  ) {
    final user = ref.watch(userDataNotifierProvider).value;
    if (user == null) return () => Navigator.pop(context);
    return () async {
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final height = toHeight(textController?.text ?? "", isCm);
      final body = ApiUserUpdateBodyType(id: user.id, height: height);

      if (height == user.height || textController?.text == null) {
        Navigator.pop(context);
        return;
      }
      isLoading.value = true;
      FocusScope.of(context).unfocus();
      final isUpDate = await notifier.upDateUserProfile(context, body);
      if (!context.mounted) return;
      isLoading.value = false;
      if (!isUpDate) nErrorDialog(context);
      Navigator.pop(context);
    };
  }

  void Function()? onUint(
    ValueNotifier<String> inputValue,
    ValueNotifier<bool> isCm,
    bool newIsCm,
  ) {
    return () {
      String newValue = "";
      final value = textController?.text ?? "";
      isCm.value = newIsCm;
      if (newIsCm) newValue = feetInchesToCm(value);
      if (!newIsCm) newValue = cmToFeetInches(int.parse(value));
      textController?.text = newValue;
      inputValue.value = newValue;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  void Function(String)? onChanged(
    ValueNotifier<bool> isCm,
    ValueNotifier<String> inputValue,
    ValueNotifier<bool> isSave,
  ) {
    return (value) {
      String newValue = value;
      isSave.value = getIsSave(value, isCm);

      if (isCm.value) return;
      if (value.length < inputValue.value.length) {
        if (value.length == 1 || value.length == 3) {
          newValue = value.substring(0, value.length - 1);
        }
      } else {
        if (value.length == 1) newValue = "$value'";
        if (value.length == 3) newValue = '$value"';
      }
      textController?.text = newValue;
      inputValue.value = newValue;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  // TextInputType? keyboardType() {
  //   return const TextInputType.numberWithOptions(decimal: false);
  // }

  Color backgroundColor(ValueNotifier<bool> isCm, int index) {
    final isSelect = [isCm.value, !isCm.value][index];
    return isSelect ? blackColor : Colors.transparent;
  }

  Color textColor(ValueNotifier<bool> isCm, int index) {
    final isSelect = [isCm.value, !isCm.value][index];
    return isSelect ? Colors.white : blackColor;
  }

  Color boderColor(ValueNotifier<bool> isCm, int index) {
    final isSelect = [isCm.value, !isCm.value][index];
    return isSelect ? Colors.transparent : blackColor;
  }

  String addDecimalPoint(String original) {
    return "${original.substring(0, 3)}.${original.substring(3)}";
  }

  String feetInchesToCm(String input) {
    try {
      final feetMatch = RegExp(r"(\d+(?:\.\d+)?)'").firstMatch(input);
      final inchesMatch = RegExp(r'(\d+(?:\.\d+)?)"').firstMatch(input);
      final feet = feetMatch != null ? double.parse(feetMatch.group(1)!) : 0;
      final inches =
          inchesMatch != null ? double.parse(inchesMatch.group(1)!) : 0;
      final value = (feet * 12 + inches) * 2.54;
      return value >= 130.0 ? value.toStringAsFixed(0) : "";
    } catch (_) {
      return "";
    }
  }

  bool getIsSave(
    String inputValue,
    ValueNotifier<bool> isCm,
  ) {
    try {
      String value = inputValue;
      if (value.isEmpty) return true;
      if (!isCm.value) value = feetInchesToCm(inputValue);
      return double.parse(value) >= 130.0;
    } catch (e) {
      return false;
    }
  }

  int toHeight(String value, ValueNotifier<bool> isCm) {
    if (value.isEmpty) return 0;
    if (isCm.value) return int.parse(value);
    return int.parse(feetInchesToCm(value));
  }
}
