import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

PreferredSizeWidget? chatPageAppBar(
  BuildContext context,
  double safeAreaWidth,
  ValueNotifier<String> timerStr, {
  required void Function()? onEnd,
  required void Function()? onMenu,
}) {
  final ln = AppLocalizations.of(context)!;
  final isEndless = timerStr.value == ln.unlimited;
  return nAppBar(
    context,
    safeAreaWidth,
    backgroundColor: const Color(0xFF94D9FE),
    sideIconWidth: safeAreaWidth * 0.45,
    leftIconType: AppBarLeftIconType.none,
    leftWidget: Row(
      children: [
        nContainer(
          squareSize: safeAreaWidth * 0.07,
          margin: nSpacing(right: safeAreaWidth * 0.02),
          image: assetImg("icon/black/timer.png"),
        ),
        Expanded(
          child: nContainer(
            alignment: Alignment.centerLeft,
            child: nText(
              timerStr.value,
              fontSize: safeAreaWidth / (isEndless ? 20 : 15),
              color: blackColor,
              bold: 900,
              isFit: true,
            ),
          ),
        ),
      ],
    ),
    rightWidget: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        nTextButton(
          safeAreaWidth,
          backgroundColor: redColor,
          onTap: onEnd,
          text: ln.end,
          color: Colors.white,
          fontSize: safeAreaWidth / 25,
          padding: nSpacing(
            ySize: safeAreaWidth * 0.03,
            xSize: safeAreaWidth * 0.05,
          ),
          radius: 50,
        ),
        nIconButton(
          onTap: onMenu,
          margin: nSpacing(left: safeAreaWidth * 0.03),
          backGroundColor: Colors.white,
          iconData: Icons.more_horiz,
          padding: nSpacing(allSize: safeAreaWidth * 0.015),
          iconSize: safeAreaWidth / 13,
          iconColor: Colors.blue,
        ),
      ],
    ),
  );
}

Widget messageTextFiled(
  BoxConstraints constraints, {
  required FocusNode focusNode,
  required UserPreviewType myData,
  TextEditingController? textController,
  void Function(String)? onChanged,
  VoidCallback? onSend,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return nContainer(
    padding: nSpacing(allSize: safeAreaWidth * 0.03),
    child: Row(
      children: [
        CustomNetworkImageWidegt(
          safeAreaWidth: safeAreaWidth,
          height: safeAreaHeight * 0.05,
          width: safeAreaHeight * 0.05,
          boxShadow: nBoxShadow(shadow: 0.1),
          url: myData.profileImages.first,
          radius: 100,
        ),
        Expanded(
          child: nContainer(
            margin: nSpacing(xSize: safeAreaWidth * 0.03),
            maxHeight: safeAreaHeight * 0.1,
            color: Colors.white.withCustomOpacity(1),
            border: nBorder(color: Colors.black.withCustomOpacity(0.1)),
            radius: 15,
            child: Row(
              children: [
                nTextFormField(
                  textController: textController,
                  padding: nSpacing(xSize: safeAreaWidth * 0.03),
                  fontSize: safeAreaWidth / 23,
                  focusNode: focusNode,
                  autofocus: false,
                  onChanged: onChanged,
                  textColor: blackColor,
                  cursorColor: Colors.blueAccent,
                  hintText: "Aa",
                  height: 1.3,
                ),
              ],
            ),
          ),
        ),
        nIconButton(
          iconImage: "black/send.png",
          iconSize: safeAreaWidth / 13,
          imageCustomColor: Colors.blueAccent,
          onTap: onSend,
        ),
      ],
    ),
  );
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// 上記に付随する関数及びWidget
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
