import 'package:flutter/material.dart';

const mainBackgroundColor = Color(0xFFFBF8F1);
const subBackgroundColor = Color(0xFF191919);
const pinkColor = Color(0xFFFFCFEA);
const pinkColor2 = Color(0xFFFFF5F9);
const blueColor = Color(0xFF9cdbfe);
const blueColor3 = Color(0xFF04fcfc);
const blueColor2 = Color(0xFFEBFEF5);
const blueColor4 = Color.fromARGB(255, 75, 147, 255);
const blackColor = Color(0xFF1C1C1B);
const redColor = Color(0xFFF13249);

List<Color> fadeGradation([
  Alignment aligment = Alignment.topCenter,
  double opacity = 1,
  Color color = Colors.black,
]) {
  final color_1 = color.withCustomOpacity(opacity);
  final color_2 = color.withCustomOpacity(0);
  if (aligment == Alignment.topCenter) return [color_1, color_2];
  return [color_2, color_1];
}

Gradient mainGradation({
  Alignment begin = FractionalOffset.topCenter,
  Alignment end = FractionalOffset.bottomCenter,
}) {
  final color = [pinkColor, pinkColor2];
  const stops = <double>[0.3, 1];
  return LinearGradient(begin: begin, end: end, colors: color, stops: stops);
}

//.withOpacityより、withAlphaが推奨され長くなったので、オリジナルでwithOpacityを作成。(デフォルト:0.3)
extension CustomOpacityColor on Color {
  Color withCustomOpacity([double? opacity]) {
    final double opacityData = opacity ?? 0.3;
    assert(
      opacityData >= 0.0 && opacityData <= 1.0,
      'Opacity value must be between 0.0 and 1.0',
    );
    return withAlpha((opacityData * 255).toInt());
  }
}
