import 'dart:async';

import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_block_utility.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'block_users.g.dart';

@Riverpod(keepAlive: true)
class BlockUsersNotifier extends _$BlockUsersNotifier {
  @override
  Future<List<BlockUserType>?> build() async {
    return null;
  }

  // 初期値はユーザーデータから
  Future<void> init(List<BlockUserType> blockUsers) async {
    try {
      state = AsyncValue.data(blockUsers);
      // mediaInitialize(sortData.friendPosts);
    } catch (_) {
      return;
    }
  }

  Future<bool> upDate(String targetId, ToggleType toggle) async {
    try {
      final myId = ref.watch(userDataNotifierProvider).value?.id;
      if (myId == null) return false;
      final data =
          await apiBlockUpdate(myId, targetId: targetId, toggle: toggle);
      if (data == null) return false;
      state = AsyncValue.data(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetch() async {
    final myId = ref.watch(userDataNotifierProvider).value?.id;
    if (myId != null) {
      final data = await apiGetBlockUsers(myId);
      if (data != null) state = AsyncValue.data(data);
      if (data != null) return;
    }
    state = AsyncValue.error("error", StackTrace.current);
  }
}
