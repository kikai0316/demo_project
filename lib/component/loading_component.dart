import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

Widget loadinPage(
  double safeAreaWidth, {
  bool? isLoading,
  String? text,
  double radius = 0,
}) {
  return Visibility(
    visible: isLoading ?? true,
    child: nContainer(
      alignment: Alignment.center,
      color: Colors.black.withCustomOpacity(0.5),
      height: double.infinity,
      radius: radius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nIndicatorWidget(
            color: Colors.white,
            size: safeAreaWidth * 0.03,
          ),
        ],
      ),
    ),
  );
}

Widget nIndicatorWidget({
  required double size, // ?? safeAreaWidth * 0.03
  EdgeInsetsGeometry? padding,
  Color? color,
}) {
  return Padding(
    padding: padding ?? nSpacing(),
    child: CupertinoActivityIndicator(
      color: color ?? Colors.white,
      radius: size,
    ),
  );
}

Widget nSkeletonLoadingWidget({
  Widget? child,
  Color? highlightColor,
  double colorOpacity = 0.3,
  bool isLoading = true,
  double radius = 0,
  EdgeInsetsGeometry margin = EdgeInsets.zero,
  BorderRadiusGeometry? borderRadius,
}) {
  return Padding(
    padding: margin,
    child: isLoading
        ? ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
            child: Shimmer(
              color: highlightColor ?? Colors.white.withCustomOpacity(0.08),
              colorOpacity: colorOpacity,
              duration: const Duration(milliseconds: 2000),
              child: child ?? const SizedBox.shrink(),
            ),
          )
        : child,
  );
}
