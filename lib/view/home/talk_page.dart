import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/liked_me_users_page.dart';
import 'package:demo_project/view/page/payment_page.dart';
import 'package:demo_project/view/talk/connecting_page.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:demo_project/view_model/matching_users.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/widget/home/page/talk_page_widget.dart';
import 'package:demo_project/widget/setting/block_users_page_widget.dart';

class TalkPage extends HookConsumerWidget {
  const TalkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatLogState = ref.watch(chatLogsNotifierProvider);
    final likedMeUsersState = ref.watch(likedMeUsersNotifierProvider);
    final matchingUsers = getMatchingUsers(ref);
    final isNotTopContents = getIsNotTopContentst(ref);

    // useEffect(handleEffect(context), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;

        return nContainer(
          gradient: mainGradation(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: talkPageAppBar(context, safeAreaWidth),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  if (!isNotTopContents)
                    notTalkTitleWidget(context, safeAreaWidth),
                  topWidgetContainer(
                    constraints,
                    children: [
                      likedMeUsersItem(
                        ref,
                        safeAreaWidth,
                        likedMeUsersState,
                        onLikedMeUsers(context, ref),
                      ),
                      if (matchingUsers == null)
                        ..._notChatloading(safeAreaWidth)
                      else
                        for (final user in matchingUsers)
                          usersItem(context, safeAreaWidth, user),
                    ],
                  ),
                ],
              ),
            ),
            bottomSheet: nContainer(
              duration: const Duration(milliseconds: 100),
              height: safeAreaHeight * (!isNotTopContents ? 0.69 : 0.84),
              color: mainBackgroundColor,
              radius: 35,
              child: Column(
                children: [
                  historyTitleWidget(context, safeAreaWidth),
                  Expanded(
                    child: nCustomScrollView(
                      slivers: chatLogState.when(
                        error: (_, __) => notDataItem(safeAreaWidth, ""),
                        loading: () => loadingWidget(context),
                        data: (data) {
                          if (data == null) return loadingWidget(context);
                          if (data.isEmpty) {
                            return notTalkWidgets(context, constraints);
                          }

                          return [
                            for (final log in data)
                              talkItemWidget(
                                context,
                                safeAreaWidth,
                                log,
                                onTap: onChat(context, log.user),
                              ),
                          ];
                        },
                      ),
                    ),
                  ),
                  nContainer(height: safeAreaHeight * 0.1),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// Dispose? Function() handleEffect(BuildContext context) {
//   return () {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {});
//     return null;
//   };
// }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onChat(BuildContext context, UserPreviewType user) {
    return () {
      final ln = AppLocalizations.of(context)!;
      nDialog(
        context,
        title: ln.startChatTitle,
        content: ln.startChatDescription,
        mainItem: MenuItemType(
            itemName: ln.actionButtonStartChat,
            color: Colors.blueAccent,
            onTap: () {
              final page = ConnectingPage(targetUser: user);
              ScreenTransition(context, page).normal();
            }),
      );
    };
  }

  VoidCallback onLikedMeUsers(BuildContext context, WidgetRef ref) {
    return () {
      final subsc = ref.watch(subscriptionNotifierProvider).value;
      if (subsc == null) return;
      final isSubsc = subsc.activeSub != null;
      final page = isSubsc ? const LikedMeUsersPage() : const PaymentPage();
      ScreenTransition(context, page).top();
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  List<UserPreviewType>? getMatchingUsers(WidgetRef ref) {
    final chatLogState = ref.watch(chatLogsNotifierProvider);
    final users = ref.watch(matchingUsersNotifierProvider).value;
    final ids = chatLogState.value?.map((e) => e.user.id).toList() ?? [];
    final notTalkUsers = users?.where((e) => !ids.contains(e.id)).toList();
    return notTalkUsers;
  }

  bool getIsNotTopContentst(WidgetRef ref) {
    final state = ref.watch(likedMeUsersNotifierProvider);
    final matchingUsers = getMatchingUsers(ref);
    final data = state.value;
    final isBadData = (data?.users ?? []).isEmpty || (data?.count ?? 0) == 0;

    if (state.isLoading || state.value == null) return false;
    return isBadData && matchingUsers != null && matchingUsers.isEmpty;
  }

  List<Widget> _notChatloading(double safeAreaWidth) {
    return [
      for (int i = 0; i < 5; i++)
        Padding(
          padding: nSpacing(left: safeAreaWidth * 0.03),
          child: userLoadingWidget(safeAreaWidth),
        ),
    ];
  }
}
