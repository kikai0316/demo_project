import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';

Widget codeSentWidget(
  BuildContext context,
  double safeAreaWidth,
  Map<String, dynamic>? selectPhoneData,
  bool isAdmin,
) {
  final ln = AppLocalizations.of(context)!;
  final phoneNumber = selectPhoneData!["international"] as String? ?? "";
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.05),
    child: nText(
      ln.codeSentTo.replaceAll('@', !isAdmin ? phoneNumber : "Admin"),
      fontSize: safeAreaWidth / 25,
      color: Colors.black.withCustomOpacity(0.5),
    ),
  );
}

Widget resendCodeWidget(
  BuildContext context,
  double safeAreaWidth, {
  required bool isLoading,
  VoidCallback? onTap,
}) {
  final ln = AppLocalizations.of(context)!;
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.05),
    child: !isLoading
        ? nTextButton(
            safeAreaWidth,
            fontSize: safeAreaWidth / 24,
            text: ln.resendCode,
            onTap: !isLoading ? onTap : null,
          )
        : nIndicatorWidget(size: safeAreaWidth / 35),
  );
}

Widget verifyInputItem(
  double safeAreaWidth, {
  Color textColor = Colors.black,
  void Function(String)? onChanged,
  TextEditingController? textController,
}) {
  return Row(
    children: [
      nTextFormField(
        padding: nSpacing(top: safeAreaWidth * 0.1),
        textAlign: TextAlign.center,
        maxLines: 1,
        maxLength: 6,
        keyboardType: TextInputType.number,
        textController: textController,
        hintText: "・・・・・・",
        fontSize: safeAreaWidth / 11,
        letterSpacing: safeAreaWidth * 0.03,
        textColor: textColor,
        onChanged: onChanged,
      ),
    ],
  );
}
