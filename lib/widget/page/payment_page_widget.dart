import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/subscription_model.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';

Widget paymentAppBar(BuildContext context, BoxConstraints constraints) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  final shadowColor = blueColor4.withCustomOpacity(0.1);
  return nContainer(
    width: double.infinity,
    boxShadow: nBoxShadow(color: shadowColor, offset: const Offset(0, 20)),
    child: ClipPath(
      clipper: _BottomBulgeRoundedOutClipper(bulge: 30),
      child: nContainer(
        alignment: Alignment.center,
        height: safeAreaHeight * 0.18,
        width: double.infinity,
        padding: nSpacing(top: safeAreaWidth * 0.04),
        color: blueColor4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                nContainer(
                  alignment: Alignment.bottomCenter,
                  squareSize: safeAreaWidth * 0.25,
                  image: assetImg("image/logo2.png"),
                ),
                proLogoWidget(
                  safeAreaHeight,
                  margin: nSpacing(left: safeAreaWidth * 0.01),
                ),
              ],
            ),
            _cancelButton(context, safeAreaWidth),
          ],
        ),
      ),
    ),
  );
}

SliverToBoxAdapter paymentTitleTextWidget(
  BuildContext context,
  BoxConstraints constraints, [
  bool isTitle = true,
]) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return SliverToBoxAdapter(
    child: nText(
      isTitle ? ln.proUnlockLimits : ln.upgradeUnlockAllLimits,
      padding: nSpacing(top: safeAreaHeight * (isTitle ? 0.2 : 0.015)),
      color: blackColor.withCustomOpacity(isTitle ? 1 : 0.5),
      fontSize: safeAreaWidth / (isTitle ? 15 : 25),
      bold: isTitle ? 900 : 800,
    ),
  );
}

SliverToBoxAdapter planContentsWidget(
  BuildContext context,
  BoxConstraints constraints,
) {
  final safeAreaWidth = constraints.maxWidth;

  return SliverToBoxAdapter(
    child: nContainer(
      margin: nSpacing(
        top: safeAreaWidth * 0.05,
        bottom: safeAreaWidth * 0.03,
        xSize: safeAreaWidth * 0.05,
      ),
      padding: nSpacing(
        ySize: safeAreaWidth * 0.02,
        xSize: safeAreaWidth * 0.08,
      ),
      radius: 20,
      color: blueColor4.withCustomOpacity(0.2),
      border: nBorder(color: blueColor4, width: 2),
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) _planContent(context, constraints, i),
        ],
      ),
    ),
  );
}

SliverToBoxAdapter planWidget(
  BuildContext context,
  BoxConstraints constraints,
  SubscriptionItemType plan,
  SubscriptionItemType? monthPlan,
  void Function(SubscriptionItemType)? onTap,
) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = constraints.maxWidth;
  final padding = safeAreaWidth * 0.05;
  final color = blackColor.withCustomOpacity(0.5);
  final salePrice = plan.toSalePrice(context, monthPlan);
  return SliverToBoxAdapter(
    child: CustomAnimatedButton(
      onTap: () => onTap?.call(plan),
      vibration: () => HapticFeedback.selectionClick(),
      child: nContainer(
        margin: nSpacing(top: safeAreaWidth * 0.04, xSize: padding),
        radius: 20,
        color: Colors.white,
        border: nBorder(color: Colors.blueAccent, width: 2),
        child: Column(
          children: [
            Row(
              children: [
                nContainer(
                  width: safeAreaWidth * 0.33,
                  padding: nSpacing(ySize: safeAreaWidth * 0.01),
                  color: Colors.blue,
                  customBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(10),
                  ),
                  child: nText(
                    ln.freeFor1Week,
                    fontSize: safeAreaWidth / 35,
                    fontFamily: "normal",
                    height: 1.5,
                    bold: 900,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: nText(
                    ln.subscriptionNotice,
                    fontSize: safeAreaWidth / 45,
                    padding: nSpacing(
                      left: safeAreaWidth * 0.01,
                    ),
                    color: color.withCustomOpacity(0.3),
                  ),
                ),
              ],
            ),
            Padding(
              padding: nSpacing(
                top: safeAreaWidth * 0.02,
                bottom: safeAreaWidth * 0.04,
                xSize: safeAreaWidth * 0.05,
              ),
              child: Row(
                children: [
                  SizedBox(width: safeAreaWidth * 0.02),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (salePrice != null)
                        nText(
                          salePrice,
                          fontSize: safeAreaWidth / 35,
                          color: Colors.green,
                          bold: 900,
                        ),
                      Row(
                        children: [
                          for (int i = 0; i < 2; i++)
                            nText(
                              [plan.months.toString(), ln.months][i],
                              fontSize: safeAreaWidth / [12, 25][i],
                              color: blackColor,
                              padding: nSpacing(
                                top: [0.0, safeAreaWidth * 0.02][i],
                                left: [0.0, safeAreaWidth * 0.01][i],
                              ),
                              bold: [900.0, 500.0][i],
                            ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 2; i++)
                          Align(
                            alignment: Alignment.centerRight,
                            child: nText(
                              [
                                plan.priceStr,
                                plan.toPricePerWeek(context),
                              ][i],
                              fontSize: safeAreaWidth / [20, 22][i],
                              color: i == 1 ? Colors.blueAccent : color,
                              padding: nSpacing(
                                ySize: i == 1 ? safeAreaWidth * 0.01 : 0,
                              ),
                              bold: 800.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

SliverToBoxAdapter detailsTextWidget(
  BoxConstraints constraints,
  String text,
  bool isTitle,
) {
  final safeAreaWidth = constraints.maxWidth;

  return SliverToBoxAdapter(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: nSpacing(xSize: safeAreaWidth * 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isTitle)
              Align(
                alignment: Alignment.topLeft,
                child: nText(
                  "-",
                  fontSize: safeAreaWidth / 30,
                  color: blackColor.withCustomOpacity(0.5),
                  padding: nSpacing(
                    right: safeAreaWidth * 0.02,
                    top: safeAreaWidth * 0.01,
                  ),
                  bold: 500,
                ),
              ),
            Expanded(
              child: nText(
                text,
                fontSize: safeAreaWidth / (isTitle ? 30 : 35),
                color: blackColor.withCustomOpacity(isTitle ? 1 : 0.5),
                padding: nSpacing(
                  top: safeAreaWidth * (isTitle ? 0.03 : 0.015),
                ),
                bold: isTitle ? 800 : 500,
                textAlign: TextAlign.start,
                height: 1.5,
                isOverflow: false,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

SliverToBoxAdapter sliverSpacer(double? height) {
  return SliverToBoxAdapter(child: SizedBox(height: height));
}

SliverToBoxAdapter restorePurchaseWidget(
  BuildContext context,
  double safeAreaWidth, {
  VoidCallback? onTap,
}) {
  final ln = AppLocalizations.of(context)!;
  return SliverToBoxAdapter(
    child: nButton(
      safeAreaWidth,
      onTap: onTap,
      text: ln.restorePurchaseTitle,
      backGroundColor: Colors.grey,
      textColor: blackColor.withCustomOpacity(0.9),
      margin: nSpacing(
        top: safeAreaWidth * 0.1,
        xSize: safeAreaWidth * 0.05,
      ),
      radius: 15,
    ),
  );
}

Widget paymentLoadingWidget(
  BuildContext context,
  double safeAreaWidth,
  AsyncValue<SubscriptionType?> data,
) {
  final ln = AppLocalizations.of(context)!;
  final loading = loadinPage(safeAreaWidth);
  return data.when(
    error: (_, __) {
      if (context.mounted) nErrorDialog(context, ln.someErrorOccurred);
      return loadinPage(safeAreaWidth);
    },
    loading: () => loadinPage(safeAreaWidth),
    data: (data) => data == null ? loading : const SizedBox.shrink(),
  );
}

class SuccessScreen extends StatefulWidget {
  final double safeAreaWidth;
  const SuccessScreen({super.key, required this.safeAreaWidth});
  @override
  State<SuccessScreen> createState() => _SuccessScreen();
}

class _SuccessScreen extends State<SuccessScreen> {
  bool _isConfetti = false;

  @override
  void initState() {
    super.initState();
    animation();
  }

  Future<void> animation() async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (mounted) setState(() => _isConfetti = true);
    HapticFeedback.vibrate();
    await Future<void>.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const animationFile = "assets/animations/confetti.json";
    const animationFile2 = "assets/animations/check.json";
    return nContainer(
      alignment: Alignment.center,
      squareSize: double.infinity,
      color: Colors.black.withCustomOpacity(0.2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.safeAreaWidth * 0.3,
            child: Lottie.asset(animationFile2, repeat: false),
          ),
          if (_isConfetti)
            Transform.scale(
              scale: 2,
              child: Lottie.asset(animationFile, repeat: false),
            ),
        ],
      ),
    );
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Widget _cancelButton(BuildContext context, double safeAreaWidth) {
  return Align(
    alignment: Alignment.centerRight,
    child: nIconButton(
      onTap: () => Navigator.pop(context),
      margin: nSpacing(right: safeAreaWidth * 0.05),
      backGroundColor: Colors.white.withCustomOpacity(0.2),
      iconImage: "black/cancel.png",
      imageCustomColor: Colors.white,
      iconSize: safeAreaWidth / 20,
      padding: nSpacing(allSize: safeAreaWidth * 0.03),
    ),
  );
}

Widget proLogoWidget(
  double safeAreaWidth, {
  EdgeInsetsGeometry? margin,
  double? fontSize,
  Color? color,
  Color? textColor,
}) {
  final bgColor = textColor ?? const Color.fromARGB(255, 71, 101, 254);
  return nContainer(
    color: color ?? Colors.white,
    margin: margin,
    padding: nSpacing(
      ySize: safeAreaWidth * 0.008,
      xSize: safeAreaWidth * 0.01,
    ),
    radius: 50,
    child: nText(
      "PRO",
      fontSize: fontSize ?? safeAreaWidth / 60,
      fontFamily: "",
      bold: 900,
      color: bgColor,
    ),
  );
}

Widget _planContent(
  BuildContext context,
  BoxConstraints constraints,
  int index,
) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = constraints.maxWidth;
  final icons = ["timer.png", "swipe.png", "letter.png"];
  final titles = [ln.unlimitedChatTime, ln.unlimitedSwipes, ln.seeWhoLikedYou];
  final texts = [
    ln.unlimitedChatTimeText,
    ln.unlimitedSwipesText,
    ln.seeWhoLikedYouText,
  ];
  return Padding(
    padding: nSpacing(ySize: safeAreaWidth * 0.03),
    child: Row(
      children: [
        Transform.scale(
          scale: index == 1 ? 1.4 : 1,
          child: nContainer(
            margin: nSpacing(right: safeAreaWidth * 0.03),
            squareSize: safeAreaWidth * 0.08,
            image: assetImg("icon/${icons[index]}"),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 2; i++)
                nText(
                  [titles[index], texts[index]][i],
                  padding: nSpacing(top: safeAreaWidth * [0, 0.015][i]),
                  fontSize: safeAreaWidth / [26, 30][i],
                  color: blackColor.withCustomOpacity([1.0, 0.5][i]),
                  bold: [800.0, 500.0][i],
                  isFit: true,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BottomBulgeRoundedOutClipper extends CustomClipper<Path> {
  _BottomBulgeRoundedOutClipper({this.bulge = 24});
  final double bulge; // 膨らみの深さ(px)

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final b = bulge;
    final base = h - b;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, base)
      ..quadraticBezierTo(w * 0.5, base + b, 0, base)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _BottomBulgeRoundedOutClipper old) =>
      old.bulge != bulge;
}
