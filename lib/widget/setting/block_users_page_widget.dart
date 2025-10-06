import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';

SliverToBoxAdapter blockUserItem(
  BuildContext context, {
  required BlockUserType data,
  required VoidCallback? onTap,
  required bool isLoading,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SliverToBoxAdapter(
    child: accountListItem(
      safeAreaWidth,
      mainText: data.user.userName,
      networkImg: data.user.profileImages.first,
      smallText: formatDaysSinceforBlock(context, data.createAt),
      textColor: blackColor,
      rightWidget: !isLoading
          ? nIconButton(
              onTap: onTap,
              iconData: Icons.close,
              iconColor: blackColor,
            )
          : _loading(context),
    ),
  );
}

List<SliverToBoxAdapter> loadingWidget(
  BuildContext context, [
  Color color = Colors.black,
]) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return [
    SliverToBoxAdapter(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: nSpacing(top: safeAreaWidth * 0.05),
          child: nIndicatorWidget(size: safeAreaWidth * 0.03, color: color),
        ),
      ),
    ),
  ];
}

List<SliverToBoxAdapter> notDataItem(double safeAreaWidth, String text) {
  return [
    SliverToBoxAdapter(
      child: nContainer(
        margin: nSpacing(
          xSize: safeAreaWidth * 0.05,
          top: safeAreaWidth * 0.05,
        ),
        padding: nSpacing(allSize: safeAreaWidth * 0.08),
        color: Colors.white,
        boxShadow: nBoxShadow(shadow: 0.03),
        radius: 15,
        child: nText(
          text,
          fontSize: safeAreaWidth / 30,
          color: blackColor,
          height: 1.3,
          isFit: true,
        ),
      ),
    ),
  ];
}

Widget _loading(BuildContext context, {bool isSmall = false}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nIndicatorWidget(
    padding: !isSmall ? nSpacing(right: safeAreaWidth * 0.01) : null,
    size: safeAreaWidth / (!isSmall ? 35 : 40),
    color: blackColor,
  );
}
