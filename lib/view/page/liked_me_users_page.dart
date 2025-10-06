import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_match_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/match_success_page.dart';
import 'package:demo_project/view/page/user_profile_page.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:demo_project/view_model/swipe_users.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/page/liked_me_users_page_widget.dart';
import 'package:demo_project/widget/setting/block_users_page_widget.dart';

class LikedMeUsersPage extends HookConsumerWidget {
  const LikedMeUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final data = ref.watch(likedMeUsersNotifierProvider);
    final isLoading = useState<bool>(!(data.value?.isFetch ?? false));

    useEffect(handleEffect(context, ref, isLoading), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          appBar: nAppBar(
            context,
            safeAreaWidth,
            title: ln.whoLikesYou,
            leftIconType: AppBarLeftIconType.down,
          ),
          body: data.when(
            error: (_, __) => nCustomScrollView(
              onRefresh: onRefresh(ref),
              slivers: notDataItem(safeAreaWidth, ln.someErrorOccurred),
            ),
            loading: () => likedMeUserLoadingWidget(context),
            data: (data) {
              final users = data?.users ?? [];
              if (isLoading.value) return likedMeUserLoadingWidget(context);
              return nCustomScrollView(
                onRefresh: onRefresh(ref),
                slivers: [
                  SliverToBoxAdapter(
                    child: nContainer(
                      padding: nSpacing(xSize: safeAreaWidth * 0.03),
                      width: double.infinity,
                      child: Wrap(
                        runAlignment: WrapAlignment.spaceBetween,
                        alignment: WrapAlignment.spaceBetween,
                        runSpacing: safeAreaWidth * 0.02,
                        children: [
                          for (final user in users)
                            likedMeUserItem(
                              context,
                              safeAreaWidth,
                              user,
                              onUser(context, ref, user),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (users.isEmpty)
                    ...notDataItem(
                      safeAreaWidth,
                      ln.noMoreUsers.split('\n').first,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final myId = ref.watch(userDataNotifierProvider).value?.id ?? "";
        final notifier = ref.read(likedMeUsersNotifierProvider.notifier);
        if (!isLoading.value) return;
        await notifier.fetch(myId);
        if (context.mounted) isLoading.value = false;
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onUser(
    BuildContext context,
    WidgetRef ref,
    UserPreviewType user,
  ) {
    return () {
      final page = UserProfilePage(user: user.toUserType(), isInitialize: true);
      final transition = ScreenTransition(context, page);
      transition.top<Map<String, dynamic>>(onPop: onPop(context, ref, user));
    };
  }

  dynamic Function(Map<String, dynamic>?)? onPop(
    BuildContext context,
    WidgetRef ref,
    UserPreviewType user,
  ) {
    return (value) {
      final myUserData = ref.watch(userDataNotifierProvider).value;
      final action = value?["action"] as SwipeActionType?;
      if (action == null || myUserData == null) return;
      final actionIndex = action.isLike() ? 2 : 1;
      apiCreateMatch(myUserData.id, user.id, actionIndex);
      _swipeActionCallNotifier(ref, user);
      if (!context.mounted) return;
      if (action.isLike()) {
        final data = myUserData.toUserPreviewType();
        final page = MatchSuccessPage(myData: data, partner: user);
        ScreenTransition(context, page).normal();
      }
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<void> Function()? onRefresh(WidgetRef ref) {
    return () async {
      final myId = ref.watch(userDataNotifierProvider).value?.id ?? "";
      await ref.read(likedMeUsersNotifierProvider.notifier).fetch(myId);
    };
  }

  Future<void> _swipeActionCallNotifier(
    WidgetRef ref,
    UserPreviewType user,
  ) async {
    final likedNotifier = ref.read(likedMeUsersNotifierProvider.notifier);
    final swipeUsersNotifier =
        ref.read(swipeUsersDataNotifierProvider.notifier);
    await swipeUsersNotifier.delete(user.id);
    await likedNotifier.action(user.id);
  }
}
