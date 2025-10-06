import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/chat_log_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/user_profile_page.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

const circleUserWidgetSize = 0.22;
PreferredSizeWidget? talkPageAppBar(
  BuildContext context,
  double safeAreaWidth,
) {
  return nAppBar(
    context, safeAreaWidth,
    backgroundColor: Colors.transparent,
    // sideIconWidth: safeAreaWidth * 0.45,
    leftIconType: AppBarLeftIconType.none,
    titleWidget: Transform.scale(
      scale: 2.5,
      child: nContainer(
        // margin: nSpacing(left: safeAreaWidth * 0.05),
        squareSize: safeAreaWidth * 0.15,
        image: assetImg("image/chat.png"),
      ),
    ),
    // rightWidget: nIconButton(
    //   onTap: () {},
    //   backGroundColor: Colors.white,
    //   vibration: () => HapticFeedback.selectionClick(),
    //   iconImage: "black/option.png",
    //   iconSize: safeAreaWidth * 0.05,
    //   padding: nSpacing(allSize: safeAreaWidth * 0.04),
    // ),
  );
}

Widget notTalkTitleWidget(
  BuildContext context,
  double safeAreaWidth,
) {
  final ln = AppLocalizations.of(context)!;

  return Align(
    alignment: Alignment.centerLeft,
    child: nText(
      ln.notTalkTitl,
      padding: nSpacing(
        top: safeAreaWidth * 0.05,
        left: safeAreaWidth * 0.03,
      ),
      textAlign: TextAlign.left,
      color: blackColor.withCustomOpacity(0.5),
      fontSize: safeAreaWidth / 25,
    ),
  );
}

Widget likedMeUsersItem(
  WidgetRef ref,
  double safeAreaWidth,
  AsyncValue<LikedMeUsersType?> likedMeUsersState,
  VoidCallback? onTap,
) {
  final isSubsc = ref.watch(subscriptionNotifierProvider).value == null;
  final data = likedMeUsersState.value;
  final isLoading = likedMeUsersState.isLoading || data == null;
  final isBadData = (data?.users ?? []).isEmpty || (data?.count ?? 0) == 0;
  final count = (data?.count ?? 0) > 99 ? 99 : data?.count ?? 0;

  if (isLoading || isSubsc) return userLoadingWidget(safeAreaWidth);
  if (isBadData) return const SizedBox.shrink();

  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: nContainerWithCircle(
          squareSize: safeAreaWidth * circleUserWidgetSize,
          color: Colors.white.withCustomOpacity(0.05),
          child: nIconButton(
            iconData: Icons.favorite_rounded,
            iconColor: Colors.blueAccent,
            iconSize: safeAreaWidth / 18,
            withTextWidget: nText(
              "$count+",
              fontSize: safeAreaWidth / 18,
              padding: nSpacing(left: safeAreaWidth * 0.01),
              color: Colors.blueAccent,
              shadows: nBoxShadow(),
              isFit: true,
            ),
          ),
        ),
      ),
    );
  }

  return Align(
    child: CustomAnimatedButton(
        onTap: onTap,
        child: nContainer(
          squareSize: safeAreaWidth * circleUserWidgetSize,
          radius: 100,
          border: nBorder(color: Colors.white, width: 2),
          color: Colors.grey,
          child: CustomNetworkImageWidegt(
            safeAreaWidth: safeAreaWidth,
            url: data.users.firstOrNull?.profileImages.firstOrNull ?? "",
            radius: 100,
            width: safeAreaWidth * circleUserWidgetSize,
            height: safeAreaWidth * circleUserWidgetSize,
            placeholder: userLoadingWidget(safeAreaWidth),
            errorWidget: nContainer(
              image: assetImg("image/notImage.png"),
              child: imageWidget(),
            ),
            imageBuilder: (_, provider) {
              return nContainer(
                image: DecorationImage(image: provider, fit: BoxFit.cover),
                child: imageWidget(),
              );
            },
          ),
        )),
  );
}

Widget usersItem(
  BuildContext context,
  double safeAreaWidth,
  UserPreviewType user,
) {
  final profilePage = UserProfilePage(
    user: user.toUserType(),
    isInitialize: true,
    isChatButton: true,
  );
  return CustomAnimatedButton(
      onTap: () => ScreenTransition(context, profilePage).top(),
      vibration: () => HapticFeedback.selectionClick(),
      child: nContainerWithCircle(
        alignment: Alignment.center,
        margin: nSpacing(left: safeAreaWidth * 0.03),
        border: nBorder(color: Colors.blueAccent, width: 3),
        boxShadow: nBoxShadow(shadow: 0.1),
        child: CustomNetworkImageWidegt(
          safeAreaWidth: safeAreaWidth,
          url: user.profileImages.first,
          radius: 100,
          width: safeAreaWidth * circleUserWidgetSize,
          height: safeAreaWidth * circleUserWidgetSize,
          placeholder: userLoadingWidget(safeAreaWidth),
        ),
      ));
}

Widget topWidgetContainer(
  BoxConstraints constraints, {
  required List<Widget> children,
}) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return nContainer(
    height: safeAreaWidth * 0.28,
    width: safeAreaWidth,
    margin: nSpacing(ySize: safeAreaHeight * 0.005),
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: nSpacing(xSize: safeAreaWidth * 0.03),
      scrollDirection: Axis.horizontal,
      children: children,
    ),
  );
}

SliverToBoxAdapter talkItemWidget(
  BuildContext context,
  double safeAreaWidth,
  ChatLogType data, {
  required VoidCallback onTap,
}) {
  final message = data.toMessage(context);
  return SliverToBoxAdapter(
    child: nListItem(
      onTap: onTap,
      safeAreaWidth,
      networkImgData: data.user.profileImages.first,
      mainText: "",
      textColor: blackColor,
      customFontSize: safeAreaWidth / 28,
      customMainText: nText(
        data.user.userName,
        color: data.toColor(),
        fontSize: safeAreaWidth / 22,
      ),
      customSubText: message != null
          ? Padding(
              padding: nSpacing(top: safeAreaWidth * 0.015),
              child: Row(
                children: [
                  Opacity(
                    opacity: 0.2,
                    child: nContainer(
                      image: assetImg("icon/black/talk.png"),
                      squareSize: safeAreaWidth * 0.045,
                      margin: nSpacing(right: safeAreaWidth * 0.01),
                    ),
                  ),
                  nText(
                    message,
                    color: blackColor.withCustomOpacity(0.5),
                    fontSize: safeAreaWidth / 29,
                  ),
                ],
              ),
            )
          : null,
      rightWidget: nText(
        data.toDateTimeForChat(context),
        fontSize: safeAreaWidth / 27,
        color: blackColor.withCustomOpacity(0.5),
      ),
    ),
  );
}

Widget historyTitleWidget(BuildContext context, double safeAreaWidth) {
  final ln = AppLocalizations.of(context)!;
  return Align(
    alignment: Alignment.centerLeft,
    child: nText(
      ln.recentChats,
      padding: nSpacing(
        top: safeAreaWidth * 0.07,
        bottom: safeAreaWidth * 0.04,
        left: safeAreaWidth * 0.05,
      ),
      textAlign: TextAlign.left,
      color: blackColor.withCustomOpacity(0.4),
      fontSize: safeAreaWidth / 23,
    ),
  );
}

List<Widget> notTalkWidgets(
  BuildContext context,
  BoxConstraints constraints,
) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = constraints.maxWidth;
  const img = "assets/animations/not_chat.json";
  return [
    SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(width: safeAreaWidth * 0.5, child: Lottie.asset(img)),
          nText(
            ln.noMessages,
            fontSize: safeAreaWidth / 23,
            color: blackColor.withCustomOpacity(),
          ),
        ],
      ),
    ),
  ];
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他上記に付随するWidget
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
Widget userLoadingWidget(
  double safeAreaWidth,
) {
  final size = safeAreaWidth * circleUserWidgetSize;
  return nContainerWithCircle(
    alignment: Alignment.center,
    squareSize: size,
    color: Colors.black.withCustomOpacity(0.1),
    child: nSkeletonLoadingWidget(
      radius: 100,
      child: nContainer(squareSize: size),
    ),
  );
}
