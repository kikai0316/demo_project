import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/cache_utility.dart';
import 'package:demo_project/utility/fcm_utility.dart';
import 'package:demo_project/utility/firebase/realtime_utility.dart';
import 'package:demo_project/utility/notistack/custom_dialog_utility.dart';
import 'package:demo_project/view/home/account_page.dart';
import 'package:demo_project/view/home/swipe_page.dart';
import 'package:demo_project/view/home/talk_page.dart';
import 'package:demo_project/view/talk/incoming_dialog.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/home/page/home_page.dart';
import 'package:demo_project/widget/widget/surveillance_widget.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.userData});
  final UserType userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = useState<int>(0);

    useEffect(handleEffect(context, ref), []);

    return Surveillance(
      onForeground: onForeground(context, ref),
      onBackground: onBackground(context, ref),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final safeAreaHeight = constraints.maxHeight;
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: pageIndex.value,
              children: [
                SwipePage(userData: userData),
                const TalkPage(),
                const AccountPage(),
              ],
            ),
            //↓ボトムバー
            bottomNavigationBar: navigationBaseWidget(
              safeAreaHeight,
              color: [null, null, mainBackgroundColor][pageIndex.value],
              children: [
                for (int i = 0; i < 3; i++)
                  navigationItemWidget(
                    constraints,
                    icon: ["home.png", "talk.png", "account.png"][i],
                    onTap:
                        i != pageIndex.value ? () => pageIndex.value = i : null,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // useEffect
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(BuildContext context, WidgetRef ref) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final user = ref.watch(userDataNotifierProvider).value;
        //通知削除
        FlutterAppBadge.count(0);
        await fcmMessageListener?.cancel();
        fcmMessageListener = fcmMessageStreamListener(ref);
        setForegroundNotification();
        if (user == null) return;
        dbRTUserStateActiveOn(user.id);
        final messageId = await dbRTGetMessageId(user.id);
        if (!context.mounted || messageId == null) return;
        openIncomingDialog(context, messageId);
        dbRTCheckRoom(context, user);
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onForeground(BuildContext context, WidgetRef ref) {
    return () async {
      final id = ref.watch(userDataNotifierProvider).value?.id;
      if (!context.mounted || id == null) return;
      dbRTUserStateActiveOn(id);
      final messageId = await dbRTGetMessageId(id);
      if (!context.mounted || messageId == null) return;
      openIncomingDialog(context, messageId);
    };
  }

  VoidCallback onBackground(BuildContext context, WidgetRef ref) {
    return () {
      final id = ref.watch(userDataNotifierProvider).value?.id;
      if (context.mounted && id != null) dbRTUserStateActiveOFF(id);
    };
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // イベント
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<void> openIncomingDialog(
    BuildContext context,
    String messageId,
  ) async {
    await cacheImages(context, netImgs: [messageId.split('@')[3]]);
    if (!context.mounted) return;
    nCustomDialog(context, IncomingDialog(messageId: messageId), false);
  }

  Future<void> setForegroundNotification() async {
    final instance = FirebaseMessaging.instance;
    await instance.setForegroundNotificationPresentationOptions();
  }
}
