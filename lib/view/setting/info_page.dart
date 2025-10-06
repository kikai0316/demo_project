import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/view/setting/help_page.dart';

class InfoPage extends HookConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: nAppBar(context, safeAreaWidth, title: ln.basicInformation),
      body: nCustomScrollView(
        slivers: [
          singleItem(
            safeAreaWidth,
            topPadding: safeAreaWidth * 0.05,
            text: ln.termsOfService,
            itemImage: "document.png",
            onTap: () => nOpneUrl(ln.termsUrl),
          ),
          singleItem(
            safeAreaWidth,
            topPadding: safeAreaWidth * 0.05,
            text: ln.privacyPolicy,
            itemImage: "document.png",
            onTap: () => nOpneUrl(ln.privacyUrl),
          ),
        ],
      ),
    );
  }
}
