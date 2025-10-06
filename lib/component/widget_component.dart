import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';

//使いやすいようにまとめました。normal-Container=nContainer
Widget nContainer({
  Key? key,
  double? squareSize,
  double? height,
  double? width,
  double maxWidth = double.infinity,
  double maxHeight = double.infinity,
  double minWidth = 0.0,
  double minHeight = 0.0,
  Color? color,
  double radius = 0,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Gradient? gradient,
  AlignmentGeometry? alignment,
  BoxBorder? border,
  Widget? child,
  List<BoxShadow>? boxShadow,
  BorderRadiusGeometry? customBorderRadius,
  DecorationImage? image,
  double? aspectRatio,
  Duration? duration,
  Curve curve = Curves.linear,
  Clip clipBehavior = Clip.none,
}) {
  final container = duration == null
      ? Container(
          key: key,
          margin: margin,
          padding: padding,
          alignment: alignment,
          height: squareSize ?? height,
          width: squareSize ?? width,
          clipBehavior: clipBehavior,
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: customBorderRadius ?? BorderRadius.circular(radius),
            border: border,
            gradient: gradient,
            image: image,
            boxShadow: boxShadow,
          ),
          child: child,
        )
      : AnimatedContainer(
          key: key,
          duration: duration,
          curve: curve,
          margin: margin,
          padding: padding,
          alignment: alignment,
          height: squareSize ?? height,
          width: squareSize ?? width,
          constraints: BoxConstraints(maxWidth: maxWidth),
          decoration: BoxDecoration(
            color: color,
            borderRadius: customBorderRadius ?? BorderRadius.circular(radius),
            border: border,
            gradient: gradient,
            image: image,
            boxShadow: boxShadow,
          ),
          child: child,
        );
  return aspectRatio == null
      ? container
      : AspectRatio(aspectRatio: aspectRatio, child: container);
}

//nContainerを改良して円を作りたいとき用のにまとめました。
Widget nContainerWithCircle({
  double? squareSize,
  Color? color,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Gradient? gradient,
  AlignmentGeometry? alignment,
  BoxBorder? border,
  Widget? child,
  List<BoxShadow>? boxShadow,
  DecorationImage? image,
}) {
  return Container(
    margin: margin,
    padding: padding,
    alignment: alignment,
    height: squareSize,
    width: squareSize,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: border,
      gradient: gradient,
      image: image,
      boxShadow: boxShadow,
    ),
    child: child,
  );
}

//使いやすいようにまとめました。normal-Text=nText
Widget nText(
  String text, {
  required double fontSize,
  double maxWidth = double.infinity,
  Color? color = Colors.white,
  double bold = 700,
  double height = 1,
  int? maxLiune,
  TextAlign textAlign = TextAlign.center,
  List<Shadow>? shadows,
  bool isOverflow = true, //親の大きさにを超えると、...で省略される。
  bool isFit = false, //親の大きさによって大きさを変わるようになる。
  TextDecoration decoration = TextDecoration.none,
  TextOverflow? customOverflow,
  String fontFamily = "Normal",
  double? letterSpacing,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  double boderWidth = 5,
  Color? boderColor,
}) {
  Widget textWidget(Paint? paint) => Text(
        text,
        textAlign: textAlign,
        overflow: customOverflow ?? (isOverflow ? TextOverflow.ellipsis : null),
        maxLines: maxLiune,
        style: TextStyle(
          letterSpacing: letterSpacing,
          height: height,
          decoration: decoration,
          foreground: paint,
          decorationColor: color,
          fontFamily: fontFamily,
          fontVariations: [FontVariation("wght", bold)],
          color: paint == null ? color : null,
          shadows: shadows,
          fontSize: fontSize,
        ),
      );

  if (boderColor != null) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = boderWidth
      ..color = boderColor;
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          textWidget(paint),
          textWidget(null),
        ],
      ),
    );
  }
  return nContainer(
    margin: padding,
    maxWidth: maxWidth,
    child: isFit
        ? FittedBox(fit: BoxFit.fitWidth, child: textWidget(null))
        : textWidget(null),
  );
}

Widget nDiver(
  double? safeAreaWidth, {
  EdgeInsetsGeometry? margin,
  Color? color,
}) {
  return nContainer(
    margin: margin,
    width: safeAreaWidth,
    height: 1,
    color: color ?? (Colors.black.withCustomOpacity(0.2)),
  );
}

Widget nTextFormField({
  TextEditingController? textController,
  required double fontSize, // デフォルトsafeAreaWidth / 30,
  String? hintText,
  Color textColor = Colors.white,
  void Function(String)? onChanged,
  TextAlign textAlign = TextAlign.start,
  int? maxLines,
  int? maxLength,
  bool autofocus = true,
  bool obscureText = false,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.none,
  String? initialValue,
  InputBorder enabledBorder = InputBorder.none,
  InputBorder focusedBorder = InputBorder.none,
  EdgeInsetsGeometry padding = EdgeInsets.zero,
  List<TextInputFormatter>? inputFormatters,
  void Function(String)? onFieldSubmitted,
  double? letterSpacing,
  FocusNode? focusNode,
  String? fontFamily = "Normal",
  double? height = 1,
  Widget? suffix,
  Color? cursorColor,
}) {
  //Expanded大事。
  return Expanded(
    child: Padding(
      padding: padding,
      child: TextFormField(
        keyboardAppearance: Brightness.light,
        cursorOpacityAnimates: false,
        controller: textController,
        initialValue: initialValue,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        obscureText: obscureText,
        maxLines: maxLines,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        autofocus: autofocus,
        maxLength: maxLength,
        textAlign: textAlign,
        onChanged: onChanged,
        cursorColor: cursorColor ?? textColor,
        onFieldSubmitted: onFieldSubmitted,
        style: TextStyle(
          fontFamily: fontFamily,
          fontVariations: const [FontVariation("wght", 500)],
          color: textColor,
          fontSize: fontSize,
          decorationColor: Colors.white.withCustomOpacity(), // 下線の色
          decorationThickness: 3.0,
          letterSpacing: letterSpacing,
          height: height,
        ),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          hintText: hintText,
          suffix: suffix,
          hintStyle: TextStyle(
            fontFamily: fontFamily,
            color: textColor.withCustomOpacity(),
            fontVariations: const [FontVariation("wght", 500)],
            fontSize: fontSize,
            letterSpacing: letterSpacing,
          ),
        ),
      ),
    ),
  );
}

Widget nArrowIcon({
  required double? iconSize,
  EdgeInsetsGeometry? padding,
  double rotation = 0,
  VoidCallback? onTap,
  double opacity = 1,
  Color color = Colors.white,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Transform.rotate(
      angle: rotation * (3.14159265359 / 180),
      child: Opacity(
        opacity: opacity,
        child: nIconButton(
          onTap: onTap,
          squareSize: iconSize,
          imageCustomColor: color,
          iconImage: "black/arrow.png",
        ),
      ),
    ),
  );
}

Widget nBottomSheetScaffold(
  BuildContext context,
  double safeAreaWidth, {
  required double height,
  required Widget body,
  Color backGroundColor = mainBackgroundColor,
  String? title,
  bool isBlackBg = false,
  Widget? rightWidget,
  bool isAppBar = true,
}) {
  return nContainer(
    height: height,
    width: safeAreaWidth,
    color: backGroundColor,
    customBorderRadius: nBorderRadius(radius: 20, isOnlyTop: true),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: isAppBar
          ? nAppBar(
              context,
              safeAreaWidth,
              title: title,
              leftIconType: AppBarLeftIconType.cancel,
              backgroundColor: Colors.transparent,
              isBlackBg: isBlackBg,
              rightWidget: rightWidget,
              sideIconWidth: safeAreaWidth * 0.15,
            )
          : null,
      body: body,
    ),
  );
}

Widget nIcon(
  IconData? icon, {
  Color color = Colors.white,
  double? size,
  List<Shadow>? shadows,
  EdgeInsetsGeometry? padding,
}) {
  return Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Icon(icon, color: color, size: size, shadows: shadows),
  );
}

class CustomFadeIn extends StatefulWidget {
  final Duration? duration;
  final Widget? child;

  const CustomFadeIn({super.key, this.duration, this.child});

  @override
  State<CustomFadeIn> createState() => _CustomFadeIn();
}

class _CustomFadeIn extends State<CustomFadeIn> {
  bool _hasAnimated = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (!_hasAnimated) {
      _hasAnimated = true;
      Future.delayed(const Duration(milliseconds: 10), () {
        if (mounted) setState(() => _isVisible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      opacity: _isVisible ? 1.0 : 0.0,
      child: widget.child,
    );
  }
}

Widget nSliverSpacer(double? height) {
  return SliverToBoxAdapter(child: SizedBox(height: height));
}
