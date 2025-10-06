import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/button/gradient_loop_button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/payment_page.dart';
import 'package:demo_project/view/setting/edti_profile_page.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/widget/page/payment_page_widget.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';

const settingArrowIconSize = 18;

PreferredSizeWidget? accountPageAppBar(
  BuildContext context,
  double safeAreaWidth,
) {
  return nAppBar(
    context,
    safeAreaWidth,
    backgroundColor: Colors.transparent,
    leftIconType: AppBarLeftIconType.none,
    titleWidget: Transform.scale(
      scale: 2,
      child: nContainer(
        squareSize: safeAreaWidth * 0.15,
        image: assetImg("image/logo2.png"),
      ),
    ),
  );
}

SliverToBoxAdapter profileItem(
  BuildContext context,
  double safeAreaWidth,
  UserType? user,
) {
  final ln = AppLocalizations.of(context)!;
  const page = EdtitProfilePage();
  return SliverToBoxAdapter(
    child: CustomAnimatedOpacityButton(
      onTap: () => ScreenTransition(context, page).normal(),
      vibration: () => HapticFeedback.selectionClick(),
      child: nSkeletonLoadingWidget(
        isLoading: user == null,
        child: nContainer(
          margin: nSpacing(
            xSize: safeAreaWidth * 0.03,
            top: safeAreaWidth * 0.05,
          ),
          boxShadow: nBoxShadow(shadow: 0.02),
          padding: nSpacing(ySize: safeAreaWidth * 0.03),
          color: Colors.white,
          radius: 15,
          child: accountListItem(
            safeAreaWidth,
            padding: nSpacing(
              left: safeAreaWidth * 0.05,
              right: safeAreaWidth * 0.03,
              ySize: safeAreaWidth * 0.02,
            ),
            customMainText: nText(
              user?.userName ?? "",
              fontSize: safeAreaWidth / 23,
              color: blackColor,
            ),
            customSubText: user?.bio != null
                ? nText(
                    ln.editProfile,
                    fontSize: safeAreaWidth / 28,
                    padding: nSpacing(top: safeAreaWidth * 0.01),
                    color: blackColor.withCustomOpacity(),
                    maxLiune: 2,
                    height: 1.3,
                    bold: 500,
                    textAlign: TextAlign.start,
                  )
                : null,
            networkImg: user?.profileImages.first,
            rightWidget: nArrowIcon(
              padding: nSpacing(right: safeAreaWidth * 0.02),
              iconSize: safeAreaWidth / settingArrowIconSize,
              color: blackColor,
              opacity: 0.5,
              rotation: 180,
            ),
          ),
        ),
      ),
    ),
  );
}

SliverToBoxAdapter membershipStatusWidget(
  BuildContext context,
  WidgetRef ref,
  double safeAreaWidth,
  VoidCallback? onTap,
) {
  final subsc = ref.watch(subscriptionNotifierProvider).value;
  final ln = AppLocalizations.of(context)!;
  final value = subsc?.activeSub?.planStr(context);

  const paymentPage = PaymentPage();
  return SliverToBoxAdapter(
    child: nContainer(
      radius: 15,
      margin: nSpacing(
        top: safeAreaWidth * 0.05,
        xSize: safeAreaWidth * 0.03,
      ),
      padding: nSpacing(ySize: safeAreaWidth * 0.04),
      boxShadow: nBoxShadow(shadow: 0.05),
      color: Colors.white,
      child: Column(
        children: [
          nListItem(
            safeAreaWidth,
            onTap: onTap,
            mainText: ln.subscription,
            textColor: blackColor,
            itemPadding: safeAreaWidth * 0.03,
            leftWidget: proLogoWidget(
              safeAreaWidth,
              color: blackColor,
              textColor: Colors.white,
              fontSize: safeAreaWidth / 35,
            ),
            rightWidget: Row(
              children: [
                if (subsc == null)
                  nIndicatorWidget(
                    padding: nSpacing(right: safeAreaWidth * 0.03),
                    color: blackColor,
                    size: safeAreaWidth / 40,
                  )
                else
                  nText(
                    value ?? ln.free,
                    fontSize: safeAreaWidth / 25,
                    padding: nSpacing(right: safeAreaWidth * 0.01),
                    color: blackColor.withCustomOpacity(),
                  ),
                nArrowIcon(
                  padding: nSpacing(right: safeAreaWidth * 0.02),
                  iconSize: safeAreaWidth / settingArrowIconSize,
                  rotation: 180,
                  color: blackColor,
                  opacity: 0.5,
                ),
              ],
            ),
          ),
          if (value == null) ...[
            Align(
              alignment: Alignment.centerRight,
              child: nDiver(
                color: Colors.black.withCustomOpacity(0.05),
                safeAreaWidth * 0.8,
                margin: nSpacing(top: safeAreaWidth * 0.02),
              ),
            ),
            GradientLoopButton(
              onTap: () => ScreenTransition(context, paymentPage).top(),
              text: ln.tryFreeFor1Week,
              fontSize: safeAreaWidth / 25,
              margin: nSpacing(top: safeAreaWidth * 0.04),
              safeAreaWidth: safeAreaWidth,
              beginColor: const Color.fromARGB(255, 0, 217, 255),
              endColor: const Color.fromARGB(255, 75, 147, 255),
              bold: 900,
            ),
          ]
        ],
      ),
    ),
  );
}

SliverToBoxAdapter titleWidget(
  double safeAreaWidth, {
  required String text,
  double? fontSize,
}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: nSpacing(
        top: safeAreaWidth * 0.07,
        bottom: safeAreaWidth * 0.04,
        left: safeAreaWidth * 0.05,
      ),
      child: nText(
        text,
        textAlign: TextAlign.left,
        color: blackColor.withCustomOpacity(0.4),
        fontSize: fontSize ?? safeAreaWidth / 23,
      ),
    ),
  );
}

List<SliverToBoxAdapter> settingItemList(
  double safeAreaWidth, {
  required List<SettingItemType> itemList,
  Widget? rightWidget,
  Widget? bottomWidget,
  double topPadding = 0,
}) {
  final border = Colors.black.withCustomOpacity(0.05);
  String? toAsset(int index) {
    if (itemList[index].itemImage == null) return null;
    return "icon/black/${itemList[index].itemImage}";
  }

  return List.generate(
    itemList.length,
    (index) => SliverToBoxAdapter(
      child: CustomAnimatedOpacityButton(
        onTap: itemList[index].onTap,
        vibration: () => HapticFeedback.selectionClick(),
        child: nContainer(
          margin: nSpacing(top: topPadding, xSize: safeAreaWidth * 0.03),
          customBorderRadius: nBorderRadius(
            radius: 15,
            isOnlyTop: index == 0,
            isOnlyBottom: index == itemList.length - 1,
          ),
          border: index != itemList.length - 1
              ? nBorder(isOnlyBottom: true, color: border)
              : null,
          padding: nSpacing(ySize: safeAreaWidth * 0.02),
          boxShadow: nBoxShadow(shadow: 0.02),
          color: Colors.white,
          child: Column(
            children: [
              nListItem(
                safeAreaWidth,
                padding: nSpacing(
                  xSize: safeAreaWidth * 0.03,
                  ySize: safeAreaWidth * 0.01,
                ),
                textColor: blackColor,
                mainText: itemList[index].itemName,
                assetImgData: toAsset(index),
                leftWidget: itemList[index].customImage != null
                    ? nContainer(
                        margin: nSpacing(
                          ySize: safeAreaWidth * 0.02,
                          right: safeAreaWidth * 0.03,
                        ),
                        squareSize: safeAreaWidth * 0.06,
                        image: assetImg(itemList[index].customImage!),
                      )
                    : itemList[index].icon != null
                        ? nIcon(
                            itemList[index].icon,
                            padding: nSpacing(
                              ySize: safeAreaWidth * 0.015,
                              right: safeAreaWidth * 0.02,
                            ),
                            size: safeAreaWidth / 15,
                            color: blackColor,
                          )
                        : null,
                imageSize: safeAreaWidth * 0.1,
                itemPadding: safeAreaWidth * 0.01,
                rightWidget: Row(
                  children: [
                    if (itemList[index].value != null)
                      nContainer(
                        alignment: Alignment.centerRight,
                        width: safeAreaWidth * 0.3,
                        margin: nSpacing(right: safeAreaWidth * 0.02),
                        child: nText(
                          itemList[index].value ?? "",
                          fontSize: safeAreaWidth / 28,
                          color: itemList[index].valueColor,
                          isFit: true,
                          isOverflow: false,
                        ),
                      ),
                    rightWidget ??
                        nArrowIcon(
                          padding: nSpacing(right: safeAreaWidth * 0.02),
                          iconSize: safeAreaWidth / settingArrowIconSize,
                          rotation: 180,
                          color: blackColor,
                          opacity: 0.5,
                        ),
                  ],
                ),
              ),
              bottomWidget ?? const SizedBox(),
            ],
          ),
        ),
      ),
    ),
  );
}

SliverToBoxAdapter accountExitWidget(
  double safeAreaWidth, {
  required String text,
  required VoidCallback onTap,
}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: nSpacing(xSize: safeAreaWidth * 0.05, top: safeAreaWidth * 0.07),
      child: nButton(
        safeAreaWidth,
        backGroundColor: Colors.white,
        text: text,
        textColor: redColor,
        radius: 15,
        boxShadow: nBoxShadow(shadow: 0.02),
        onTap: onTap,
      ),
    ),
  );
}

SliverToBoxAdapter versionWidget(
  double safeAreaWidth,
  ValueNotifier<String?> version,
) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: nSpacing(top: safeAreaWidth * 0.05),
      child: nText(
        version.value ?? "",
        fontSize: safeAreaWidth / 30,
        bold: 500,
        color: blackColor.withCustomOpacity(),
      ),
    ),
  );
}
