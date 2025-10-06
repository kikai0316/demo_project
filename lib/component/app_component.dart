import 'package:flutter/material.dart';
import 'package:demo_project/constant/color_constant.dart';

//使いやすいようにまとめました。normal-Spacing=nSpacing
//Padding,Marginの両方の大きさを変えるときに使用する。
EdgeInsetsGeometry nSpacing({
  double? allSize,
  double? xSize,
  double? ySize,
  double left = 0,
  double right = 0,
  double top = 0,
  double bottom = 0,
}) =>
    EdgeInsets.only(
      left: allSize ?? xSize ?? left,
      right: allSize ?? xSize ?? right,
      top: allSize ?? ySize ?? top,
      bottom: allSize ?? ySize ?? bottom,
    );

BoxBorder nBorder({
  Color? color,
  double width = 1,
  bool isOnlyTop = false,
  bool isOnlyBottom = false,
  bool isOnlyRight = false,
  bool isOnlyLeft = false,
}) {
  final defaultColor = Colors.white.withCustomOpacity(0.1);
  if (!isOnlyTop && !isOnlyBottom && !isOnlyRight && !isOnlyLeft) {
    return Border.all(
      strokeAlign: BorderSide.strokeAlignOutside,
      color: color ?? defaultColor,
      width: width,
    );
  } else {
    final BorderSide borderSide =
        BorderSide(color: color ?? defaultColor, width: width);
    return Border(
      top: isOnlyTop ? borderSide : BorderSide.none,
      bottom: isOnlyBottom ? borderSide : BorderSide.none,
      right: isOnlyRight ? borderSide : BorderSide.none,
      left: isOnlyLeft ? borderSide : BorderSide.none,
    );
  }
}

List<BoxShadow> nBoxShadow({
  double shadow = 0.5,
  Color? color,
  Offset offset = Offset.zero,
  double blurRadius = 20.0,
}) {
  final shadowColor = color ?? Colors.black.withCustomOpacity(shadow);
  return [BoxShadow(color: shadowColor, blurRadius: 20, offset: offset)];
}

Gradient nGradation({
  AlignmentGeometry begin = Alignment.topCenter,
  AlignmentGeometry end = Alignment.bottomCenter,
  required List<Color> colors,
  List<double>? stops,
}) =>
    LinearGradient(begin: begin, end: end, colors: colors, stops: stops);

BorderRadiusGeometry nBorderRadius({
  required double radius,
  double zeroRadius = 0,
  bool isOnlyTop = false,
  bool isOnlyBottom = false,
  bool isNotOnlyBottomLeft = false,
  bool isNotOnlyBottomRight = false,
}) {
  Radius circular(double i) => Radius.circular(i);
  if (isNotOnlyBottomRight) {
    return BorderRadius.only(
      topLeft: circular(radius),
      topRight: circular(radius),
      bottomLeft: circular(radius),
      bottomRight: circular(zeroRadius),
    );
  }
  if (isNotOnlyBottomLeft) {
    return BorderRadius.only(
      topLeft: circular(radius),
      topRight: circular(radius),
      bottomLeft: circular(zeroRadius),
      bottomRight: circular(radius),
    );
  }
  return BorderRadius.only(
    topLeft: circular(isOnlyTop ? radius : 0),
    topRight: circular(isOnlyTop ? radius : 0),
    bottomLeft: circular(isOnlyBottom ? radius : 0),
    bottomRight: circular(isOnlyBottom ? radius : 0),
  );
}
