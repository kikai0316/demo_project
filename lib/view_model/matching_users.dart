import 'dart:async';

import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_match_utility.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'matching_users.g.dart';

@Riverpod(keepAlive: true)
class MatchingUsersNotifier extends _$MatchingUsersNotifier {
  @override
  Future<List<UserPreviewType>?> build() async {
    return null;
  }

  // //初期値はユーザーデータから
  Future<void> init(List<UserPreviewType> users) async {
    try {
      state = AsyncValue.data(users);
      // mediaInitialize(sortData.friendPosts);
    } catch (_) {
      return;
    }
  }

  Future<void> newMatching(UserPreviewType user) async {
    final users = state.value;
    if (users == null) return;
    final index = users.indexWhere((e) => e.id == user.id);
    if (index != -1) return;
    state = AsyncValue.data([...users, user]);
  }

  Future<void> refetchOnNotification(String myId) async {
    final json = await apiRefetchOnNotification(myId);
    if (json == null) return;

    final notifier = ref.read(likedMeUsersNotifierProvider.notifier);
    final matchingJson = json["matching_users"] as List;
    final matchingUsers = UserPreviewType.fromList(matchingJson);
    notifier.init(LikedMeUsersType.fromJson(json));
    state = AsyncValue.data(matchingUsers);
  }
}
