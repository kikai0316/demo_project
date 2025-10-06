import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void nCustomDialog(BuildContext context, Widget content,
    [bool barrierDismissible = true, void Function(Widget)? onValue]) {
  const data = CupertinoThemeData(brightness: Brightness.light);
  showDialog<Widget?>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => CupertinoTheme(data: data, child: content),
  ).then((value) {
    if (onValue != null && value != null) onValue.call(value);
  });
}
