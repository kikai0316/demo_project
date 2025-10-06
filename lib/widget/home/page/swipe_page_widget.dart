import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/constant/value_const.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:permission_handler/permission_handler.dart';

Widget topWidgetContainer(
  BoxConstraints constraints, {
  required List<Widget> children,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: nSpacing(
          top: safeAreaHeight * 0.01,
          xSize: safeAreaWidth * 0.05,
        ),
        child: Stack(
          children: children,
        ),
      ),
    ),
  );
}

Widget logoWidget(double safeAreaWidth) {
  return Align(
    alignment: Alignment.topCenter,
    child: Transform.scale(
      scale: 3,
      child: Hero(
        tag: "app_logo",
        child: nContainer(
          // margin: nSpacing(left: safeAreaWidth * 0.05),
          squareSize: safeAreaWidth * 0.1,
          image: assetImg("image/logo.png"),
        ),
      ),
    ),
  );
}

Widget optionsIconWidget(double safeAreaWidth, VoidCallback onTap) {
  return nIconButton(
    onTap: onTap,
    backGroundColor: Colors.white,
    vibration: () => HapticFeedback.selectionClick(),
    iconImage: "black/option.png",
    iconSize: safeAreaWidth * 0.05,
    padding: nSpacing(allSize: safeAreaWidth * 0.04),
  );
}

Widget upGreatButtonWidget(
  BuildContext context,
  double safeAreaWidth,
  VoidCallback onTap,
) {
  final ln = AppLocalizations.of(context)!;
  return nIconButton(
    onTap: onTap,
    vibration: () => HapticFeedback.selectionClick(),
    padding: nSpacing(allSize: safeAreaWidth * 0.02),
    border: nBorder(color: Colors.white),
    radius: 50,
    iconImage: "premium.png",
    iconSize: safeAreaWidth * 0.06,
    withTextWidget: nText(
      ln.premium,
      fontSize: safeAreaWidth / 30,
      bold: 900,
      color: Colors.white.withCustomOpacity(0.8),
      padding: nSpacing(xSize: safeAreaWidth * 0.01),
    ),
  );
}

Widget proplanWidget(
  BuildContext context,
  WidgetRef ref,
  double safeAreaWidth,
) {
  final active = ref.watch(subscriptionNotifierProvider).value?.activeSub;
  if (active == null) return const SizedBox.shrink();
  return Align(
    alignment: Alignment.topRight,
    child: nContainer(
      margin: nSpacing(allSize: safeAreaWidth * 0.015),
      padding: nSpacing(allSize: safeAreaWidth * 0.015),
      // color: Colors.white,
      border: nBorder(color: Colors.white, width: 2),
      radius: 50,
      child: nText(
        "PRO",
        fontSize: safeAreaWidth / 27,
        bold: 900,
        padding: nSpacing(xSize: safeAreaWidth * 0.01),
      ),
    ),
  );
}

Widget swiperContainer(
  BoxConstraints constraints, {
  required int length,
  required int initialIndex,
  required CardSwiperController? controller,
  required Widget? Function(BuildContext, int, int, int) cardBuilder,
  required FutureOr<bool> Function(int, int?, CardSwiperDirection)? onChanged,
  required void Function(CardSwiperDirection, CardSwiperDirection)?
      onSwipeDirectionChange,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaMaxheight = constraints.maxHeight;
  if (length == 0) return const SizedBox.shrink();
  return Align(
    child: Padding(
      padding: nSpacing(top: safeAreaMaxheight * 0.03),
      child: nContainer(
        aspectRatio: mainAspectRatio,
        padding: nSpacing(allSize: safeAreaWidth * 0.05),
        child: CardSwiper(
          controller: controller,
          cardsCount: length,
          initialIndex: initialIndex,
          padding: EdgeInsets.zero,
          numberOfCardsDisplayed: math.min(3, length),
          backCardOffset: const Offset(0, -40),
          onSwipe: onChanged,
          onSwipeDirectionChange: onSwipeDirectionChange,
          isLoop: false,
          cardBuilder: cardBuilder,
        ),
      ),
    ),
  );
}

Widget swipeActionWidget(
  BoxConstraints constraints,
  ValueNotifier<SwipeActionType> swipeAction,
  void Function(SwipeActionType) onAction,
) {
  final safeAreaWidth = constraints.maxWidth;
  final actions = [SwipeActionType.nope, SwipeActionType.like];
  bool isShow(int index) {
    final action = swipeAction.value;
    return action.isIdle() || [action.isNope(), action.isLike()][index];
  }

  return SafeArea(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: nSpacing(bottom: safeAreaWidth * 0.02),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < 2; i++)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isShow(i) ? 1 : 0,
                child: nIconButton(
                  margin: nSpacing(xSize: safeAreaWidth * 0.02),
                  squareSize: safeAreaWidth * 0.18,
                  onTap: () => onAction.call(actions[i]),
                  iconData: [
                    Icons.close_rounded,
                    Icons.favorite_rounded,
                  ][i],
                  iconSize: safeAreaWidth / 12,
                  iconColor: [Colors.blueAccent, Colors.white][i],
                  backGroundColor: [Colors.white, Colors.blueAccent][i],
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget emptyWidget(
  BuildContext context,
  BoxConstraints constraints,
  ValueNotifier<int?> currentIndex,
  List<SwipeUserType>? swipeUsers,
  ValueNotifier<bool> isLoading, {
  required VoidCallback onReFetch,
}) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = constraints.maxWidth;
  const asset = "assets/animations/snow.json";
  const filter = ColorFilter.mode(Colors.white, BlendMode.srcATop);
  const color = Colors.blueAccent;
  final isEmpty = swipeUsers != null && swipeUsers.isEmpty;
  double opacity() {
    final isLast = (swipeUsers?.length ?? 9999) - 1;
    if ((swipeUsers ?? []).indexWhere((e) => !e.isSwipe) == -1) return 1;
    if (isLast == currentIndex.value) return 0.3;
    return 0;
  }

  if (opacity() == 0) return SizedBox.fromSize();
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 300),
    opacity: opacity(),
    child: nContainer(
      squareSize: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (opacity() == 1)
            ColorFiltered(
              colorFilter: filter,
              child: Transform.scale(scale: 3.5, child: Lottie.asset(asset)),
            ),
          Padding(
            padding: nSpacing(top: safeAreaWidth * 0.065),
            child: nContainer(
              border: nBorder(color: Colors.white, width: 2),
              margin: nSpacing(allSize: safeAreaWidth * 0.05),
              radius: 35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: nContainer(
                    aspectRatio: mainAspectRatio,
                    radius: 35,
                    color: blueColor2.withCustomOpacity(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!isEmpty)
                          nIcon(
                            Icons.account_circle_rounded,
                            size: safeAreaWidth / 3.5,
                            color: color.withCustomOpacity(0.6),
                          ),
                        nText(
                          isEmpty ? ln.noNearbyUsersTitle : ln.noMoreUsers,
                          padding: nSpacing(top: safeAreaWidth * 0.05),
                          fontSize: safeAreaWidth / (isEmpty ? 18 : 24),
                          color: color.withCustomOpacity(isEmpty ? 1 : 0.6),
                          isOverflow: false,
                          height: 1.4,
                        ),
                        if (isEmpty)
                          nText(
                            ln.noNearbyUsersMessage,
                            padding: nSpacing(
                              top: safeAreaWidth * 0.05,
                              xSize: safeAreaWidth * 0.03,
                            ),
                            fontSize: safeAreaWidth / 25,
                            color: color.withCustomOpacity(0.6),
                            isOverflow: false,
                            height: 1.4,
                          ),
                        SizedBox(height: safeAreaWidth * 0.05),
                        if (isEmpty)
                          nIconButton(
                            onTap: () => nOpneUrl(officialTiktok),
                            iconImage: "tiktok.png",
                            iconSize: safeAreaWidth * 0.05,
                            margin: nSpacing(top: safeAreaWidth * 0.02),
                            padding: nSpacing(
                              ySize: safeAreaWidth * 0.02,
                              xSize: safeAreaWidth * 0.025,
                            ),
                            withTextWidget: nText(
                              "TikTok",
                              fontSize: safeAreaWidth / 26,
                              padding: nSpacing(left: safeAreaWidth * 0.01),
                              color: blackColor,
                              bold: 900,
                            ),
                          ),
                        nContainer(
                          alignment: Alignment.center,
                          height: safeAreaWidth * 0.2,
                          child: !isLoading.value
                              ? nIconButton(
                                  onTap: onReFetch,
                                  padding:
                                      nSpacing(allSize: safeAreaWidth * 0.02),
                                  vibration: () =>
                                      HapticFeedback.selectionClick(),
                                  iconData: Icons.refresh_rounded,
                                  iconColor: color,
                                  boxShadow: nBoxShadow(shadow: 0.05),
                                  withTextWidget: nText(
                                    ln.retry,
                                    fontSize: safeAreaWidth / 20,
                                    color: color,
                                  ),
                                )
                              : nIndicatorWidget(
                                  padding:
                                      nSpacing(allSize: safeAreaWidth * 0.02),
                                  size: safeAreaWidth * 0.03,
                                  color: color,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget errorWidget(
  BuildContext context,
  WidgetRef ref,
  double safeAreaWidth,
  ValueNotifier<bool> isLoading,
) {
  final ln = AppLocalizations.of(context)!;
  const color = Colors.blueAccent;
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.065),
    child: nContainer(
      border: nBorder(color: Colors.white, width: 2),
      margin: nSpacing(allSize: safeAreaWidth * 0.05),
      radius: 35,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: nContainer(
            aspectRatio: mainAspectRatio,
            radius: 35,
            color: blueColor2.withCustomOpacity(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nIcon(
                  Icons.error,
                  color: color,
                  size: safeAreaWidth / 5,
                ),
                for (int i = 0; i < 2; i++)
                  nText(
                    [ln.error, ln.errorUnexpected][i],
                    padding: nSpacing(top: safeAreaWidth * [0.05, 0][i]),
                    fontSize: safeAreaWidth / [15, 25][i],
                    color: color.withCustomOpacity([1.0, 0.6][i]),
                    isOverflow: false,
                    height: 1.4,
                  ),
                nContainer(
                  alignment: Alignment.center,
                  height: safeAreaWidth * 0.2,
                  child: !isLoading.value
                      ? nIconButton(
                          onTap: () async {
                            isLoading.value = true;
                            await ref
                                .read(userDataNotifierProvider.notifier)
                                .reFetchStartupData();
                            if (context.mounted) isLoading.value = false;
                          },
                          padding: nSpacing(allSize: safeAreaWidth * 0.02),
                          vibration: () => HapticFeedback.selectionClick(),
                          iconData: Icons.refresh_rounded,
                          iconColor: color,
                          boxShadow: nBoxShadow(shadow: 0.05),
                          withTextWidget: nText(
                            ln.retry,
                            fontSize: safeAreaWidth / 20,
                            color: color,
                          ),
                        )
                      : nIndicatorWidget(
                          padding: nSpacing(allSize: safeAreaWidth * 0.02),
                          size: safeAreaWidth * 0.03,
                          color: color,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget swipeUserDataEmptyWidget(
  BuildContext context,
  double safeAreaWidth, {
  required VoidCallback onReFetch,
}) {
  final ln = AppLocalizations.of(context)!;
  const color = Colors.blueAccent;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      nText(
        ln.noNearbyUsers,
        fontSize: safeAreaWidth / 17,
        color: blackColor,
      ),
      nText(
        ln.smallCommunityPitch,
        fontSize: safeAreaWidth / 23,
        padding: nSpacing(
          top: safeAreaWidth * 0.1,
          xSize: safeAreaWidth * 0.03,
        ),
        isOverflow: false,
        height: 1.5,
        color: blackColor.withCustomOpacity(0.5),
      ),
      nIconButton(
        onTap: onReFetch,
        padding: nSpacing(allSize: safeAreaWidth * 0.02),
        vibration: () => HapticFeedback.selectionClick(),
        iconData: Icons.refresh_rounded,
        iconColor: color,
        boxShadow: nBoxShadow(shadow: 0.05),
        withTextWidget: nText(
          ln.retry,
          fontSize: safeAreaWidth / 20,
          color: color,
        ),
      ),
    ],
  );
}

Widget notLocationPermission(BuildContext context, BoxConstraints constraints) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  final ln = AppLocalizations.of(context)!;
  return SafeArea(
    child: Column(
      children: [
        Padding(
          padding: nSpacing(top: safeAreaHeight * 0.01),
          child: logoWidget(safeAreaWidth),
        ),
        nContainer(
          margin: nSpacing(top: safeAreaWidth * 0.35),
          squareSize: safeAreaWidth * 0.2,
          image: assetImg("image/location.png"),
          radius: 20,
          border: nBorder(
            color: Colors.white.withCustomOpacity(0.2),
          ),
          boxShadow: nBoxShadow(shadow: 0.1),
        ),
        nText(
          ln.permissionLocationDeniedTitle,
          fontSize: safeAreaWidth / 18,
          color: blackColor,
          padding: nSpacing(
            top: safeAreaHeight * 0.05,
            xSize: safeAreaWidth * 0.05,
          ),
          isFit: true,
        ),
        nText(
          ln.permissionLocationExplanation,
          fontSize: safeAreaWidth / 23,
          padding: nSpacing(
            top: safeAreaHeight * 0.02,
            xSize: safeAreaWidth * 0.05,
          ),
          color: blackColor.withCustomOpacity(0.5),
          height: 1.3,
          isOverflow: false,
        ),
        nButton(
          safeAreaWidth,
          onTap: () async => await openAppSettings(),
          height: safeAreaWidth * 0.12,
          width: safeAreaWidth * 0.5,
          margin: nSpacing(top: safeAreaHeight * 0.04),
          text: ln.openSettings,
          textColor: blackColor,
          border: nBorder(color: blackColor, width: 2),
          fontSize: safeAreaWidth / 25,
          radius: 10,
        ),
      ],
    ),
  );
}

Widget locationLoadingWidget(BuildContext context, BoxConstraints constraints) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return SafeArea(
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: nSpacing(top: safeAreaHeight * 0.01),
          child: logoWidget(safeAreaWidth),
        ),
        Center(
          child: nIndicatorWidget(
            size: safeAreaWidth / 30,
            color: blackColor,
          ),
        ),
      ],
    ),
  );
}
