import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';

//推したら一瞬薄くなるアニメーション付きボタン
class CustomAnimatedOpacityButton extends HookConsumerWidget {
  const CustomAnimatedOpacityButton({
    super.key,
    required this.onTap,
    required this.child,
    this.onLongPress,
    this.opacity,
    this.vibration,
  });
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? opacity;
  final Future<void> Function()? vibration;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    return GestureDetector(
      onTap: onTap != null
          ? () async {
              isTapEvent.value = false;
              if (vibration != null) {
                await vibration!();
              }
              onTap?.call();
            }
          : null,
      onLongPress: onLongPress,
      onTapDown: onTap != null ? (_) => isTapEvent.value = true : null,
      onTapCancel: onTap != null ? () => isTapEvent.value = false : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: isTapEvent.value ? 0.5 : 1,
        child: child,
      ),
    );
  }
}

class CustomAnimatedButton extends HookConsumerWidget {
  const CustomAnimatedButton({
    super.key,
    required this.onTap,
    required this.child,
    this.onLongPress,
    this.vibration,
  });
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Future<void> Function()? vibration;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    return GestureDetector(
      onTap: onTap != null
          ? () async {
              isTapEvent.value = false;
              if (vibration != null) {
                await vibration!();
              }
              onTap?.call();
            }
          : null,
      onLongPress: onLongPress,
      onTapDown: onTap != null ? (_) => isTapEvent.value = true : null,
      onTapCancel: onTap != null ? () => isTapEvent.value = false : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: isTapEvent.value ? 0.9 : 1,
        child: child,
      ),
    );
  }
}

Widget nButton(
  double safeAreaWidth, {
  required VoidCallback? onTap,
  String? text,
  Color? backGroundColor,
  Color textColor = Colors.black,
  double? squareSize,
  double? height,
  double? width,
  double? fontSize,
  double radius = 50,
  Widget? customWidget,
  BoxBorder? border,
  EdgeInsetsGeometry? margin,
  double bold = 800,
  bool isFit = false,
  Gradient? gradient,
  List<BoxShadow>? boxShadow,
}) {
  return CustomAnimatedButton(
    onTap: onTap,
    vibration: () => HapticFeedback.mediumImpact(),
    child: nContainer(
      margin: margin,
      alignment: Alignment.center,
      height: squareSize ?? height ?? (isFit ? null : safeAreaWidth * 0.16),
      width: squareSize ?? width ?? safeAreaWidth * 0.8,
      color: backGroundColor,
      gradient: gradient,
      border: border,
      radius: radius,
      boxShadow: boxShadow,
      child: customWidget ??
          nText(
            text ?? "",
            color: textColor,
            bold: bold,
            fontSize: fontSize ?? safeAreaWidth / 25,
          ),
    ),
  );
}

Widget nIconButton({
  VoidCallback? onTap,
  Color? backGroundColor = Colors.transparent,
  Color iconColor = Colors.white,
  Color? imageCustomColor,
  IconData? iconData,
  String? iconImage,
  double? iconSize,
  double? backgroundSize,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  bool isVibration = true,
  double radius = 100,
  BoxBorder? border,
  Widget? withTextWidget,
  bool isTextLeft = false,
  Future<void> Function()? vibration,
  double minWidth = 0.0,
  double? squareSize,
  Widget? bottomText,
  List<BoxShadow>? boxShadow,
  double? height,
  double? width,
  Gradient? gradient,
}) {
  final isLeftTextWidget = isTextLeft && withTextWidget != null;
  final isRightTextWidget = !isTextLeft && withTextWidget != null;
  final assetIcon = "assets/icon/$iconImage";
  return CustomAnimatedButton(
    onTap: onTap,
    vibration: vibration,
    child: nContainer(
      margin: margin,
      minWidth: minWidth,
      height: height ?? squareSize,
      width: width ?? squareSize,
      padding: padding,
      border: border,
      boxShadow: boxShadow,
      color: backGroundColor,
      gradient: gradient,
      radius: radius,
      child: bottomText == null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLeftTextWidget) withTextWidget,
                if (iconData != null)
                  Icon(iconData, size: iconSize, color: iconColor),
                if (iconImage != null)
                  Image.asset(
                    assetIcon,
                    fit: BoxFit.cover,
                    color: imageCustomColor,
                    width: iconSize,
                    height: iconSize,
                  ),
                // nContainer(
                //   squareSize: iconSize,
                //   image: DecorationImage(
                //     image: AssetImage(assetIcon),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                if (isRightTextWidget) withTextWidget,
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconData != null)
                  Icon(iconData, size: iconSize, color: iconColor),
                if (iconImage != null)
                  nContainer(squareSize: iconSize, image: assetImg(assetIcon)),
                bottomText,
              ],
            ),
    ),
  );
}

Widget nTextButton(
  double safeAreaWidth, {
  required VoidCallback? onTap,
  required String text,
  required double fontSize,
  Future<void> Function()? vibration,
  Color color = Colors.blue,
  bool isUnderline = false,
  EdgeInsetsGeometry? margin,
  Color backgroundColor = Colors.transparent,
  EdgeInsetsGeometry? padding,
  double radius = 0,
  BoxBorder? border,
}) {
  return CustomAnimatedButton(
    onTap: onTap,
    vibration: vibration ?? () => HapticFeedback.heavyImpact(),
    child: nContainer(
      padding: padding ?? nSpacing(allSize: safeAreaWidth * 0.01),
      radius: radius,
      margin: margin,
      color: backgroundColor,
      border: border,
      child: nText(
        text,
        fontSize: fontSize,
        decoration:
            isUnderline ? TextDecoration.underline : TextDecoration.none,
        color: color,
      ),
    ),
  );
}

// Widget nPopupMenuButton(
//   BuildContext context, {
//   required Widget child,
//   required List<MenuItemType> items,
//   required void Function(int) onSelected,
// }) {
//   final itemPadding = EdgeInsets.symmetric(vertical: safeAreaWidth * 0.025);

//   return Theme(
//     data: Theme.of(context).copyWith(
//       highlightColor: Colors.transparent,
//       splashColor: Colors.transparent,
//       dividerTheme: DividerThemeData(
//         thickness: 0.5,
//         color: Colors.black.withCustomOpacity(),
//         space: 0,
//       ),
//     ),
//     child: PopupMenuButton<int>(
//       offset: Offset(0, safeAreaWidth * 0.02),
//       surfaceTintColor: Colors.transparent,
//       color: subBlackColor,
//       elevation: 0,
//       onSelected: onSelected,
//       position: PopupMenuPosition.under,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       menuPadding: EdgeInsets.zero,
//       itemBuilder: (context) => [
//         for (int index = 0; index < items.length; index++) ...[
//           PopupMenuItem(
//             height: safeAreaWidth * 0.01,
//             value: index,
//             child: Padding(
//               padding: itemPadding,
//               child: Row(
//                 children: [
//                   nContainer(
//                     alignment: Alignment.centerLeft,
//                     width: safeAreaWidth * 0.06,
//                     child: items[index].isSelect == true
//                         ? nIcon(Icons.check, size: safeAreaWidth / 25)
//                         : null,
//                   ),
//                   nText(
//                     items[index].itemName,
//                     fontSize: safeAreaWidth / 25,
//                     bold: 400,
//                   ),
//                   const Spacer(),
//                   nIcon(items[index].itemIcon),
//                 ],
//               ),
//             ),
//           ),
//           if (index != items.length - 1) const PopupMenuDivider(height: 1),
//         ],
//       ],
//       child: GestureDetector(onLongPress: () {}, child: child),
//     ),
//   );
// }
