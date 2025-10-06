import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';

void nDialog(
  BuildContext context, {
  required String title,
  MenuItemType? mainItem,
  MenuItemType? customCansellItem,
  String? content,
  String? cancelText,
  VoidCallback? customCancelButon,
  bool barrierDismissible = true,
}) =>
    showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (
        BuildContext context,
      ) {
        final ln = AppLocalizations.of(context)!;
        return CupertinoTheme(
          data: const CupertinoThemeData(brightness: Brightness.light),
          child: CupertinoAlertDialog(
            title: _titleWidget(
              context,
              title,
              blackColor,
            ),
            content: _contentWidget(context, content, blackColor),
            actions: <Widget>[
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  customCansellItem?.onTap?.call();
                  customCancelButon?.call();
                },
                child: _textWidget(
                  context,
                  customCansellItem?.itemName ?? cancelText ?? ln.cancel,
                  color: customCansellItem?.color ?? blackColor,
                ),
              ),
              if (mainItem != null)
                CupertinoDialogAction(
                  child: _textWidget(
                    context,
                    mainItem.itemName,
                    color: mainItem.color,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    mainItem.onTap?.call();
                  },
                ),
            ],
          ),
        );
      },
    );
Widget _textWidget(
  BuildContext context,
  String text, {
  required Color? color,
  double? fontSize,
  double bold = 500,
  double height = 1,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nText(
    text,
    fontSize: fontSize ?? (safeAreaWidth / 25),
    bold: bold,
    color: color ?? Colors.black,
    isOverflow: false,
    height: height,
  );
}

Widget _titleWidget(
  BuildContext context,
  String title,
  Color color,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return _textWidget(
    context,
    title,
    color: color,
    fontSize: safeAreaWidth / 23,
    bold: 800,
    height: 1.2,
  );
}

Widget? _contentWidget(BuildContext context, String? content, Color color) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  if (content == null) return null;
  return Padding(
    padding: nSpacing(top: safeAreaWidth * 0.03),
    child: _textWidget(
      context,
      content,
      color: color.withCustomOpacity(0.5),
      fontSize: safeAreaWidth / 30,
      height: 1.3,
    ),
  );
}

void nErrorDialog(
  BuildContext context, [
  String? content,
  void Function()? customCancelButon,
]) {
  final ln = AppLocalizations.of(context)!;
  nDialog(
    context,
    title: ln.error,
    content: content ?? ln.errorUnexpected,
    customCancelButon: customCancelButon,
    cancelText: "OK",
  );
}
