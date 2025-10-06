import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/l10n/app_localizations.dart';

Future<String?> nShowbottomSelectTextSheet(
  BuildContext context, {
  required BoxConstraints constraints,
  required List<String> items,
  required String title,
  String? initValue,
}) async {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  String selectedValue = initValue ?? items.first;

  final result = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return nBottomSheetScaffold(
        context,
        safeAreaWidth,
        height: safeAreaHeight * 0.5,
        title: title,
        rightWidget: _doneButton(
          context,
          onTap: () => Navigator.pop(context, selectedValue),
        ),
        body: _body(
          context,
          items: items,
          scrollController: _scrollController(items, initValue),
          onSelectedItemChanged: (i) => selectedValue = items[i],
        ),
      );
    },
  );

  return result;
}

Widget _doneButton(BuildContext context, {required VoidCallback onTap}) {
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return nTextButton(
    safeAreaWidth,
    onTap: onTap,
    vibration: () async {},
    text: ln.done2,
    fontSize: safeAreaWidth / 22,
  );
}

Widget _body(
  BuildContext context, {
  required List<String> items,
  FixedExtentScrollController? scrollController,
  required void Function(int)? onSelectedItemChanged,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Center(
    child: CupertinoPicker(
      magnification: 1.2,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: safeAreaWidth * 0.12,
      scrollController: scrollController,
      onSelectedItemChanged: onSelectedItemChanged,
      children: [
        for (final item in items)
          Center(
              child: nText(item,
                  fontSize: safeAreaWidth / 20, color: Colors.black)),
      ],
    ),
  );
}

FixedExtentScrollController? _scrollController(
  List<String> items,
  String? initValue,
) {
  final initialItem = initValue != null ? items.indexOf(initValue) : 0;
  return FixedExtentScrollController(initialItem: initialItem);
}
