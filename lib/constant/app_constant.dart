import 'package:flutter/material.dart';

const mainAspectRatio = 9 / 14.5;
const mainAspectRatioInverse = 14.5 / 9;

double safeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
}
