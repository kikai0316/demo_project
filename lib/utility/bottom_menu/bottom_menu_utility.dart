import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';

void nShowBottomMenu(
  BuildContext context, {
  String? title,
  required List<MenuItemType> itemList,
  bool isCancelButton = true,
  Color cancelColor = redColor,
  VoidCallback? onShow,
  void Function(bool)? onDismiss,
  Widget? customTitleWidget,
}) {
  showCupertinoModalPopup(
    context: context,
    barrierColor: Colors.black.withCustomOpacity(0.5),
    builder: (BuildContext context) {
      onShow?.call();
      return CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoActionSheet(
          actions: [
            _titleWidget(context, customTitleWidget, title),
            for (int i = 0; i < itemList.length; i++)
              _actionsItem(
                context,
                item: itemList[i],
                isBoder: i != itemList.length - 1,
              ),
          ],
          cancelButton:
              isCancelButton ? _cancelButton(context, cancelColor) : null,
        ),
      );
    },
  ).then((result) => onDismiss?.call(result != 'select'));
}

Widget _textWidget(
  BuildContext context,
  String text, {
  required Color color,
  double? fontSize,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final textSize = fontSize ?? (safeAreaWidth / 24);
  return nText(
    text,
    fontSize: textSize,
    color: color,
    isOverflow: false,
  );
}

Widget _titleWidget(
  BuildContext context,
  Widget? customWidget,
  String? title,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  if (customWidget != null) return customWidget;
  if (title == null) return const SizedBox.shrink();
  return DecoratedBox(
    decoration: const BoxDecoration(color: Colors.white),
    child: Padding(
      padding: nSpacing(ySize: safeAreaWidth * 0.04),
      child: _textWidget(
        context,
        title,
        color: blackColor.withCustomOpacity(),
        fontSize: safeAreaWidth / 28,
      ),
    ),
  );
}

Widget _cancelButton(BuildContext context, Color cancelColor) {
  final ln = AppLocalizations.of(context)!;
  return CupertinoActionSheetAction(
    isDefaultAction: true,
    onPressed: () => Navigator.pop(context),
    child: _textWidget(context, ln.cancel, color: cancelColor),
  );
}

Widget _actionsItem(
  BuildContext context, {
  required MenuItemType item,
  required bool isBoder,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final iconSize = safeAreaWidth / 18;
  return CustomAnimatedOpacityButton(
    onTap: () {
      Navigator.of(context).pop("select");
      item.onTap?.call();
    },
    child: DecoratedBox(
      decoration: const BoxDecoration(color: Colors.white),
      child: CupertinoActionSheetAction(
        onPressed: () {},
        child: nContainer(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.addWidget ?? const SizedBox(),
              if (item.itemIcon != null)
                nIcon(
                  padding: nSpacing(right: safeAreaWidth * 0.01),
                  item.itemIcon,
                  color: item.color ?? Colors.white,
                  size: iconSize,
                ),
              _textWidget(
                context,
                item.itemName,
                color: item.color ?? Colors.blue,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
