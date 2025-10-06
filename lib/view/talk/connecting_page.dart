import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_notification_utility.dart';
import 'package:demo_project/utility/firebase/realtime_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/talk/chat_page.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/talk/page/connecting_page_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

StreamSubscription<DatabaseEvent>? roomStateListener;
Timer? timer;

class ConnectingPage extends HookConsumerWidget {
  const ConnectingPage({
    super.key,
    required this.targetUser,
  });

  final UserPreviewType targetUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final user = ref.watch(userDataNotifierProvider).value?.toUserPreviewType();
    final isConnect = useState<bool>(false);

    useEffect(handleEffect(context, ref, user, isConnect), []);
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final safeAreaWidth = constraints.maxWidth;
          final safeAreaHeight = constraints.maxHeight;
          return Stack(
            children: [
              CustomNetworkImageWidegt(
                safeAreaWidth: safeAreaWidth,
                url: targetUser.profileImages.first,
                height: double.infinity,
                errorWidget: nContainer(color: Colors.black),
                placeholder: nSkeletonLoadingWidget(
                    child: nContainer(color: Colors.black)),
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: nContainer(
                            squareSize: double.infinity,
                            gradient: mainGradation(),
                          ),
                        ),
                        bgConnectingAnimation(safeAreaHeight, isConnect),
                        SafeArea(
                          child: Column(
                            children: [
                              SizedBox(height: safeAreaWidth * 0.18),
                              CustomNetworkImageWidegt(
                                safeAreaWidth: safeAreaWidth,
                                url: targetUser.profileImages.first,
                                height: safeAreaWidth * 0.3,
                                width: safeAreaWidth * 0.3,
                                radius: 100,
                              ),
                              nText(
                                targetUser.userName,
                                fontSize: safeAreaWidth / 13,
                                padding: nSpacing(top: safeAreaHeight * 0.02),
                                shadows: nBoxShadow(shadow: 0.1),
                              ),
                              if (!isConnect.value)
                                nText(
                                  ln.callingUser
                                      .replaceFirst("@", targetUser.userName),
                                  padding: nSpacing(top: safeAreaHeight * 0.04),
                                  fontSize: safeAreaWidth / 23,
                                  color: Colors.white.withCustomOpacity(0.8),
                                  height: 1.2,
                                ),
                              if (isConnect.value)
                                nIndicatorWidget(
                                  padding: nSpacing(top: safeAreaHeight * 0.04),
                                  size: safeAreaWidth * 0.04,
                                ),
                              const Spacer(),
                              nContainer(
                                squareSize: safeAreaWidth * 0.25,
                                margin: nSpacing(bottom: safeAreaHeight * 0.05),
                                child: !isConnect.value
                                    ? nIconButton(
                                        onTap: onCancel(context, ref, user?.id),
                                        backGroundColor: Colors.white,
                                        squareSize: safeAreaWidth * 0.25,
                                        iconImage: "black/cancel.png",
                                        iconSize: safeAreaWidth * 0.06,
                                        imageCustomColor: redColor,
                                        boxShadow: nBoxShadow(shadow: 0.1),
                                      )
                                    : checkAnimation(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(
    BuildContext context,
    WidgetRef ref,
    UserPreviewType? user,
    ValueNotifier<bool> isConnect,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        if (user == null) _showDialog(context);
        if (user == null) return;
        final ln = AppLocalizations.of(context)!;
        final subsc = ref.watch(subscriptionNotifierProvider).value;
        final isEndless = subsc?.activeSub != null;
        final create = await dbRTCreateRoom(user, targetUser.id, isEndless);
        if (!context.mounted) return;
        if (create.isSuccess()) {
          _success(context, ref, user.id, user, isConnect);
        }
        if (create.isAlreadyJoined()) {
          nDialog(
            context,
            title: ln.callBusyTitle,
            content: ln.callBusyMessage,
            cancelText: "OK",
            customCancelButon: () => Navigator.pop(context),
          );
        }
        if (create.isError()) _showDialog(context, ln.errorDatabaseConnection);
      });
      return () {
        roomStateListener?.cancel();
        timer?.cancel();
        if (user != null) dbRTUserStateSetRoomId(user.id);
        dbRTDeleteMessageId(targetUser.id);
        dbRTDeleteRoomId(targetUser.id);
      };
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onCancel(BuildContext context, WidgetRef ref, String? userId) {
    return () async {
      if (userId == null) return;
      roomStateListener?.cancel();
      await _deleteRoom(context, ref, userId, 2, true);
      if (context.mounted) Navigator.pop(context);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//ルームが作成に成功した時
  Future<void> _success(
    BuildContext context,
    WidgetRef ref,
    String roomId,
    UserPreviewType user,
    ValueNotifier<bool> isConnect,
  ) async {
    final page = ChatPage(roomId: roomId, myData: user, partner: targetUser);
    VoidCallback onSuccess() {
      return () async {
        if (context.mounted) isConnect.value = true;
        timer?.cancel();
        await Future<void>.delayed(const Duration(milliseconds: 1800));
        if (context.mounted) ScreenTransition(context, page).normal(true);
      };
    }

    VoidCallback onBlake() {
      return () {
        if (context.mounted) noResponseDialog(context, true);
      };
    }

    roomStateListener = dbRTRoomStateListen(roomId, onSuccess(), onBlake());
    timer = createTimer(context, ref);
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Timer createTimer(BuildContext context, WidgetRef ref) {
    final myId = ref.watch(userDataNotifierProvider).value?.id;
    int index = 0;
    return Timer.periodic(const Duration(seconds: 1), (_) async {
      try {
        if (!context.mounted) {
          timer?.cancel();
        } else {
          apiSendNotification(targetUser.id, myId!);
          index = index + 1;
          HapticFeedback.mediumImpact();
          await Future<void>.delayed(const Duration(milliseconds: 100));
          HapticFeedback.mediumImpact();
          if (index >= 30 && context.mounted) {
            await _deleteRoom(context, ref, myId, 1, true);
            if (!context.mounted) return;
            Navigator.pop(context);
          }
        }
      } catch (_) {
        return;
      }
    });
  }

  //ユーザーのデータががいない時HandleEffect
  void _showDialog(BuildContext context, [String? error]) {
    nErrorDialog(context, error, () => Navigator.pop(context));
  }

  void noResponseDialog(BuildContext context, bool isMyCancel) {
    final ln = AppLocalizations.of(context)!;
    final title = isMyCancel ? ln.noResponseTitle : ln.cancelledTitle;
    final content = isMyCancel ? ln.noResponseMessage : ln.cancelledMessage;
    void onPop() => Navigator.pop(context);
    final item = MenuItemType(itemName: "OK", onTap: onPop);
    nDialog(context, title: title, content: content, customCansellItem: item);
  }

  Future<void> _deleteRoom(
    BuildContext context,
    WidgetRef ref,
    String userId,
    int status,
    bool isMyCancel,
  ) async {
    await dbRTDeleteRoom(userId);
    if (!context.mounted) return;
    final notifier = ref.read(chatLogsNotifierProvider.notifier);
    final cancelUserId = isMyCancel ? userId : targetUser.id;
    notifier.cancelCall(userId, targetUser.id, status, null, cancelUserId);
  }
}
