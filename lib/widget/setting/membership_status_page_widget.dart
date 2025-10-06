import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';

List<SliverToBoxAdapter> membershipItemList(
  double safeAreaWidth, {
  required List<SettingItemType> itemList,
  Widget? rightWidget,
  Widget? bottomWidget,
  double topPadding = 0,
}) {
  final borderColor = Colors.black.withCustomOpacity(0.05);
  final boder = nBorder(isOnlyBottom: true, color: borderColor);
  return List.generate(
    itemList.length,
    (index) => SliverToBoxAdapter(
      child: nContainer(
        margin: nSpacing(top: topPadding, xSize: safeAreaWidth * 0.03),
        customBorderRadius: nBorderRadius(
          radius: 15,
          isOnlyTop: index == 0,
          isOnlyBottom: index == itemList.length - 1,
        ),
        border: index != itemList.length - 1 ? boder : null,
        padding: nSpacing(ySize: safeAreaWidth * 0.02),
        boxShadow: nBoxShadow(shadow: 0.02),
        color: Colors.white,
        child: nListItem(
          safeAreaWidth,
          padding: nSpacing(
            xSize: safeAreaWidth * 0.03,
            ySize: safeAreaWidth * 0.01,
          ),
          textColor: blackColor.withCustomOpacity(0.1),
          mainText: "",
          itemPadding: safeAreaWidth * 0.02,
          leftWidget: SizedBox(height: safeAreaWidth * 0.1),
          customMainText: nText(
            itemList[index].itemName,
            fontSize: safeAreaWidth / 28,
            color: Colors.black.withCustomOpacity(),
          ),
          rightWidget: itemList[index].value != null
              ? nText(
                  itemList[index].value ?? "",
                  padding: nSpacing(right: safeAreaWidth * 0.03),
                  fontSize: safeAreaWidth / 28,
                  color: blackColor.withCustomOpacity(
                    itemList[index].value == "　ー　" ? 0.2 : 1,
                  ),
                  isFit: true,
                  isOverflow: false,
                )
              : nIndicatorWidget(
                  padding: nSpacing(right: safeAreaWidth * 0.03),
                  size: safeAreaWidth / 40,
                  color: blackColor,
                ),
        ),
      ),
    ),
  );
}
