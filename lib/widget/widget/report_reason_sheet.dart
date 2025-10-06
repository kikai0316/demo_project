import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/widget/page/payment_page_widget.dart';
import 'package:demo_project/widget/widget/list_item_widget.dart';

class ReportReasonSelectionSheet extends HookConsumerWidget {
  const ReportReasonSelectionSheet({
    super.key,
    required this.onTap,
    this.isUserReport,
  });

  final Function(int, String) onTap;
  final bool? isUserReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final selectIndex = useState<int?>(null);
    final ln = AppLocalizations.of(context)!;
    final items = _items(context);
    return nBottomSheetScaffold(
      context,
      safeAreaWidth,
      height: safeAreaHeight * 0.95,
      title: ln.reportHeaderTitle,
      body: Stack(
        children: [
          nCustomScrollView(
            slivers: [
              _titleWidget(context),
              _subTitleWidget(context),
              sliverSpacer(safeAreaWidth * 0.1),
              _reasonSelectionsWidget(context, selectIndex),
              sliverSpacer(safeAreaHeight * 0.2),
            ],
          ),
          if (selectIndex.value != null)
            _confirmButton(
              context,
              safeAreaWidth,
              onTap: () {
                Navigator.pop(context);
                onTap(selectIndex.value!, items[selectIndex.value!]);
              },
            ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _titleWidget(BuildContext context) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final ln = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: nText(
        isUserReport == true ? ln.reasonUserHeader : ln.reasonMessageHeader,
        padding: nSpacing(top: safeAreaWidth * 0.05),
        fontSize: safeAreaWidth / 18,
        color: blackColor,
      ),
    );
  }
}

SliverToBoxAdapter _subTitleWidget(BuildContext context) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final ln = AppLocalizations.of(context)!;
  return SliverToBoxAdapter(
    child: nText(
      ln.disclaimerText,
      padding: nSpacing(top: safeAreaWidth * 0.05, xSize: safeAreaWidth * 0.05),
      fontSize: safeAreaWidth / 25,
      color: blackColor.withCustomOpacity(0.4),
      isOverflow: false,
      height: 1.3,
      bold: 600,
    ),
  );
}

SliverList _reasonSelectionsWidget(
  BuildContext context,
  ValueNotifier<int?> selectIndex,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final items = _items(context);
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return _reasonItem(
          safeAreaWidth,
          text: items[index],
          index: index,
          selectIndex: selectIndex,
        );
      },
      childCount: items.length,
    ),
  );
}

Widget _reasonItem(
  double safeAreaWidth, {
  required String text,
  required int index,
  required ValueNotifier<int?> selectIndex,
}) {
  return nListItem(
    safeAreaWidth,
    onTap: () => selectIndex.value = index,
    mainText: text,
    border: nBorder(
      color: Colors.black.withCustomOpacity(0.1),
      isOnlyTop: true,
      isOnlyBottom: index == 7,
    ),
    leftWidget: const SizedBox(),
    itemPadding: safeAreaWidth * 0.03,
    textColor: blackColor,
    rightWidget: nContainerWithCircle(
      margin: nSpacing(allSize: safeAreaWidth * 0.03),
      alignment: Alignment.center,
      squareSize: safeAreaWidth * 0.07,
      border: nBorder(color: Colors.blueAccent.withCustomOpacity(0.5)),
      color: Colors.blueAccent.withCustomOpacity(0.1),
      child: nContainer(
        duration: const Duration(milliseconds: 100),
        squareSize: safeAreaWidth * 0.07,
        radius: 100,
        color: index == selectIndex.value ? Colors.blueAccent : null,
      ),
    ),
  );
}

Widget _confirmButton(
  BuildContext context,
  double safeAreaWidth, {
  required void Function()? onTap,
}) {
  final ln = AppLocalizations.of(context)!;
  return Align(
    alignment: Alignment.bottomCenter,
    child: SafeArea(
      child: nButton(
        safeAreaWidth,
        onTap: onTap,
        width: safeAreaWidth * 0.9,
        backGroundColor: Colors.blueAccent,
        text: ln.done2,
        textColor: Colors.white,
        radius: 15,
      ),
    ),
  );
}

List<String> _items(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    ln.bullying,
    ln.selfHarm,
    ln.violence,
    ln.restrictedGoods,
    ln.nudity,
    ln.fraud,
    ln.misinformation,
    ln.intellectualProperty,
  ];
}
