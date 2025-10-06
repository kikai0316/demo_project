import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/widget/home/page/account_page_widget.dart';

class HelpPage extends HookConsumerWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: nAppBar(context, safeAreaWidth, title: ln.help),
      body: nCustomScrollView(
        slivers: [
          // singleItem(
          //   safeAreaWidth,
          //   topPadding: safeAreaWidth * 0.05,
          //   text: ln.faq,
          //   itemImage: "help.png",
          //   onTap: () => nOpneUrl(ln.faqUrl),
          // ),
          singleItem(
            safeAreaWidth,
            topPadding: safeAreaWidth * 0.05,
            text: ln.contactUs,
            itemImage: "mail.png",
            onTap: () => nOpneUrl(ln.contactUrl),
          ),
          singleItem(
            safeAreaWidth,
            topPadding: safeAreaWidth * 0.05,
            text: ln.reportProblem,
            itemImage: "info.png",
            onTap: () => nOpneUrl(ln.problemUrl),
          ),
        ],
      ),
    );
  }
}

SliverToBoxAdapter singleItem(
  double safeAreaWidth, {
  required String text,
  required String itemImage,
  required VoidCallback onTap,
  double topPadding = 0,
}) =>
    settingItemList(
      safeAreaWidth,
      topPadding: topPadding,
      itemList: [
        SettingItemType(itemName: text, itemImage: itemImage, onTap: onTap),
      ],
    )[0];
