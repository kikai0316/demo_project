import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/message_model.dart';
import 'package:demo_project/utility/firebase/realtime_utility.dart';
import 'package:demo_project/utility/menu_function_utility.dart';
import 'package:demo_project/utility/notistack/center_snackbar_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/notistack/top_snackbar_utility.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/widget/talk/chat_ui_widget.dart';
import 'package:demo_project/widget/talk/page/chat_page_widget.dart';

TextEditingController? chatPageTextController;
CarouselSliderController? carouselController;
StreamSubscription<DatabaseEvent>? typingStateListener;
StreamSubscription<DatabaseEvent>? messagesStateListener;
StreamSubscription<DatabaseEvent>? isEndlessStateListener;
Timer? timer;
Stopwatch? chatStopwatch;

class ChatPage extends HookConsumerWidget {
  const ChatPage({
    super.key,
    required this.roomId,
    required this.partner, //相手のユーザーデータ
    required this.myData, //自分のユーザーデータ
  });
  final String roomId;
  final UserPreviewType partner;
  final UserPreviewType myData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = useState<List<MessageType>>([]);
    final partnerTyping = useState<String>("");
    final timerStr = useState<String>("30:00");
    final focusNode = useFocusNode();

    useEffect(
      handleEffect(context, ref, partnerTyping, messages, timerStr, focusNode),
      [],
    );
    return PopScope(
      canPop: false,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final safeAreaWidth = constraints.maxWidth;
          final safeAreaHeight = constraints.maxHeight;
          return Scaffold(
            backgroundColor: mainBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: chatPageAppBar(
              context,
              safeAreaWidth,
              timerStr,
              onMenu: onMenu(context, ref, partner, messages.value, focusNode),
              onEnd: onEnd(context, ref),
            ),
            body: Stack(
              children: [
                SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      ChatUiWidget(
                        constraints: constraints,
                        partner: partner,
                        myData: myData,
                        messages: [
                          ...messages.value,
                          partnerTypingData(partnerTyping),
                        ],
                      ),
                      messageTextFiled(
                        constraints,
                        myData: myData,
                        focusNode: focusNode,
                        textController: chatPageTextController,
                        onChanged: onMyTextChanged(),
                        onSend: onSend(context),
                      ),
                    ],
                  ),
                ),
                nContainer(
                  height: safeAreaHeight * 0.13,
                  width: safeAreaWidth,
                  gradient: nGradation(
                    begin: Alignment.center,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF94D9FE), const Color(0xFFDFFAF7)],
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(50),
                //   child: BackdropFilter(
                //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                //     child: nContainer(
                //       height: safeAreaHeight * 0.13,
                //       width: safeAreaWidth,
                //     ),
                //   ),
                // ),
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
  Dispose? Function() handleEffect(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String> partnerTyping,
    ValueNotifier<List<MessageType>> messages,
    ValueNotifier<String> timerStr,
    FocusNode focusNode,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
        timer = createTimer(context, ref, timerStr);
        chatPageTextController = TextEditingController();
        carouselController = CarouselSliderController();
        typingStateListener = dbRTTypingStateListen(
          roomId,
          partner.id,
          onPartnerTextChanged(context, ref, partnerTyping),
        );
        messagesStateListener = dbRTMessageStateListen(
          roomId,
          partner.id,
          onMessageDataChanged(messages),
        );
        isEndlessStateListener = dbRTIsEndlesstateListen(
          roomId,
          partner.id,
          onIsEndlessDataChanged(context, timerStr),
        );
        chatStopwatch = Stopwatch()..start();
      });
      return () {
        dbRTUserStateSetRoomId(myData.id);
        typingStateListener?.cancel();
        messagesStateListener?.cancel();
        isEndlessStateListener?.cancel();
        timer?.cancel();
      };
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onEnd(BuildContext context, WidgetRef ref) {
    return () {
      final ln = AppLocalizations.of(context)!;
      nDialog(
        context,
        title: ln.endChatTitle,
        content: ln.endChatDescription,
        mainItem: MenuItemType(
            itemName: ln.actionButtonEndChat,
            color: Colors.red,
            onTap: () {
              _deleteRoom(ref);
              Navigator.pop(context);
            }),
      );
    };
  }

  VoidCallback onSend(BuildContext context) {
    return () async {
      final ln = AppLocalizations.of(context)!;
      final value = chatPageTextController?.text ?? "";
      if (value.isEmpty) return;
      chatPageTextController?.clear();
      await dbRTTypingUpDate(roomId, myData.id, "");
      final isSend = await dbRTAddMessage(roomId, myData.id, value);
      if (isSend || !context.mounted) return;
      nShowCenterSnackBar(context, message: ln.messageSendFailed);
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  dynamic Function(int, CarouselPageChangedReason)? onPageChanged(
    ValueNotifier<int> selectIndex,
  ) {
    return (index, _) {
      selectIndex.value = index;
      HapticFeedback.selectionClick();
    };
  }

  void Function(String)? onMyTextChanged() {
    return (value) => dbRTTypingUpDate(roomId, myData.id, value);
  }

  void Function(String?)? onPartnerTextChanged(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String> partnerTyping,
  ) {
    return (value) {
      if (!context.mounted) return;
      if (value == null) _endSnackBar(context, ref);
      partnerTyping.value = value ?? "";
    };
  }

  void Function(List<MessageType>)? onMessageDataChanged(
    ValueNotifier<List<MessageType>> messages,
  ) {
    return (value) => messages.value = value;
  }

  void Function(bool)? onIsEndlessDataChanged(
    BuildContext context,
    ValueNotifier<String> timerStr,
  ) {
    return (value) {
      final ln = AppLocalizations.of(context)!;
      if (!context.mounted || !value) return;
      timerStr.value = ln.unlimited;
      timer?.cancel();
      chatStopwatch?.reset();
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  MessageType partnerTypingData(ValueNotifier<String> partnerTyping) {
    return MessageType(
      isTyping: true,
      userId: partner.id,
      text: partnerTyping.value,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    );
  }

  Timer createTimer(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<String> timerStr,
  ) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = MediaQuery.of(context).size.width;
    int totalSeconds = 30 * 60;
    return Timer.periodic(const Duration(seconds: 1), (t) {
      totalSeconds--;
      final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
      final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
      if (!context.mounted) return;
      timerStr.value = '$minutes:$seconds';
      if (totalSeconds == 180) {
        final messe = ln.remainingMessage.replaceFirst("@", "3");
        nTopSnackBar(context, safeAreaWidth, message: messe);
      }
      if (totalSeconds == 60) {
        final messe = ln.remainingMessage.replaceFirst("@", "1");
        nTopSnackBar(context, safeAreaWidth, message: messe);
      }
      if (totalSeconds <= 0) {
        t.cancel();
        _endSnackBar(context, ref, ln.timeoutMessage);
      }
    });
  }

  void _endSnackBar(BuildContext context, WidgetRef ref, [String? messe]) {
    final ln = AppLocalizations.of(context)!;
    nDialog(
      context,
      title: ln.timeoutTitle,
      content: messe,
      cancelText: "OK",
      customCancelButon: () => Navigator.pop(context),
      barrierDismissible: false,
    );
  }

  Future<void> _deleteRoom(WidgetRef ref) async {
    final notifier = ref.read(chatLogsNotifierProvider.notifier);
    final iId = roomId == myData.id ? myData.id : partner.id;
    final tId = roomId != myData.id ? myData.id : partner.id;

    typingStateListener?.cancel();
    messagesStateListener?.cancel();
    chatStopwatch?.stop();
    final seconds = (chatStopwatch?.elapsed.inMilliseconds ?? 0) / 1000;

    await dbRTDeleteRoom(roomId);
    notifier.cancelCall(iId, tId, 0, (seconds * 100).roundToDouble() / 100);
  }
}
