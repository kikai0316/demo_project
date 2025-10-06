import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';
import 'package:demo_project/utility/firebase/realtime_utility.dart';
import 'package:demo_project/utility/notistack/top_snackbar_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/user_profile_page.dart';
import 'package:demo_project/view/talk/chat_page.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

StreamSubscription<DatabaseEvent>? roomStateListener;
Timer? timer;

class IncomingDialog extends HookConsumerWidget {
  const IncomingDialog({
    super.key,
    required this.messageId,
  });

  final String messageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    const asset = "assets/animations/loading_effect.json";
    final parts = messageId.split('@');
    final user = useState<UserType?>(null);

    useEffect(handleEffect(context, user), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        // final safeAreaHeight = constraints.maxHeight;
        return Center(
          child: nContainer(
            height: safeAreaWidth * 1.3,
            width: safeAreaWidth * 0.8,
            gradient: mainGradation(),
            radius: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: nSpacing(top: safeAreaWidth * 0.3),
                      child: Opacity(
                        opacity: 0.4,
                        child: Transform.scale(
                          scale: 7,
                          child: Lottie.asset(asset),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: nSpacing(allSize: safeAreaWidth * 0.03),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        nText(
                          ln.invitedToChat,
                          fontSize: safeAreaWidth / 30,
                          padding: nSpacing(top: safeAreaWidth * 0.03),
                          color: blackColor.withCustomOpacity(0.8),
                          isFit: true,
                        ),
                        SizedBox(height: safeAreaWidth * 0.05),
                        CustomNetworkImageWidegt(
                          safeAreaWidth: safeAreaWidth,
                          height: safeAreaWidth * 0.7,
                          width: safeAreaWidth * 0.7,
                          url: parts[3],
                          boxShadow: nBoxShadow(shadow: 0.05),
                          radius: 10,
                        ),
                        nText(
                          parts[2],
                          fontSize: safeAreaWidth / 18,
                          padding: nSpacing(top: safeAreaWidth * 0.05),
                          color: blackColor,
                          shadows: nBoxShadow(shadow: 0.1),
                          isFit: true,
                        ),
                        nTextButton(
                          safeAreaWidth,
                          onTap: onProfile(context, user),
                          text: ln.viewProfile,
                          fontSize: safeAreaWidth / 30,
                          margin: nSpacing(top: safeAreaWidth * 0.02),
                          padding: nSpacing(allSize: safeAreaWidth * 0.02),
                          radius: 5,
                        ),
                        const Spacer(),
                        nContainer(
                          width: safeAreaWidth,
                          margin: nSpacing(top: safeAreaWidth * 0.01),
                          padding: nSpacing(ySize: safeAreaWidth * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0; i < 2; i++)
                                nIconButton(
                                  iconImage:
                                      "black/${["cancel.png", "talk.png"][i]}",
                                  iconSize: safeAreaWidth / 20,
                                  onTap: [
                                    onCancel(context, ref),
                                    onChat(context, ref, user),
                                  ][i],
                                  vibration: () =>
                                      HapticFeedback.selectionClick(),
                                  backGroundColor: [
                                    Colors.red,
                                    Colors.green,
                                  ][i],
                                  width: safeAreaWidth * 0.3,
                                  imageCustomColor:
                                      Colors.white.withCustomOpacity(0.8),
                                  padding:
                                      nSpacing(allSize: safeAreaWidth * 0.035),
                                  margin: nSpacing(xSize: safeAreaWidth * 0.02),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  loadinPage(safeAreaWidth, isLoading: user.value == null),
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
  Dispose? Function() handleEffect(
    BuildContext context,
    ValueNotifier<UserType?> user,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final parts = messageId.split('@');
        timer = createTimer(context);
        roomStateListener =
            dbRTRoomStateListen(parts[1], null, onBlake(context));
        final getUser = await apiFetchUser(parts[1]);
        if (context.mounted) user.value = getUser;
      });
      return () {
        timer?.cancel();
      };
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback? onProfile(
    BuildContext context,
    ValueNotifier<UserType?> user,
  ) {
    if (user.value == null) return null;
    return () {
      timer?.cancel();
      final page = UserProfilePage(user: user.value!, isPreview: true);
      ScreenTransition(context, page).top(
        onPop: (_) {
          timer = createTimer(context);
        },
      );
    };
  }

  VoidCallback onCancel(
    BuildContext context,
    WidgetRef ref,
  ) {
    return () {
      final myId = ref.watch(userDataNotifierProvider).value?.id;
      final parts = messageId.split('@');
      dbRTDeleteRoom(parts[1]);
      if (!context.mounted || myId == null) return;
      final notifier = ref.read(chatLogsNotifierProvider.notifier);
      notifier.cancelCall(parts[1], myId, 3, null, myId);
      dbRTUserStateSetRoomId(myId);
      dbRTDeleteMessageId(myId);
    };
  }

  VoidCallback? onChat(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<UserType?> partner,
  ) {
    if (partner.value == null) return null;
    return () async {
      final ln = AppLocalizations.of(context)!;
      final safeAreaWidth = MediaQuery.of(context).size.width;
      final parts = messageId.split('@');
      final myDataState = ref.watch(userDataNotifierProvider);
      final myData = myDataState.value!.toUserPreviewType();

      dbRTDeleteMessageId(myData.id);
      timer?.cancel();
      final isJoint = await dbRTJoinRoom(parts[1], ref);
      if (!context.mounted) return;
      if (isJoint) {
        final partnerData = partner.value!.toUserPreviewType();
        final page =
            ChatPage(roomId: parts[1], partner: partnerData, myData: myData);
        Navigator.pop(context, page);
      } else {
        nTopSnackBar(context, safeAreaWidth, message: ln.someErrorOccurred);
      }
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onBlake(BuildContext context) {
    return () {
      if (context.mounted) Navigator.pop(context);
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Timer createTimer(BuildContext context) {
    return Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!context.mounted) timer?.cancel();
      HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 400));
      HapticFeedback.mediumImpact();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      HapticFeedback.mediumImpact();
    });
  }
}
