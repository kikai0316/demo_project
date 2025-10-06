import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

Widget nListItem(
  double safeAreaWidth, {
  required String mainText,
  String? opacityText,
  String? smallOpacityText,
  String? smallText,
  Widget? rightWidget,
  Widget? leftWidget,
  Widget? customMainText,
  Widget? customSubText,
  double? imageSize,
  String? networkImgData,
  String? assetImgData,
  Uint8List? memoryImgData,
  double? itemPadding,
  VoidCallback? onTap,
  EdgeInsetsGeometry? padding,
  double iconOpacty = 1,
  Color textColor = Colors.white,
  double textheight = 1,
  BoxBorder? border,
  double? customFontSize,
  bool isOverflow = true,
}) {
  Widget textWidget(
    String text, {
    double? padding,
    double? fontSize,
    double opacity = 1,
  }) {
    return Padding(
      padding: nSpacing(top: padding ?? 0),
      child: nText(
        text,
        color: textColor.withCustomOpacity(opacity),
        textAlign: TextAlign.left,
        isFit: isOverflow,
        isOverflow: isOverflow,
        bold: 800,
        letterSpacing: 1.5,
        height: textheight,
        fontSize: customFontSize ?? fontSize ?? safeAreaWidth / 26,
      ),
    );
  }

  return nContainer(
    border: border,
    child: Padding(
      padding: padding ??
          nSpacing(xSize: safeAreaWidth * 0.05, ySize: safeAreaWidth * 0.02),
      child: CustomAnimatedOpacityButton(
        onTap: onTap,
        vibration: onTap != null ? () => HapticFeedback.selectionClick() : null,
        child: nContainer(
          color: Colors.transparent,
          child: Row(
            children: [
              leftWidget ??
                  Opacity(
                    opacity: iconOpacty,
                    child: networkImgData == null
                        ? nContainer(
                            squareSize: imageSize ?? safeAreaWidth * 0.16,
                            radius: 50,
                            image: decorationChangeImage(
                              network: networkImgData,
                              asset: assetImgData,
                              memory: memoryImgData,
                            ),
                          )
                        : CustomNetworkImageWidegt(
                            safeAreaWidth: safeAreaWidth,
                            url: networkImgData,
                            radius: 100,
                            width: imageSize ?? safeAreaWidth * 0.16,
                            height: imageSize ?? safeAreaWidth * 0.16,
                          ),
                  ),
              Expanded(
                child: Padding(
                  padding: nSpacing(xSize: itemPadding ?? safeAreaWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customMainText ?? textWidget(mainText),
                      if (smallText?.isNotEmpty ?? false)
                        textWidget(
                          padding: safeAreaWidth * 0.01,
                          smallText ?? "",
                          fontSize: safeAreaWidth / 32,
                        ),
                      if (opacityText?.isNotEmpty ?? false)
                        textWidget(
                          padding: safeAreaWidth * 0.01,
                          opacityText ?? "",
                          opacity: 0.3,
                          fontSize: safeAreaWidth / 28,
                        ),
                      if (smallOpacityText?.isNotEmpty ?? false)
                        textWidget(
                          padding: safeAreaWidth * 0.01,
                          smallOpacityText ?? "",
                          fontSize: safeAreaWidth / 28,
                          opacity: 0.5,
                        ),
                      customSubText ?? const SizedBox(),
                    ],
                  ),
                ),
              ),
              rightWidget ?? const SizedBox(),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget accountListItem(
  double safeAreaWidth, {
  String? mainText,
  String? networkImg,
  String? assetImg,
  Uint8List? memoryImg,
  String? opacityText,
  String? smallText,
  String? smallOpacityText,
  Widget? rightWidget,
  VoidCallback? onTap,
  EdgeInsetsGeometry? padding,
  Color textColor = Colors.white,
  double textheight = 1,
  bool isOverflow = true,
  double? customFontSize,
  Widget? customSubText,
  Widget? customMainText,
}) {
  return nListItem(
    safeAreaWidth,
    onTap: onTap,
    mainText: "",
    networkImgData: networkImg,
    memoryImgData: memoryImg,
    smallText: smallText,
    imageSize: safeAreaWidth * 0.14,
    opacityText: opacityText,
    smallOpacityText: smallOpacityText,
    rightWidget: rightWidget,
    padding: padding,
    textColor: textColor,
    textheight: textheight,
    isOverflow: isOverflow,
    customFontSize: customFontSize,
    customSubText: customSubText,
    customMainText: customMainText ??
        nText(
          mainText ?? "",
          letterSpacing: 1.2,
          color: textColor,
          fontSize: safeAreaWidth / 25,
        ),
  );
}
