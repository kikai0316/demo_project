import 'dart:async';

import 'package:demo_project/component/widget_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/menu_function_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/path_provider_utility.dart';
import 'package:demo_project/utility/permission_handler_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/payment_page.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/view_model/swipe_users.dart';
import 'package:demo_project/widget/home/page/swipe_page_widget.dart';
import 'package:demo_project/widget/home/profile_card_widget.dart';
import 'package:permission_handler/permission_handler.dart';

final _controller = CardSwiperController();

class SwipePage extends HookConsumerWidget {
  const SwipePage({
    super.key,
    // required this.userData,
  });
  // final UserType userData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final swipeUsers = ref.watch(swipeUsersDataNotifierProvider).value;
    final currentIndex = useState<int>(getInitCurrentIndex(swipeUsers));
    final swipeAction = useState<SwipeActionType>(SwipeActionType.idle);
    final swipeCount = useState<int?>(null);
    final isLoading = useState<bool>(false);

    useEffect(handleEffect(context, ref, swipeCount), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return nContainer(
          squareSize: double.infinity,
          gradient: mainGradation(),
          child: Scaffold(
            backgroundColor: Colors.black,
            resizeToAvoidBottomInset: false,
            body: Stack(
              alignment: Alignment.center,
              children: [
                //リストが空の時のメッセージWidget
                // if (swipeUsers != null && swipeUsers.isEmpty)
                //   swipeUserDataEmptyWidget(
                //     context,
                //     safeAreaWidth,
                //     onReFetch: onReFetch(context, ref, isLoading, currentIndex),
                //   )
                // else
                if (swipeUsers != null)
                  emptyWidget(
                    context,
                    constraints,
                    currentIndex,
                    swipeUsers,
                    isLoading,
                    onReFetch: onReFetch(
                      context,
                      ref,
                      isLoading,
                      currentIndex,
                    ),
                  ),

                //上部のwidgets
                topWidgetContainer(
                  constraints,
                  children: [
                    logoWidget(safeAreaWidth),
                    proplanWidget(context, ref, safeAreaWidth),
                    // optionsIconWidget(safeAreaWidth, onOption()),
                  ],
                ),
                if (swipeUsers == null)
                  errorWidget(context, ref, safeAreaWidth, isLoading)
                else if (getIsSwipeWidget(swipeUsers)) ...[
                  swiperContainer(
                    constraints,
                    controller: _controller,
                    initialIndex: currentIndex.value,
                    length: swipeUsers.length,
                    onChanged: onSwipeChanged(
                      context,
                      ref,
                      currentIndex,
                      swipeCount,
                      swipeAction,
                    ),
                    onSwipeDirectionChange: onSwipeDirectionChange(swipeAction),
                    cardBuilder: (_, index, __, ___) {
                      return ProfileCardWidget(
                        key: ValueKey(index.toString()),
                        constraints: constraints,
                        currentIndex: currentIndex.value,
                        itemIndex: index,
                        swipeAction: swipeAction,
                        user: swipeUsers[index].user,
                        onAction: onAction(context, swipeAction),
                        onMenu: onMenu(
                          context,
                          ref,
                          swipeUsers[index].user.toUserPreviewType(),
                        ),
                      );
                    },
                  ),
                  swipeActionWidget(
                    constraints,
                    swipeAction,
                    onAction(context, swipeAction),
                  ),
                ],
              ],
            ),
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
    ValueNotifier<int?> swipeCount,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final subsc = ref.read(subscriptionNotifierProvider).value?.activeSub;
        openNonPermission(context);
        if (subsc == null) swipeCount.value = await localReadSwipeCounts();
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onReFetch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    ValueNotifier<int?> currentIndex,
  ) {
    return () async {
      // isLoading.value = true;
      // final notifier = ref.read(swipeUsersDataNotifierProvider.notifier);
      // await Future<void>.delayed(const Duration(milliseconds: 1000));
      // final newDatas = await notifier.reFetch(a);
      // if (!context.mounted) return;
      // isLoading.value = false;
      // if (newDatas == null) currentIndex.value = getInitCurrentIndex(newDatas);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  void Function(SwipeActionType) onAction(
    BuildContext context,
    ValueNotifier<SwipeActionType> swipeAction,
  ) {
    return (action) async {
      swipeAction.value = action;
      _controller.swipe(action.toDirection());
      await Future<void>.delayed(const Duration(milliseconds: 200));
      swipeAction.value = SwipeActionType.idle;
    };
  }

  FutureOr<bool> Function(int, int?, CardSwiperDirection)? onSwipeChanged(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<int> currentIndex,
    ValueNotifier<int?> swipeCount,
    ValueNotifier<SwipeActionType> swipeAction,
  ) {
    return (__, index, action) async {
      try {
        final swipeUsersState = ref.watch(swipeUsersDataNotifierProvider);
        final swipeUsers = swipeUsersState.value ?? [];
        final itemIndex = index != null ? index - 1 : swipeUsers.length - 1;

        //スワイプの制御（無料枠なら30回）
        if ((swipeCount.value ?? 0) >= 30) {
          ScreenTransition(context, const PaymentPage()).top();
          return false;
        }
        //トータルのスワイプを記録
        if (swipeCount.value != null) swipeCount.value = swipeCount.value! + 1;
        localWriteSwipeCounts();

        // //actionの更新
        autoReFetch(context, ref, itemIndex, swipeUsers);
        if (index != null) {
          currentIndex.value = index;
          swipeAction.value = SwipeActionType.idle;
        }

        return await triggerMatching(
          context,
          ref,
          itemIndex,
          action,
          swipeCount,
        );
      } catch (_) {}
      return true;
    };
  }

  void Function(CardSwiperDirection, CardSwiperDirection)?
      onSwipeDirectionChange(
    ValueNotifier<SwipeActionType?> swipeAction,
  ) {
    return (horizontal, _) {
      try {
        if (swipeAction.value == horizontal.toSwipeActionType()) return;
        HapticFeedback.mediumImpact();
        swipeAction.value = horizontal.toSwipeActionType();
      } catch (_) {}
    };
  }

  Future<void> openNonPermission(BuildContext context) async {
    final ln = AppLocalizations.of(context)!;
    final isPermission = await checkLocationPermission();
    if (isPermission || !context.mounted) return;
    nDialog(
      context,
      title: ln.locationOff,
      content: ln.locationPermissionWithRestart,
      mainItem: MenuItemType(
        itemName: ln.openSettings,
        color: Colors.blue,
        onTap: () => openAppSettings(),
      ),
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<bool> triggerMatching(
    BuildContext context,
    WidgetRef ref,
    int index,
    CardSwiperDirection direction,
    ValueNotifier<int?> currentIndex,
  ) async {
    try {
      // final swipeUsersState = ref.watch(swipeUsersDataNotifierProvider);
      // final swipeUsers = swipeUsersState.value ?? [];
      // final targetUser = swipeUsers[index].user;
      // final targetId = targetUser.id;
      // final action = direction.toSwipeActionType();
      // final myId = userData.id;

      // final isMatch = await apiCreateMatch(myId, targetId, action.toInt());
      // if (!context.mounted) return false;
      // ////成功////
      // if (isMatch == true) {
      //   final partner = targetUser.toUserPreviewType();
      //   final myData = userData.toUserPreviewType();
      //   final page = MatchSuccessPage(partner: partner, myData: myData);
      //   ScreenTransition(context, page).scale();
      // }
      // ////スワイプしたことをアップデート////
      // if (isMatch != null) {
      //   swipeActionCallNotifier(ref, targetUser.toUserPreviewType());
      //   return true;
      // }
      // ////エラー////
      // final ln = AppLocalizations.of(context)!;
      // HapticFeedback.vibrate();
      // nShowCenterSnackBar(context, message: ln.someErrorOccurred);
      // currentIndex.value = index;
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> autoReFetch(
    BuildContext context,
    WidgetRef ref,
    int index,
    List<SwipeUserType> swipeUsers,
  ) async {
    // try {
    //   final notifier = ref.read(swipeUsersDataNotifierProvider.notifier);
    //   if (index != swipeUsers.length - 5 || !context.mounted) return;
    //   notifier.reFetch(userData);
    // } catch (_) {}
  }

  bool getIsSwipeWidget(List<SwipeUserType>? swipeUsers) {
    if (swipeUsers == null) return false;
    return swipeUsers.indexWhere((e) => !e.isSwipe) != -1;
  }

  int getInitCurrentIndex(List<SwipeUserType>? swipeUsers) {
    if (swipeUsers == null) return 0;
    final index = swipeUsers.indexWhere((e) => !e.isSwipe);
    return index != -1 ? index : 0;
  }
}

Future<void> swipeActionCallNotifier(
  WidgetRef ref,
  UserPreviewType user,
) async {
  final likedNotifier = ref.read(likedMeUsersNotifierProvider.notifier);
  final swipeUsersNotifier = ref.read(swipeUsersDataNotifierProvider.notifier);
  await swipeUsersNotifier.swipe(user.id);
  await likedNotifier.action(user.id);
}

VoidCallback onIndexUpDate(ValueNotifier<int> currentIndex, int? index) {
  return () => index != null ? currentIndex.value = index : null;
}
