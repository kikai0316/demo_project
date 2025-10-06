import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/widget/home/page/account_page_widget.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';

PreferredSizeWidget? editProfileAppBar(
  BuildContext context,
  double safeAreaWidth, {
  required bool isLoading,
  required VoidCallback? onPreview,
}) {
  final ln = AppLocalizations.of(context)!;
  return nAppBar(
    context,
    safeAreaWidth,
    title: ln.editProfile,
    sideIconWidth: safeAreaWidth * 0.25,
    leftIconType:
        !isLoading ? AppBarLeftIconType.left : AppBarLeftIconType.none,
    rightWidget: nTextButton(
      safeAreaWidth,
      backgroundColor: Colors.blueAccent,
      onTap: onPreview,
      text: ln.preview,
      color: Colors.white,
      fontSize: safeAreaWidth / 40,
      padding: nSpacing(allSize: safeAreaWidth * 0.03),
      radius: 50,
    ),
  );
}

SliverToBoxAdapter editImagesItem(
  BuildContext context,
  double safeAreaWidth,
  UserType? user, {
  required void Function(int) onTap,
  required void Function(int) onAdd,
  required void Function(int) onEdit,
}) {
  Widget imageWidget(int index) {
    return _uploadImageWidget(
      context,
      safeAreaWidth: safeAreaWidth,
      itemIndex: index,
      user: user,
      onAdd: onAdd,
      onEdit: onEdit,
      onTap: onTap,
    );
  }

  return SliverToBoxAdapter(
    child: nContainer(
      padding: nSpacing(allSize: safeAreaWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          imageWidget(0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget(1),
              SizedBox(height: safeAreaWidth * 0.02),
              imageWidget(3),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget(2),
              SizedBox(height: safeAreaWidth * 0.02),
              imageWidget(4),
            ],
          ),
        ],
      ),
    ),
  );
}

SliverToBoxAdapter userProfileWidget(
  BuildContext context,
  double safeAreaWidth, {
  required String label,
  required String value,
  required double top,
  required VoidCallback onTap,
}) {
  final ln = AppLocalizations.of(context)!;
  final isBio = ln.aboutMe == label;
  return SliverToBoxAdapter(
    child: CustomAnimatedOpacityButton(
      onTap: onTap,
      vibration: () => HapticFeedback.selectionClick(),
      child: nContainer(
        margin: nSpacing(top: top, xSize: safeAreaWidth * 0.03),
        color: Colors.white,
        boxShadow: nBoxShadow(shadow: 0.05),
        radius: 15,
        child: nListItem(
          safeAreaWidth,
          itemPadding: 0,
          padding: nSpacing(allSize: safeAreaWidth * 0.05),
          mainText: "",
          customMainText: nText(
            label,
            fontSize: safeAreaWidth / 24,
            color: blackColor.withCustomOpacity(0.4),
          ),
          textColor: blackColor,
          leftWidget: const SizedBox.shrink(),
          rightWidget: nContainer(
            alignment: Alignment.centerLeft,
            width: safeAreaWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: nText(
                      value,
                      fontSize: safeAreaWidth / (!isBio ? 22 : 28),
                      color: blackColor,
                      isOverflow: !isBio,
                      height: isBio ? 1.2 : 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                nArrowIcon(
                  padding: nSpacing(left: safeAreaWidth * 0.02),
                  iconSize: safeAreaWidth / settingArrowIconSize,
                  rotation: 180,
                  color: blackColor,
                  opacity: 0.5,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

SliverToBoxAdapter settingItemWithDescription(
  double safeAreaWidth, {
  required String text,
  required SettingItemType item,
  required String descriptionText,
}) {
  return settingItemList(
    safeAreaWidth,
    itemList: [item],
    topPadding: safeAreaWidth * 0.05,
    bottomWidget: Align(
      alignment: Alignment.centerRight,
      child: nContainer(
        padding: nSpacing(
          top: safeAreaWidth * 0.03,
          bottom: safeAreaWidth * 0.01,
          right: safeAreaWidth * 0.03,
        ),
        width: safeAreaWidth * 0.8,
        border:
            nBorder(isOnlyTop: true, color: blackColor.withCustomOpacity(0.1)),
        child: nText(
          descriptionText,
          fontSize: safeAreaWidth / 33,
          isOverflow: false,
          color: blackColor.withCustomOpacity(),
          height: 1.5,
          bold: 500,
          textAlign: TextAlign.left,
        ),
      ),
    ),
  )[0];
}
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Widget _uploadImageWidget(
  BuildContext context, {
  required double safeAreaWidth,
  required int itemIndex,
  required UserType? user,
  required void Function(int) onTap,
  required void Function(int) onAdd,
  required void Function(int) onEdit,
}) {
  final isMain = itemIndex == 0;
  final size = safeAreaWidth * (isMain ? 0.46 : 0.22);
  final image = "image/upload_${itemIndex + 1}.png";
  final radius = isMain ? 20.0 : 10.0;

  String? getImage() {
    final images = user?.profileImages;
    if (images == null || images.isEmpty) return null;
    if (images.length > itemIndex) return images[itemIndex];
    return null;
  }

  final targetUrl = getImage();
  return Hero(
    tag: targetUrl ?? itemIndex,
    child: FittedBox(
      child: SizedBox(
        width: size,
        child: CustomAnimatedButton(
          onTap: () => (targetUrl != null ? onTap : onAdd).call(itemIndex),
          vibration: () => HapticFeedback.mediumImpact(),
          child: nContainer(
            aspectRatio: mainAspectRatio,
            radius: radius,
            color: Colors.grey.withCustomOpacity(0.3),
            image: targetUrl != null ? networkImg(targetUrl) : null,
            child: Stack(
              children: [
                if (targetUrl == null)
                  Opacity(
                    opacity: 0.1,
                    child: nContainer(image: assetImg(image), radius: radius),
                  ),
                if (targetUrl == null)
                  uploadBoderWidget(context, safeAreaWidth, itemIndex),
                if (targetUrl != null)
                  editIconButton(
                    safeAreaWidth,
                    onTap: () => onEdit.call(itemIndex),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget uploadBoderWidget(
  BuildContext context,
  double safeAreaWidth,
  int index,
) {
  final ln = AppLocalizations.of(context)!;
  final radius = index == 0 ? 20.0 : 10.0;
  return Padding(
    padding: nSpacing(allSize: safeAreaWidth * 0.002),
    child: nContainer(
      squareSize: double.infinity,
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: blackColor.withCustomOpacity(0.5),
        strokeWidth: 2,
        dashPattern: const [10, 5],
        radius: Radius.circular(radius),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              nContainer(
                color: blackColor,
                padding: nSpacing(allSize: safeAreaWidth * 0.001),
                radius: 10,
                child: nIcon(
                  Icons.add_rounded,
                  size: safeAreaWidth / 15,
                ),
              ),
              nText(
                index < 3 ? ln.facePhoto : ln.other,
                padding: nSpacing(top: safeAreaWidth * 0.02),
                fontSize: safeAreaWidth / 30,
                color: blackColor,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget editIconButton(double safeAreaWidth, {VoidCallback? onTap}) {
  return Align(
    alignment: Alignment.bottomRight,
    child: nIconButton(
      onTap: onTap,
      margin: nSpacing(allSize: safeAreaWidth * 0.02),
      padding: nSpacing(allSize: safeAreaWidth * 0.02),
      backGroundColor: Colors.blue.withCustomOpacity(0.8),
      iconData: Icons.edit_rounded,
      iconSize: safeAreaWidth / 20,
    ),
  );
}
