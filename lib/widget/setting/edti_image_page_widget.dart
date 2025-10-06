import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/view/setting/edit_profile/edit_images_page.dart';

PreferredSizeWidget editImagePageAppBar(
  BuildContext context,
  double safeAreaWidth, {
  VoidCallback? onSave,
}) {
  final ln = AppLocalizations.of(context)!;
  return nAppBar(
    context,
    safeAreaWidth,
    title: ln.editReorder,
    leftIconType: AppBarLeftIconType.cancel,
    sideIconWidth: safeAreaWidth * 0.2,
    rightWidget: nTextButton(
      safeAreaWidth,
      onTap: onSave,
      text: ln.save,
      fontSize: safeAreaWidth / 20,
      color: Colors.blue.withCustomOpacity(onSave != null ? 1 : 0.3),
    ),
  );
}

//上部の画像
Widget mainImageItemWidget(
  BuildContext context,
  double safeAreaWidth, {
  PageController? controller,
  required int itemIndex,
  required ValueNotifier<ScreenState> screenState,
  required ValueNotifier<bool> isPageIndex,
  required ValueNotifier<List<EditImageItemType>> images,
  required void Function(FlowDirectionType)? onMove,
  required VoidCallback onTrimming,
  required VoidCallback? onDelete,
}) {
  final image = images.value[itemIndex];
  return Hero(
    tag: image.url ?? "",
    child: nContainer(
      margin: nSpacing(allSize: safeAreaWidth * 0.02),
      aspectRatio: mainAspectRatio,
      image: image.toDecoration(),
      radius: 20,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _pageIndexWidget(safeAreaWidth, itemIndex, isPageIndex),
          if (screenState.value.isActive())
            Padding(
              padding: nSpacing(allSize: safeAreaWidth * 0.05),
              child: Row(
                children: [
                  _movingIconButton(
                    context,
                    safeAreaWidth,
                    isPageIndex: isPageIndex,
                    isVisible: itemIndex != 0,
                    flow: FlowDirectionType.back,
                    onMove: onMove,
                  ),
                  SizedBox(width: safeAreaWidth * 0.03),
                  _movingIconButton(
                    context,
                    isVisible: itemIndex != images.value.length - 1,
                    safeAreaWidth,
                    isPageIndex: isPageIndex,
                    flow: FlowDirectionType.forward,
                    onMove: onMove,
                  ),
                  const Spacer(),
                  if (image.url == null)
                    _trimmingIconButton(safeAreaWidth, onTrimming),
                  SizedBox(width: safeAreaWidth * 0.03),
                  if (onDelete != null)
                    _deleteIconButton(safeAreaWidth, onDelete),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

//下部の画像
Widget bottomImageItemWidget(
  double safeAreaWidth, {
  required int itemIndex,
  required ValueNotifier<int> selectIndex,
  required ValueNotifier<int?> moveItemIndex,
  required EditImageItemType image,
  required VoidCallback onTap,
  bool isNewText = true,
}) {
  final boder = nBorder(color: Colors.blue, width: 3);
  final isMoving = (moveItemIndex.value ?? itemIndex) == itemIndex;
  return GestureDetector(
    key: ValueKey(itemIndex.toString()),
    onTap: onTap,
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isMoving ? 1 : 0.5,
      child: nContainer(
        color: mainBackgroundColor,
        margin: nSpacing(xSize: safeAreaWidth * 0.01),
        border: itemIndex == selectIndex.value ? boder : null,
        radius: 8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: nSpacing(allSize: safeAreaWidth * 0.005),
              child: nContainer(
                aspectRatio: mainAspectRatio,
                image: image.toDecoration(),
                radius: 7,
              ),
            ),
            if (image.file != null && isNewText)
              Transform.translate(
                offset: const Offset(6, -3),
                child: Transform.rotate(
                  angle: 0.3,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: nText(
                      "New",
                      fontSize: safeAreaWidth / 30,
                      color: Colors.cyanAccent,
                      shadows: nBoxShadow(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget? footerWidget(
  double safeAreaWidth,
  ValueNotifier<List<EditImageItemType>> images,
  VoidCallback onTap,
) {
  if (images.value.length >= 5) return null;
  return Align(
    child: nIconButton(
      onTap: onTap,
      margin: nSpacing(left: safeAreaWidth * 0.03),
      squareSize: safeAreaWidth * 0.1,
      iconData: Icons.add_rounded,
      backGroundColor: Colors.blueAccent,
    ),
  );
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// 上記に付随するWidget
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Widget _movingIconButton(
  BuildContext context,
  double safeAreaWidth, {
  required ValueNotifier<bool> isPageIndex,
  required bool isVisible,
  required FlowDirectionType flow,
  required void Function(FlowDirectionType)? onMove,
}) {
  return Transform.rotate(
    angle: flow.isBack() ? pi / -2 : pi / 2,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: nIconButton(
          squareSize: safeAreaWidth * 0.13,
          onTap: isVisible
              ? () {
                  isPageIndex.value = true;
                  onMove?.call(flow);
                  pageIndexTimer?.cancel();
                  pageIndexTimer = Timer(const Duration(milliseconds: 300), () {
                    if (context.mounted) isPageIndex.value = false;
                  });
                }
              : null,
          vibration: () => HapticFeedback.selectionClick(),
          iconImage: "black/arror_top.png",
          iconSize: safeAreaWidth / 15,
          imageCustomColor: Colors.black.withCustomOpacity(isVisible ? 1 : 0.3),
          backGroundColor: Colors.white,
        ),
      ),
    ),
  );
}

Widget _trimmingIconButton(double safeAreaWidth, VoidCallback onTap) {
  return nIconButton(
    squareSize: safeAreaWidth * 0.13,
    onTap: onTap,
    vibration: () => HapticFeedback.selectionClick(),
    iconImage: "black/trimming.png",
    iconSize: safeAreaWidth / 13,
    imageCustomColor: Colors.blue,
    backGroundColor: Colors.white,
  );
}

Widget _deleteIconButton(double safeAreaWidth, VoidCallback onTap) {
  return nIconButton(
    squareSize: safeAreaWidth * 0.13,
    onTap: onTap,
    vibration: () => HapticFeedback.selectionClick(),
    iconData: Icons.delete_rounded,
    iconSize: safeAreaWidth / 12,
    iconColor: Colors.red,
    backGroundColor: Colors.white,
  );
}

Widget _pageIndexWidget(
  double safeAreaWidth,
  int itemIndex,
  ValueNotifier<bool> isPageIndex,
) {
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 500),
    opacity: isPageIndex.value ? 1 : 0,
    child: nContainer(
      alignment: Alignment.center,
      color: Colors.black.withCustomOpacity(0.4),
      radius: 20,
      child: nText(
        (itemIndex + 1).toString(),
        fontSize: safeAreaWidth / 10,
      ),
    ),
  );
}
