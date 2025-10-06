import 'dart:async';

import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'swipe_users.g.dart';

@Riverpod(keepAlive: true)
class SwipeUsersDataNotifier extends _$SwipeUsersDataNotifier {
  @override
  Future<List<SwipeUserType>?> build() async {
    return null;
  }

  // //初期値はユーザーデータから
  Future<void> init(List<SwipeUserType> users) async {
    try {
      upDateState(users);
    } catch (_) {
      return;
    }
  }

  //再取得
  Future<List<SwipeUserType>?> reFetch(UserType user) async {
    try {
      final newData = await apiFetchSwipeUsers(user) ?? [];
      upDateState([...state.value!, ...newData]);
      return state.value;
    } catch (_) {
      return null;
    }
  }

//スワイプが行われた
  Future<void> swipe(String targetUserId) async {
    try {
      final index = state.value?.indexWhere((e) => e.user.id == targetUserId);
      if (index == null || index == -1) return;
      final newList = [...state.value!];
      newList[index] = newList[index].swipe();
      upDateState(newList);
    } catch (_) {
      return;
    }
  }

  //LikedMeUsersでスワイプが行われたとき、削除する
  Future<void> delete(String targetUserId) async {
    try {
      final users = state.value;
      if (users == null) return;
      final newUsers = users.where((e) => e.user.id != targetUserId).toList();
      upDateState(newUsers);
    } catch (_) {
      return;
    }
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  void upDateState(List<SwipeUserType> users) {
    final newUsers =
        users.where((e) => e.user.profileImages.isNotEmpty).toList();
    state = AsyncValue.data(newUsers);
  }
}
