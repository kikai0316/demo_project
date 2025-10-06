import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';

Widget phoneNumberInputItem(
  double safeAreaWidth, {
  required String country,
  required VoidCallback? onCountry,
  void Function(String)? onChanged,
  TextEditingController? textController,
}) {
  final boderColor = Colors.black.withCustomOpacity();
  final borderSide = BorderSide(color: boderColor, width: 2);

  return Padding(
    padding: nSpacing(
      top: safeAreaWidth * 0.15,
      bottom: safeAreaWidth * 0.05,
    ),
    child: Row(
      children: [
        CustomAnimatedButton(
          onTap: onCountry,
          child: nContainer(
            radius: 10,
            margin: nSpacing(right: safeAreaWidth * 0.05),
            padding: nSpacing(
              xSize: safeAreaWidth * 0.025,
              ySize: safeAreaWidth * 0.03,
            ),
            border: nBorder(width: 2, color: boderColor),
            child: nText(
              country,
              fontSize: safeAreaWidth / 20,
              color: blackColor,
            ),
          ),
        ),
        nTextFormField(
          fontSize: safeAreaWidth / 15,
          keyboardType: TextInputType.number,
          hintText: "",
          textController: textController,
          textColor: blackColor,
          maxLines: 1,
          enabledBorder: UnderlineInputBorder(borderSide: borderSide),
          focusedBorder: UnderlineInputBorder(borderSide: borderSide),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget privacyTextItem(
  double safeAreaWidth, {
  required String lang,
  required void Function()? onPrivacy,
  required void Function()? onTerms,
}) {
  InlineSpan textWidget(
    String text, {
    bool isUnderline = false,
    GestureRecognizer? onTap,
  }) {
    return TextSpan(
      text: text,
      recognizer: onTap,
      style: TextStyle(
        fontFamily: "Normal",
        color: isUnderline ? Colors.blue : blackColor,
        fontSize: safeAreaWidth / 29,
        height: 1.5,
        decoration: isUnderline ? TextDecoration.underline : null,
        fontVariations: const [FontVariation("wght", 700)],
      ),
    );
  }

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      //言語
      children: lang == "jp"
          ? [
              textWidget('この操作を行うと、私たちの '),
              textWidget(
                '利用規約',
                isUnderline: true,
                onTap: TapGestureRecognizer()..onTap = onTerms,
              ),
              textWidget(' と\n'),
              textWidget(
                'プライバシーポリシー',
                isUnderline: true,
                onTap: TapGestureRecognizer()..onTap = onPrivacy,
              ),
              textWidget(' に同意したことになります。'),
            ]
          : [
              textWidget('By performing this action, you agree to our\n'),
              textWidget(
                'Terms of Service',
                isUnderline: true,
                onTap: TapGestureRecognizer()..onTap = onTerms,
              ),
              textWidget(' and '),
              textWidget(
                'Privacy Policy',
                isUnderline: true,
                onTap: TapGestureRecognizer()..onTap = onPrivacy,
              ),
              textWidget('.'),
            ],
    ),
  );
}

Widget indicatorButton(
  double safeAreaWidth, {
  String? text,
  required bool isValidData,
  required bool isLoading,
  required VoidCallback? onTap,
}) {
  return nButton(
    safeAreaWidth,
    margin: nSpacing(ySize: safeAreaWidth * 0.03),
    fontSize: safeAreaWidth / 23,
    backGroundColor: Colors.blueAccent.withCustomOpacity(isValidData ? 1 : 0.3),
    customWidget: isLoading
        ? nIndicatorWidget(size: safeAreaWidth / 35, color: Colors.black)
        : null,
    width: safeAreaWidth * 1,
    text: text,
    textColor: Colors.white,
    onTap: isValidData && !isLoading ? onTap : null,
  );
}
