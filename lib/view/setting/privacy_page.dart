import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/setting/privacy_page/block_users_page.dart';
import 'package:demo_project/widget/setting/edti_setting_page_widget.dart';

class PrivacyPage extends HookConsumerWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    // useEffect(handleEffect(context), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        // final safeAreaHeight = constraints.maxHeight;
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          appBar: nAppBar(context, safeAreaWidth, title: ln.privacy),
          body: nCustomScrollView(
            slivers: [
              settingItemWithDescription(
                safeAreaWidth,
                descriptionText: ln.blockedUserDescription,
                text: ln.blockedUsers,
                item: SettingItemType(
                  itemName: ln.blockedUsers,
                  itemImage: "block.png",
                  onTap: onBlockUsers(context),
                ),
              ),
              // settingItemWithDescription(
              //   safeAreaWidth,
              //   descriptionText: ln.closeFriendsDescription,
              //   text: ln.blockedUsers,
              //   item: SettingItemType(
              //     itemName: ln.closeFriends,
              //     itemImage: "block.png",
              //     onTap: () {},
              //     // onTap: userBlockAndMuteOnTap(
              //     //   context,
              //     //   userData,
              //     //   AccessCtrlType.block,
              //     // ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onBlockUsers(BuildContext context) {
    return () {
      const page = BlockUsersPage();
      ScreenTransition(context, page).normal();
    };
  }
}
