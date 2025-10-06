import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/bottom_menu/bottom_menu_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/phone_login/phone_login_page.dart';
import 'package:demo_project/view/setting/help_page.dart';
import 'package:demo_project/view/setting/info_page.dart';
import 'package:demo_project/view/setting/membership_status_page.dart';
import 'package:demo_project/view/setting/other_page.dart';
import 'package:demo_project/view/setting/privacy_page.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/home/page/account_page_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final user = ref.watch(userDataNotifierProvider).value;
    final version = useState<String?>(null);
    final isLoading = useState<bool>(false);

    VoidCallback screenTransition(Widget page) {
      return () => ScreenTransition(context, page).normal();
    }

    useEffect(handleEffect(context, version), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;
        return Stack(
          children: [
            Scaffold(
              backgroundColor: mainBackgroundColor,
              appBar: accountPageAppBar(context, safeAreaWidth),
              resizeToAvoidBottomInset: false,
              body: nCustomScrollView(
                slivers: [
                  profileItem(context, safeAreaWidth, user),
                  membershipStatusWidget(
                    context,
                    ref,
                    safeAreaWidth,
                    screenTransition(const MembershipStatusPage()),
                  ),
                  titleWidget(safeAreaWidth, text: ln.settings),
                  ...settingItemList(
                    safeAreaWidth,
                    itemList: [
                      SettingItemType(
                        itemName: ln.privacy,
                        itemImage: "privacy.png",
                        onTap: screenTransition(const PrivacyPage()),
                      ),
                      SettingItemType(
                        itemName: ln.language,
                        itemImage: "language.png",
                        onTap: () => openAppSettings(),
                      ),
                      SettingItemType(
                        itemName: ln.otherSettings,
                        itemImage: "others.png",
                        onTap: screenTransition(const OtherSettingPage()),
                      ),
                    ],
                  ),
                  // "information":"情報"
                  titleWidget(safeAreaWidth, text: ln.information),
                  ...settingItemList(
                    safeAreaWidth,
                    itemList: [
                      SettingItemType(
                        itemName: ln.rateSUP,
                        itemImage: "star.png",
                        onTap: onReview(context, isLoading),
                      ),
                      SettingItemType(
                        itemName: ln.help,
                        itemImage: "help.png",
                        onTap: screenTransition(const HelpPage()),
                      ),
                      SettingItemType(
                        itemName: ln.basicInformation,
                        itemImage: "info.png",
                        onTap: screenTransition(const InfoPage()),
                      ),
                    ],
                  ),
                  accountExitWidget(
                    safeAreaWidth,
                    text: ln.logout,
                    onTap: onLogOut(context, ref, isLoading),
                  ),
                  versionWidget(safeAreaWidth, version),
                  nSliverSpacer(safeAreaHeight * 0.15),
                ],
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(
    BuildContext context,
    ValueNotifier<String?> version,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final getInfo = await PackageInfo.fromPlatform();
        if (context.mounted) version.value = "Version. ${getInfo.version}";
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onReview(BuildContext context, ValueNotifier<bool> isLoading) {
    final InAppReview inAppReview = InAppReview.instance;
    return () async {
      if (!await inAppReview.isAvailable()) return;
      isLoading.value = true;
      await inAppReview.requestReview();
      if (context.mounted) isLoading.value = false;
    };
  }

  VoidCallback onLogOut(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) {
    final ln = AppLocalizations.of(context)!;
    return () => nShowBottomMenu(
          context,
          cancelColor: Colors.blue,
          title: ln.confirmLogout,
          itemList: [
            MenuItemType(
              itemName: ln.logout,
              color: redColor,
              onTap: _executeLogout(context, ref, isLoading),
            ),
          ],
        );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//ログアウトの実行
  VoidCallback _executeLogout(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) {
    final notifier = ref.read(userDataNotifierProvider.notifier);
    const initialPage = PhoneLoginPage();
    return () async {
      isLoading.value = true;
      final isSuccess = await notifier.logOut();
      if (!context.mounted) return;
      if (!isSuccess) nErrorDialog(context);
      if (!isSuccess) isLoading.value = false;
      if (isSuccess) ScreenTransition(context, initialPage).hero();
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
}
