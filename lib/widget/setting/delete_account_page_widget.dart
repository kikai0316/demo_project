import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';

SliverToBoxAdapter delAccTextItem(
  double safeAreaWidth,
  String text, {
  double? fontSize,
  Color color = blackColor,
  double? top,
}) {
  final topSize = top ?? safeAreaWidth * 0.13;
  return SliverToBoxAdapter(
    child: nText(
      text,
      padding: nSpacing(top: topSize, xSize: safeAreaWidth * 0.05),
      color: color,
      fontSize: fontSize ?? safeAreaWidth / 20,
      height: 1.4,
      isOverflow: false,
    ),
  );
}

SliverToBoxAdapter delAccReasonItem(
  BuildContext context,
  double safeAreaWidth,
  ValueNotifier<int?> selectIndex,
  ValueNotifier<String?> otherReason, {
  required List<String> reasonList,
}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: nSpacing(top: safeAreaWidth * 0.05, xSize: safeAreaWidth * 0.08),
      child: Column(
        children: List.generate(5, (index) {
          final isSelect = selectIndex.value == index;
          final isOther = index == 4;
          final reason = reasonList[index];
          return Padding(
            padding: nSpacing(top: safeAreaWidth * 0.04),
            child: CustomAnimatedButton(
              onTap: () async {
                selectIndex.value = index;
                if (index != 4) return;

                await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _delAccOtherReasonSheet(context, otherReason),
                );
              },
              vibration: () => HapticFeedback.mediumImpact(),
              child: Row(
                children: [
                  nContainerWithCircle(
                    margin: nSpacing(right: safeAreaWidth * 0.05),
                    squareSize: safeAreaWidth * 0.08,
                    border: nBorder(
                      color: isSelect ? Colors.blue : blackColor,
                      width: 1.5,
                    ),
                    color: isSelect ? Colors.blue : null,
                    child: isSelect ? nIcon(Icons.check) : null,
                  ),
                  Expanded(
                    child: nText(
                      !isOther ? reason : otherReason.value ?? reason,
                      fontSize: safeAreaWidth / 25,
                      isOverflow: false,
                      textAlign: TextAlign.left,
                      color: isOther && otherReason.value == null
                          ? blackColor.withCustomOpacity()
                          : blackColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}

Widget delAccButtonItem(
  double safeAreaWidth,
  String text, {
  VoidCallback? onTap,
  required bool isDelete,
}) {
  return nButton(
    safeAreaWidth,
    margin: nSpacing(top: safeAreaWidth * 0.06, xSize: safeAreaWidth * 0.05),
    onTap: onTap,
    backGroundColor:
        isDelete ? redColor.withCustomOpacity(0.1) : Colors.blueAccent,
    width: safeAreaWidth * 0.9,
    textColor: !isDelete ? Colors.white : redColor,
    boxShadow: !isDelete ? nBoxShadow(shadow: 0.05) : null,
    border: isDelete ? nBorder(color: redColor, width: 2) : null,
    text: text,
    radius: 15,
  );
}

Widget _delAccOtherReasonSheet(
  BuildContext context,
  ValueNotifier<String?> otherReason,
) {
  final ln = AppLocalizations.of(context)!;

  final borderColor = blackColor.withCustomOpacity(0.1);
  final borderSide = BorderSide(color: borderColor, width: 2);
  return LayoutBuilder(
    builder: (context, constraints) {
      final safeAreaWidth = constraints.maxWidth;
      final safeAreaHeight = constraints.maxHeight;
      return nBottomSheetScaffold(
        context,
        safeAreaWidth,
        height: safeAreaHeight * 0.6,
        isAppBar: false,
        body: Column(
          children: [
            nText(
              ln.unsubscribeReasonPrompt,
              padding: nSpacing(
                top: safeAreaHeight * 0.04,
                bottom: safeAreaHeight * 0.02,
              ),
              fontSize: safeAreaWidth / 23,
              color: blackColor,
            ),
            Row(
              children: [
                nTextFormField(
                  initialValue: otherReason.value,
                  padding: nSpacing(xSize: safeAreaWidth * 0.05),
                  fontSize: safeAreaWidth / 25,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  enabledBorder: UnderlineInputBorder(borderSide: borderSide),
                  focusedBorder: UnderlineInputBorder(borderSide: borderSide),
                  textColor: blackColor,
                  onFieldSubmitted: (value) {
                    otherReason.value = value;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
