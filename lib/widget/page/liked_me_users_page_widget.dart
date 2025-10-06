import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/widget/widget/future_text_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

Widget likedMeUserItem(
  BuildContext context,
  double safeAreaWidth,
  UserPreviewType user,
  VoidCallback onTap,
) {
  return CustomAnimatedButton(
    onTap: onTap,
    child: SizedBox(
      width: safeAreaWidth * 0.46,
      child: nContainer(
        aspectRatio: mainAspectRatio,
        color: Colors.grey.withCustomOpacity(0.2),
        radius: 10,
        child: Stack(
          children: [
            CustomNetworkImageWidegt(
              safeAreaWidth: safeAreaWidth,
              url: user.profileImages.first,
              radius: 10,
            ),
            for (int i = 0; i < 2; i++)
              _fadeWidget(
                safeAreaWidth,
                [Alignment.topCenter, Alignment.bottomCenter][i],
              ),
            _locationWidget(context, safeAreaWidth, user),
            _nameAndAgeWidget(safeAreaWidth, user),
          ],
        ),
      ),
    ),
  );
}

Widget likedMeUserLoadingWidget(
  BuildContext context, [
  Color color = Colors.black,
]) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: nSpacing(top: safeAreaWidth * 0.05),
      child: nIndicatorWidget(size: safeAreaWidth * 0.03, color: color),
    ),
  );
}

List<Widget> likedMeUserNotDataItem(
  BuildContext context,
  double safeAreaWidth, [
  bool isLoadDataError = false,
]) {
  final ln = AppLocalizations.of(context)!;
  final text = isLoadDataError ? ln.errorLoadData : ln.someErrorOccurred;
  return [
    nContainer(
      width: double.infinity,
      margin: nSpacing(top: safeAreaWidth * 0.05),
      padding: nSpacing(allSize: safeAreaWidth * 0.08),
      color: Colors.white,
      boxShadow: nBoxShadow(shadow: 0.03),
      radius: 15,
      child: nText(text, fontSize: safeAreaWidth / 28, color: blackColor),
    ),
  ];
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Widget _nameAndAgeWidget(
  double safeAreaWidth,
  UserPreviewType user,
) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: nSpacing(allSize: safeAreaWidth * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          nContainer(
            maxWidth: safeAreaWidth * 0.27,
            child: nText(
              user.userName,
              fontSize: safeAreaWidth / 15,
              isFit: true,
              isOverflow: false,
            ),
          ),
          nText(
            user.toAge(),
            padding: nSpacing(left: safeAreaWidth * 0.03),
            fontSize: safeAreaWidth / 25,
          ),
        ],
      ),
    ),
  );
}

Widget _fadeWidget(double safeAreaWidth, Alignment aligment) {
  final colors = fadeGradation(aligment, 0.5);
  final isBottom = aligment == Alignment.bottomCenter;
  return Align(
    alignment: aligment,
    child: nContainer(
      height: safeAreaWidth * 0.2,
      gradient: nGradation(colors: colors),
      customBorderRadius: nBorderRadius(
        radius: 10,
        isOnlyBottom: isBottom,
        isOnlyTop: !isBottom,
      ),
    ),
  );
}

Widget _locationWidget(
  BuildContext context,
  double safeAreaWidth,
  UserPreviewType user,
) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: nSpacing(allSize: safeAreaWidth * 0.03),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          nIcon(Icons.location_on_rounded, size: safeAreaWidth / 25),
          FutureTextWidget(
            location: user.location,
            margin: nSpacing(left: safeAreaWidth * 0.01),
            fontSize: safeAreaWidth / 27,
            maxWidth: safeAreaWidth * 0.35,
          ),
        ],
      ),
    ),
  );
}
