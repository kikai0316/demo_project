import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';

Widget navigationBaseWidget(
  double safeAreaHeight, {
  Color? color,
  required List<Widget> children,
}) {
  return nContainer(
    color: color,
    height: safeAreaHeight * 0.09,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget navigationItemWidget(
  BoxConstraints constraints, {
  required String icon,
  required VoidCallback? onTap,
}) {
  // final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  final isTalk = icon == "talk.png";
  return Opacity(
    opacity: onTap == null ? 1 : 0.3,
    child: nIconButton(
      vibration: () => HapticFeedback.mediumImpact(),
      onTap: onTap,
      padding: nSpacing(allSize: safeAreaHeight * 0.01),
      iconImage: "black/$icon",
      imageCustomColor: Colors.white,
      iconSize: safeAreaHeight * (isTalk ? 0.04 : 0.035),
    ),
  );
}
