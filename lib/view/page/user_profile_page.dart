import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';
import 'package:demo_project/utility/menu_function_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/talk/connecting_page.dart';
import 'package:demo_project/widget/page/user_profile_page_widget.dart';

class UserProfilePage extends HookConsumerWidget {
  const UserProfilePage({
    super.key,
    required this.user,
    this.initImageIndex,
    this.isPreview,
    this.isInitialize,
    this.isChatButton,
  });
  final UserType user;
  final int? initImageIndex;
  final bool? isPreview;
  final bool? isChatButton;
  final bool? isInitialize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final userData = useState<UserType>(user);
    final imageIndex = useState<int>(initImageIndex ?? 0);
    final scrollPosition = useState<double>(0);
    final screenState = useState<ScreenState>(ScreenState.idle);
    final dataState = useState<DataState>(getInitDataState());
    final isPosition = calculateOpacityAsInt(scrollPosition.value) == 1;

    useEffect(handleEffect(context, screenState), []);
    useEffect(handleEffect2(context, userData, dataState), []);

    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;
        return Listener(
          onPointerUp: onPointerUp(context, scrollPosition, imageIndex),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            backgroundColor: isPosition && !screenState.value.isEnd()
                ? mainBackgroundColor
                : Colors.transparent,
            appBar: userProfileAppBar(
              context,
              isShow: isPosition,
              constraints: constraints,
              userData: userData.value,
              onMenu: isPreview != true
                  ? onMenu(context, ref, userData.value.toUserPreviewType())
                  : null,
            ),
            body: Transform.scale(
              alignment: Alignment.bottomCenter,
              scale: calculateOpacityAsInt(scrollPosition.value),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  nCustomScrollView(
                    onScrollUpdate: onScrollUpdate(scrollPosition),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            profileImageItem(
                              constraints,
                              imageIndex,
                              userData.value,
                              isInitialize != true,
                              screenState,
                              onPop: onPop(context, imageIndex, screenState),
                            ),
                            profileContainer(
                              constraints,
                              children: [
                                locationItem(safeAreaWidth, userData.value),
                                nameAgeItem(safeAreaWidth, userData.value),
                                userBioItem(safeAreaWidth, userData.value),
                                snsAccountItem(safeAreaWidth, userData.value),
                                tagWidgetItems(
                                  context,
                                  safeAreaWidth,
                                  userData.value,
                                ),
                                if (dataState.value == DataState.idle)
                                  ...userProfileLoadingItems(safeAreaWidth),
                                if (dataState.value == DataState.error)
                                  errorItem(
                                    context,
                                    safeAreaWidth,
                                    onFetch(context, userData, dataState),
                                  ),
                                if (getIsSNSEmpty(userData, dataState))
                                  userProfileEmptyData(
                                    safeAreaWidth,
                                    ln.noSnsRegistered,
                                  ),
                                if (getIsProfile(userData, dataState))
                                  userProfileEmptyData(
                                    safeAreaWidth,
                                    ln.noProfileSet,
                                  ),
                                SizedBox(height: safeAreaHeight * 0.2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!screenState.value.isEnd())
                    gradationWidget(safeAreaWidth, scrollPosition.value != 0),
                  bottomGradationWidget(safeAreaWidth),
                  if (isPreview != true && isChatButton != true)
                    actionButtonWidgets(
                      safeAreaWidth,
                      onAction(context, imageIndex, screenState),
                    ),
                  if (isPreview != true &&
                      isChatButton == true &&
                      dataState.value == DataState.success)
                    chatButtonWidgets(safeAreaWidth, onChat(context, userData)),
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
////＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Dispose? Function() handleEffect(
    BuildContext context,
    ValueNotifier<ScreenState> screenState,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (context.mounted) screenState.value = ScreenState.active;
      });
      return null;
    };
  }

  Dispose? Function() handleEffect2(
    BuildContext context,
    ValueNotifier<UserType> userData,
    ValueNotifier<DataState> dataState,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isInitialize != true) return;
        onFetch(context, userData, dataState).call();
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onPop(
    BuildContext context,
    ValueNotifier<int> imageIndex,
    ValueNotifier<ScreenState> screenState,
  ) {
    return () {
      screenState.value = ScreenState.end;
      Navigator.pop(context, {"index": imageIndex.value});
    };
  }

  void Function(SwipeActionType) onAction(
    BuildContext context,
    ValueNotifier<int> imageIndex,
    ValueNotifier<ScreenState> screenState,
  ) {
    return (action) {
      screenState.value = ScreenState.end;
      Navigator.pop(context, {"index": imageIndex.value, "action": action});
    };
  }

  VoidCallback onFetch(
    BuildContext context,
    ValueNotifier<UserType> userData,
    ValueNotifier<DataState> dataState,
  ) {
    return () async {
      final newData = await apiFetchUser(user.id);
      if (!context.mounted) return;
      if (newData != null) userData.value = newData;
      if (newData != null) dataState.value = DataState.success;
      if (newData == null) dataState.value = DataState.error;
    };
  }

  VoidCallback onChat(
    BuildContext context,
    ValueNotifier<UserType> userData,
  ) {
    return () {
      final targetUser = userData.value.toUserPreviewType();
      final page = ConnectingPage(targetUser: targetUser);
      ScreenTransition(context, page).normal(true);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//その他
////＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  void Function(ScrollUpdateNotification)? onScrollUpdate(
    ValueNotifier<double> scrollPosition,
  ) {
    return (notification) {
      final position = notification.metrics.pixels;
      scrollPosition.value = position;
    };
  }

  //Listenerでスクロールのポジションの位置で、戻るかどうかの処理
  void Function(PointerUpEvent)? onPointerUp(
    BuildContext context,
    ValueNotifier<double> scrollPosition,
    ValueNotifier<int> imageIndex,
  ) {
    if (!(scrollPosition.value <= -60)) return null;
    return (_) {
      Navigator.pop(context, {"index": imageIndex.value});
    };
  }

  double calculateOpacityAsInt(double scrollPosition, {double size = 0.2}) {
    final double limitedScroll = scrollPosition.clamp(-200.0, 0.0);
    final double normalizedValue = (limitedScroll.abs()) / 200;
    final double opacity = 1.0 - (normalizedValue * size);
    return opacity;
  }

  DataState getInitDataState() {
    return isInitialize == true ? DataState.idle : DataState.success;
  }

  bool getIsSNSEmpty(
    ValueNotifier<UserType> userData,
    ValueNotifier<DataState> dataState,
  ) {
    if (dataState.value != DataState.success) return false;
    final user = userData.value;
    final sns = [user.instagramId, user.beRealId, user.tiktokId];
    return sns.indexWhere((e) => e.isNotEmpty) == -1;
  }

  bool getIsProfile(
    ValueNotifier<UserType> userData,
    ValueNotifier<DataState> dataState,
  ) {
    if (dataState.value != DataState.success) return false;
    final user = userData.value;
    final profiles = [
      user.height,
      user.mbti,
      user.dayOff,
      user.exercise,
      user.alcohol,
      user.smoking,
    ];
    return profiles.indexWhere((e) => e != 0) == -1;
  }
}
