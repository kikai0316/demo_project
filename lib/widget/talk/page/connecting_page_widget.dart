import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

Widget connectImagesItems(
  double safeAreaWidth,
  UserPreviewType? user,
  int itemIndex,
) {
  final padding = safeAreaWidth * 0.04;
  return Transform.translate(
    offset: Offset([padding, -padding][itemIndex], 0),
    child: nContainerWithCircle(
      border: nBorder(color: Colors.black.withCustomOpacity(0.2), width: 2),
      child: CustomNetworkImageWidegt(
        safeAreaWidth: safeAreaWidth,
        height: safeAreaWidth * 0.2,
        width: safeAreaWidth * 0.2,
        url: user?.profileImages.first ?? "",
        radius: 100,
      ),
    ),
  );
}

Widget bgConnectingAnimation(
  double safeAreaHeight,
  ValueNotifier<bool> isConnect,
) {
  const asset = "assets/animations/loading_effect.json";
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: nSpacing(top: safeAreaHeight * 0.15),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isConnect.value ? 0 : 0.03,
        child: Transform.scale(
          scale: 7,
          child: Lottie.asset(asset),
        ),
      ),
    ),
  );
}

Widget checkAnimation() {
  const asset = "assets/animations/check.json";
  return Transform.scale(
    scale: 1.55,
    child: Lottie.asset(asset, repeat: false),
  );
}
