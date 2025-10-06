import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

Widget matchCardContainer(
  BoxConstraints constraints, {
  required List<UserType> users,
  required List<Widget> children,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return nContainer(
    margin: nSpacing(top: safeAreaHeight * 0.05),
    height: safeAreaHeight * 0.26,
    width: safeAreaWidth * 0.5,
    // color: Colors.red,
    child: Stack(children: children),
  );
}

Widget matchCardWidget(
  BoxConstraints constraints,
  int itemIndex,
  List<UserPreviewType> users,
  ValueNotifier<int> animationState,
) {
  final startAlign = [
    const Alignment(-0.85, -0.85),
    const Alignment(0.85, 0.85),
  ];
  final align = [Alignment.topLeft, Alignment.bottomRight][itemIndex];
  return AnimatedAlign(
    duration: const Duration(milliseconds: 200),
    alignment: animationState.value == 0 ? startAlign[itemIndex] : align,
    child: AnimatedRotation(
      duration: const Duration(milliseconds: 100),
      turns: [-0.025, 0.025][itemIndex],
      child: CustomNetworkImageWidegt(
        safeAreaWidth: constraints.maxWidth,
        url: users[itemIndex].profileImages.first,
        radius: 20,
        height: constraints.maxHeight * 0.34,
        boxShadow: nBoxShadow(shadow: 0.2),
      ),
    ),
  );
}

Widget favoriteIcon(
  BoxConstraints constraints,
  ValueNotifier<int> animationState,
) {
  final safeAreaWidth = constraints.maxWidth;
  return Align(
    child: AnimatedRotation(
      duration: const Duration(milliseconds: 100),
      turns: animationState.value == 0 ? 0 : 1.05,
      child: nContainerWithCircle(
        color: Colors.white,
        padding: nSpacing(allSize: safeAreaWidth * 0.04),
        child: nIcon(
          Icons.favorite_rounded,
          color: Colors.blueAccent,
          size: safeAreaWidth / 13,
        ),
      ),
    ),
  );
}

Widget cancelIconWidget(
  BoxConstraints constraints, {
  required VoidCallback onTap,
}) {
  final safeAreaWidth = constraints.maxWidth;
  return Align(
    alignment: Alignment.centerLeft,
    child: nIconButton(
      margin: nSpacing(left: safeAreaWidth * 0.05),
      backGroundColor: Colors.white,
      squareSize: safeAreaWidth * 0.14,
      iconImage: "black/cancel.png",
      iconSize: safeAreaWidth / 25,
      boxShadow: nBoxShadow(shadow: 0.1),
      onTap: onTap,
    ),
  );
}

Widget talkIconWidget(
  BoxConstraints constraints, {
  required VoidCallback onTap,
}) {
  final safeAreaHeight = constraints.maxHeight;
  final safeAreaWidth = constraints.maxWidth;
  return nIconButton(
    onTap: onTap,
    margin: nSpacing(bottom: safeAreaHeight * 0.03),
    squareSize: safeAreaWidth * 0.25,
    backGroundColor: Colors.white,
    iconSize: safeAreaWidth / 11,
    iconImage: "black/talk.png",
    boxShadow: nBoxShadow(shadow: 0.05),
    imageCustomColor: Colors.blueAccent,
  );
}
