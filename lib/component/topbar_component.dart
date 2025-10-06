import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';

PreferredSizeWidget? nTabBar(
  double safeAreaWidth, {
  List<String>? tabTitleTexts,
  List<IconData>? tabTitleIcons,
  List<String>? imageIcons,
  List<double>? customImageSize,
  double? size,
  Color textColor = Colors.white,
  Color? customUnColor,
  bool isUnderline = true,
  TabAlignment? tabAlignment,
  double? horizontalBar,
  List<Shadow>? shadows,
  int? addBadgeIndex,
}) {
  final unColor = customUnColor ?? textColor.withCustomOpacity();
  final horizontal = horizontalBar ?? safeAreaWidth * 0.15;
  TextStyle textStyle(Color? color) => TextStyle(
        decoration: TextDecoration.none,
        fontFamily: "Normal",
        fontVariations: const [FontVariation("wght", 600)],
        height: 1,
        color: color,
        fontSize: size,
        shadows: shadows,
      );
  return TabBar(
    isScrollable: tabAlignment != null,
    tabAlignment: tabAlignment,
    dividerColor: Colors.transparent,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    labelColor: textColor,
    indicatorPadding: EdgeInsets.only(bottom: safeAreaWidth * 0.005),
    unselectedLabelColor: unColor,
    indicatorColor: textColor,
    indicatorSize: TabBarIndicatorSize.label,
    indicator: isUnderline
        ? FixedUnderlineTabIndicator(
            borderSide: BorderSide(width: 2, color: textColor),
            width: horizontal,
          )
        : const BoxDecoration(),
    labelStyle: textStyle(Colors.black),
    unselectedLabelStyle: textStyle(unColor),
    tabs: [
      if (tabTitleTexts != null)
        for (int i = 0; i < tabTitleTexts.length; i++)
          badges.Badge(
            showBadge: addBadgeIndex == i,
            badgeContent: const Text(""),
            child: Tab(text: tabTitleTexts[i]),
          ),
      if (tabTitleIcons != null)
        for (final item in tabTitleIcons)
          Tab(child: Icon(size: size ?? safeAreaWidth * 0.08, item)),
      if (imageIcons != null)
        for (int i = 0; i < imageIcons.length; i++)
          Tab(
            height: size,
            icon: ImageIcon(
              AssetImage(imageIcons[i]),
              size: customImageSize?[i] ?? safeAreaWidth * 0.08,
            ),
          ),
    ],
  );
}

PreferredSizeWidget nAppBar(
  BuildContext context,
  double safeAreaWidth, {
  double? height,
  PreferredSizeWidget? bottom,
  String? title,
  Widget? titleWidget,
  Widget? rightWidget,
  Widget? leftWidget,
  AppBarLeftIconType? leftIconType,
  double? sideIconWidth,
  Color backgroundColor = mainBackgroundColor,
  bool isBlackBg = false,
  VoidCallback? customOnTap,
}) {
  final double sideWidth = sideIconWidth ?? safeAreaWidth / 12;
  VoidCallback onTap() => customOnTap ?? () => Navigator.pop(context);
  final double leftIconAngle =
      leftIconType == AppBarLeftIconType.down ? -90 : 0;

  PreferredSizeWidget appBar() => AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //左側のアイコン
            nContainer(
              alignment: Alignment.centerLeft,
              width: sideWidth,
              child: leftIconType == AppBarLeftIconType.cancel
                  ? SizedBox(
                      width: safeAreaWidth * 0.08,
                      child: nIconButton(
                        onTap: onTap(),
                        iconData: Icons.close,
                        iconSize: safeAreaWidth * 0.08,
                        iconColor: isBlackBg ? Colors.white : Colors.black,
                      ),
                    )
                  : leftIconType != AppBarLeftIconType.none
                      ? nArrowIcon(
                          rotation: leftIconAngle,
                          iconSize: safeAreaWidth / 12,
                          color: isBlackBg ? Colors.white : Colors.black,
                          onTap: onTap(),
                        )
                      : leftWidget,
            ),

            //真ん中のアイコン
            if (title != null)
              Expanded(
                child: Align(
                  child: nText(
                    title,
                    fontSize: safeAreaWidth / 20,
                    color: isBlackBg ? Colors.white : Colors.black,
                    isFit: true,
                  ),
                ),
              ),
            if (titleWidget != null) titleWidget,

            //右側のアイコン
            nContainer(
              alignment: Alignment.centerRight,
              width: sideWidth,
              child: rightWidget,
            ),
          ],
        ),
        bottom: bottom,
      );
  //高さが指定されてたら、その高さ
  if (height != null) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: appBar(),
    );
  } else {
    //高さが指定されていないなら、デフォルトの高さ。
    return appBar();
  }
}

class FixedUnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final double width;
  final EdgeInsetsGeometry insets;

  const FixedUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.width = 20.0,
    this.insets = EdgeInsets.zero,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FixedUnderlinePainter(this, onChanged);
  }
}

class _FixedUnderlinePainter extends BoxPainter {
  final FixedUnderlineTabIndicator decoration;

  _FixedUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final Rect rect = offset & configuration.size!;
    final double indicatorWidth = decoration.width;
    final Offset indicatorOffset = Offset(
      rect.left + (rect.width - indicatorWidth) / 2,
      rect.bottom - decoration.borderSide.width,
    );

    final Rect indicator = Rect.fromLTWH(
      indicatorOffset.dx,
      indicatorOffset.dy,
      indicatorWidth,
      decoration.borderSide.width,
    );

    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      indicator.bottomLeft,
      indicator.bottomRight,
      paint,
    );
  }
}
