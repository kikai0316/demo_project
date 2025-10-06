import 'dart:async';

import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_match_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'liked_me_users.g.dart';

@Riverpod(keepAlive: true)
class LikedMeUsersNotifier extends _$LikedMeUsersNotifier {
  @override
  Future<LikedMeUsersType?> build() async {
    return null;
  }

  // //初期値はユーザーデータから
  Future<void> init(LikedMeUsersType data) async =>
      state = AsyncValue.data(data);

  // //初期値はユーザーデータから
  Future<void> fetch(String id) async {
    final data = await apiGetLikedMeUsers(id);
    if (data != null) state = AsyncValue.data(data);
  }

  Future<void> action(String swipedUserId) async {
    final data = state.value;
    if (data == null) return;
    if (!data.isFetch) return;
    final users = state.value!.users;
    final newUsers = users.where((e) => e.id != swipedUserId).toList();
    state = AsyncValue.data(state.value?.upDate(newUsers));
  }
}
