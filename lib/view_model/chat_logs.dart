import 'dart:async';

import 'package:demo_project/model/chat_log_model.dart';
import 'package:demo_project/utility/api_functions/api_chat_logs_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_logs.g.dart';

@Riverpod(keepAlive: true)
class ChatLogsNotifier extends _$ChatLogsNotifier {
  @override
  Future<List<ChatLogType>?> build() async {
    return null;
  }

  // // //初期値はユーザーデータから
  Future<void> init(List<ChatLogType> chatLogs) async {
    try {
      state = AsyncValue.data(sort(chatLogs));
      // mediaInitialize(sortData.friendPosts);
    } catch (_) {
      return;
    }
  }

  Future<void> cancelCall(
    String iId,
    String tId, [
    int status = 2,
    double? chatDuratiom,
    String? cancelledUserId,
  ]) async {
    try {
      final body = ApiChatLogBodyType(
        initiatorId: iId,
        targetId: tId,
        status: status,
        cancelledUserId: cancelledUserId,
        chatDuration: chatDuratiom,
      );
      final newLog = await apiUpDateChatLogs(iId, body);
      if (newLog == null) return;
      final index = state.value?.indexWhere((e) => e.id == newLog.id) ?? -1;
      final newList = [...state.value ?? <ChatLogType>[]];
      if (index == -1) newList.add(newLog);
      if (index != -1) newList[index] = newLog;
      state = AsyncValue.data(sort(newList));
    } catch (_) {
      return;
    }
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
List<ChatLogType> sort(List<ChatLogType> chatLogs) {
  final list = [...chatLogs];
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
}
