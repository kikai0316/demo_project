//ホーム画面のアップバーと、投稿切り替えバーのWidget
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/constant/value_const.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/widget/home/profile_card_widget.dart';
import 'package:demo_project/widget/widget/future_text_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

PreferredSizeWidget? userProfileAppBar(
  BuildContext context, {
  required BoxConstraints constraints,
  required bool isShow,
  required UserType userData,
  required void Function()? onMenu,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  if (!isShow) return null;
  return nAppBar(
    context,
    safeAreaWidth,
    height: safeAreaHeight * 0.06,
    sideIconWidth: safeAreaWidth * 0.45,
    backgroundColor: Colors.transparent,
    leftIconType: AppBarLeftIconType.none,
    rightWidget: onMenu != null ? _menuButton(safeAreaWidth, onMenu) : null,
  );
}

Widget profileImageItem(
  BoxConstraints constraints,
  ValueNotifier<int> imageIndex,
  UserType user,
  bool isTag,
  ValueNotifier<ScreenState> screenState, {
  required void Function() onPop,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final gradation = fadeGradation(Alignment.bottomCenter, 0.5);
  final url = user.profileImages[imageIndex.value];
  return Hero(
    tag: isTag ? "${user.id}_$url" : "",
    child: nContainer(
      aspectRatio: mainAspectRatio,
      customBorderRadius: nBorderRadius(radius: 20, isOnlyTop: true),
      color: Colors.grey,
      child: Stack(
        children: [
          IndexedStack(index: imageIndex.value, children: [
            for (final img in user.profileImages)
              CustomNetworkImageWidegt(
                safeAreaWidth: constraints.maxWidth,
                url: img,
                radius: 20,
                isUserImage: false,
              ),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: nContainer(
              alignment: Alignment.bottomCenter,
              height: safeAreaWidth * 0.4,
              width: safeAreaWidth,
              gradient: nGradation(colors: gradation),
              padding: nSpacing(bottom: safeAreaWidth * 0.15),
              child: indicatorWidget(constraints, imageIndex, user),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: nContainer(
              height: safeAreaWidth * 0.07,
              width: safeAreaWidth,
              color: mainBackgroundColor,
              customBorderRadius: nBorderRadius(
                radius: 100,
                isOnlyTop: true,
              ),
            ),
          ),
          tapEventWidget(imageIndex, user),
          _arrorButton(safeAreaWidth, screenState, onPop),
        ],
      ),
    ),
  );
}

Widget profileContainer(
  BoxConstraints constraints, {
  required List<Widget> children,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  final aspectHeight = constraints.maxWidth / (9 / 14.5);
  return nContainer(
    alignment: Alignment.topLeft,
    color: mainBackgroundColor,
    width: safeAreaWidth,
    minHeight: safeAreaHeight - aspectHeight + (safeAreaHeight * 0.1),
    padding: nSpacing(xSize: safeAreaWidth * 0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

Widget nameAgeItem(double safeAreaWidth, UserType user) {
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.02),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        nContainer(
          maxWidth: safeAreaWidth * 0.8,
          child: nText(
            user.userName,
            fontSize: safeAreaWidth / 10,
            isFit: true,
            isOverflow: false,
            color: blackColor,
            bold: 900,
          ),
        ),
        nText(
          user.toAge(),
          padding: nSpacing(left: safeAreaWidth * 0.03),
          fontSize: safeAreaWidth / 18,
          color: blackColor,
        ),
      ],
    ),
  );
}

Widget locationItem(double safeAreaWidth, UserType user) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      nIcon(
        Icons.location_on_rounded,
        size: safeAreaWidth / 25,
        color: blackColor,
      ),
      FutureTextWidget(
        location: user.location,
        fontSize: safeAreaWidth / 25,
        color: blackColor,
      ),
    ],
  );
}

Widget userBioItem(double safeAreaWidth, UserType user) {
  if (user.bio.isEmpty) return const SizedBox.shrink();
  return nContainer(
    margin: nSpacing(top: safeAreaWidth * 0.02),
    alignment: Alignment.centerLeft,
    width: safeAreaWidth,
    child: nText(
      user.bio,
      fontSize: safeAreaWidth / 23,
      textAlign: TextAlign.left,
      color: blackColor,
      height: 1.5,
      isOverflow: false,
    ),
  );
}

Widget snsAccountItem(double safeAreaWidth, UserType user) {
  final datas = [user.instagramId, user.tiktokId, user.beRealId];
  final isAllEmpty = datas.indexWhere((e) => e.isNotEmpty) == -1;
  if (isAllEmpty) return const SizedBox.shrink();
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.05),
    child: Row(
      children: [
        for (int i = 0; i < 3; i++)
          if (datas[i].isNotEmpty)
            nIconButton(
              onTap: () => nOpneUrl("${snsUrls[i]}${datas[i]}"),
              iconImage: ["instagram.png", "tiktok.png", "bereal.png"][i],
              iconSize: safeAreaWidth * 0.045,
              margin: nSpacing(right: safeAreaWidth * 0.02),
              padding: nSpacing(
                ySize: safeAreaWidth * 0.02,
                xSize: safeAreaWidth * 0.025,
              ),
              border: nBorder(color: blackColor.withCustomOpacity()),
              withTextWidget: nText(
                ["Instagram", "TikTok", "BeReal"][i],
                fontSize: safeAreaWidth / 32,
                padding: nSpacing(left: safeAreaWidth * 0.01),
                color: blackColor,
                bold: 900,
              ),
            ),
      ],
    ),
  );
}

Widget gradationWidget(double safeAreaWidth, bool isScroll) {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: isScroll ? 0 : 0.5,
    child: nContainer(
      height: safeAreaWidth * 0.25,
      width: safeAreaWidth,
      gradient: nGradation(colors: fadeGradation()),
    ),
  );
}

Widget bottomGradationWidget(double safeAreaWidth) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: nContainer(
      height: safeAreaWidth * 0.25,
      width: safeAreaWidth,
      gradient: nGradation(
        colors: [
          mainBackgroundColor.withCustomOpacity(0),
          mainBackgroundColor.withCustomOpacity(0.8),
        ],
      ),
    ),
  );
}

Widget actionButtonWidgets(
  double safeAreaWidth,
  void Function(SwipeActionType) onAction,
) {
  final actions = [SwipeActionType.nope, SwipeActionType.like];
  return SafeArea(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: nContainer(
            padding: nSpacing(xSize: safeAreaWidth * 0.01),
            radius: 50,
            color: Colors.black.withCustomOpacity(0.15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 2; i++)
                  nIconButton(
                    onTap: () => onAction.call(actions[i]),
                    iconData: [
                      Icons.close_rounded,
                      Icons.favorite_rounded,
                    ][i],
                    iconSize: safeAreaWidth * 0.06,
                    iconColor: [Colors.blueAccent, Colors.white][i],
                    backGroundColor: [
                      mainBackgroundColor,
                      Colors.blueAccent,
                    ][i],
                    margin: nSpacing(allSize: safeAreaWidth * 0.03),
                    padding: nSpacing(allSize: safeAreaWidth * 0.045),
                    border:
                        nBorder(color: Colors.black.withCustomOpacity(0.05)),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget tagWidgetItems(
  BuildContext context,
  double safeAreaWidth,
  UserType user,
) {
  final ln = AppLocalizations.of(context)!;
  final tags = user.toTags(context);
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.05),
    child: Wrap(
      runSpacing: safeAreaWidth * 0.02,
      children: [
        for (final tag in tags)
          if (tag.value != ln.notSet)
            nIconButton(
              iconData: tag.icon,
              iconSize: safeAreaWidth * 0.05,
              iconColor: blackColor,
              backGroundColor: blueColor,
              radius: 10,
              margin: nSpacing(right: safeAreaWidth * 0.02),
              padding: nSpacing(
                ySize: safeAreaWidth * 0.02,
                xSize: safeAreaWidth * 0.025,
              ),
              border: nBorder(color: Colors.black.withCustomOpacity(0.05)),
              withTextWidget: nText(
                tag.value ?? "",
                fontSize: safeAreaWidth / 30,
                padding: nSpacing(left: safeAreaWidth * 0.01),
                color: Colors.black,
                bold: 900,
              ),
            ),
      ],
    ),
  );
}

List<Widget> userProfileLoadingItems(double safeAreaWidth) {
  final color = Colors.grey.withCustomOpacity(0.2);
  Widget container({double? height, double? width}) {
    return nSkeletonLoadingWidget(
      highlightColor: Colors.white,
      child: nContainer(height: height, width: width, color: color, radius: 50),
    );
  }

  return [
    container(height: safeAreaWidth * 0.06, width: safeAreaWidth * 0.3),
    SizedBox(height: safeAreaWidth * 0.03),
    Row(
      children: [
        for (int i = 0; i < 3; i++) ...{
          container(height: safeAreaWidth * 0.1, width: safeAreaWidth * 0.25),
          SizedBox(width: safeAreaWidth * 0.03),
        },
      ],
    ),
    SizedBox(height: safeAreaWidth * 0.03),
    Wrap(
      spacing: safeAreaWidth * 0.03,
      children: [
        for (int i = 0; i < 4; i++)
          container(height: safeAreaWidth * 0.1, width: safeAreaWidth * 0.2),
      ],
    ),
  ];
}

Widget errorItem(
  BuildContext context,
  double safeAreaWidth,
  VoidCallback onTap,
) {
  final ln = AppLocalizations.of(context)!;
  return nContainer(
    width: double.infinity,
    padding: nSpacing(
      top: safeAreaWidth * 0.07,
      bottom: safeAreaWidth * 0.03,
    ),
    color: Colors.grey.withCustomOpacity(0.2),
    margin: nSpacing(top: safeAreaWidth * 0.05),
    radius: 15,
    child: Column(
      children: [
        nText(
          ln.errorLoadData,
          fontSize: safeAreaWidth / 28,
          color: blackColor.withCustomOpacity(0.5),
        ),
        nIconButton(
          onTap: onTap,
          margin: nSpacing(top: safeAreaWidth * 0.01),
          padding: nSpacing(allSize: safeAreaWidth * 0.03),
          vibration: () => HapticFeedback.selectionClick(),
          iconData: Icons.refresh_rounded,
          iconColor: Colors.blue,
          iconSize: safeAreaWidth * 0.05,
          boxShadow: nBoxShadow(shadow: 0.05),
          withTextWidget: nText(
            ln.retry,
            fontSize: safeAreaWidth / 25,
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );
}

Widget chatButtonWidgets(double safeAreaWidth, VoidCallback onTap) {
  return SafeArea(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: nContainer(
            padding: nSpacing(allSize: safeAreaWidth * 0.03),
            radius: 50,
            color: Colors.black.withCustomOpacity(0.15),
            child: nIconButton(
              onTap: onTap,
              iconImage: "black/talk.png",
              iconSize: safeAreaWidth * 0.08,
              imageCustomColor: Colors.blueAccent,
              backGroundColor: mainBackgroundColor,
              squareSize: safeAreaWidth * 0.2,
              border: nBorder(color: Colors.black.withCustomOpacity(0.05)),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget userProfileEmptyData(double safeAreaWidth, String text) {
  return nContainer(
    alignment: Alignment.center,
    margin: nSpacing(ySize: safeAreaWidth * 0.02),
    padding: nSpacing(
      ySize: safeAreaWidth * 0.06,
      xSize: safeAreaWidth * 0.03,
    ),
    width: safeAreaWidth,
    color: Colors.grey.withCustomOpacity(0.1),
    radius: 10,
    child: nText(
      text,
      fontSize: safeAreaWidth / 30,
      color: blackColor.withCustomOpacity(0.4),
    ),
  );
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他関数
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Widget _menuButton(double safeAreaWidth, VoidCallback onMenu) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: nIconButton(
        onTap: onMenu,
        backGroundColor: Colors.white.withCustomOpacity(0.2),
        iconData: Icons.more_horiz,
        iconSize: safeAreaWidth / 13,
        squareSize: safeAreaWidth * 0.13,
      ),
    ),
  );
}

Widget _arrorButton(
  double safeAreaWidth,
  ValueNotifier<ScreenState> screenState,
  VoidCallback onTap,
) {
  return Align(
    alignment: Alignment.bottomRight,
    child: Padding(
      padding: nSpacing(
        right: safeAreaWidth * 0.05,
        bottom: safeAreaWidth * 0.12,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: screenState.value.isIdle() ? 0 : 1,
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: screenState.value.isIdle() ? 0 : -0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: nIconButton(
                onTap: onTap,
                backGroundColor: Colors.white.withCustomOpacity(0.2),
                iconImage: "black/arror_top.png",
                iconSize: safeAreaWidth / 12,
                imageCustomColor: Colors.white,
                squareSize: safeAreaWidth * 0.18,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
