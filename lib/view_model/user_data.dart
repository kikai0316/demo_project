import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/model/startup_data_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';
import 'package:demo_project/utility/firebase/storage_utility.dart';
import 'package:demo_project/view_model/block_users.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:demo_project/view_model/matching_users.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/view_model/swipe_users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_data.g.dart';

// void stopTimer([bool isStop = false]) {
//   if (isStop) appStartStopwatch?.stop();
//   final seconds = (appStartStopwatch?.elapsed.inMilliseconds ?? 0) / 1000;
//   // ignore: avoid_print
//   print('経過時間: ${seconds.toStringAsFixed(3)} 秒');
// }

@Riverpod(keepAlive: true)
class UserDataNotifier extends _$UserDataNotifier {
  @override
  Future<UserType?> build() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      final startupData = await apiGetStartupData(uid);
      if (startupData == null) return null;
      if (startupData.isDelete || !startupData.isLogin) {
        await FirebaseAuth.instance.signOut();
        return null;
      }
      await minimalCache(startupData);
      await callNotifier(startupData);
      return startupData.userData;
    } catch (_) {
      return null;
    }
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// 再取得系
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<void> reFetchStartupData() async {
    try {
      final uid = state.value?.uid ?? "";
      final startupData = await apiGetStartupData(uid);
      if (startupData == null) return;
      await minimalCache(startupData);
      await callNotifier(startupData);
      state = AsyncValue.data(startupData.userData);
    } catch (_) {
      return;
    }
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// アカウント更新
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<bool> upDateUserProfile(
    BuildContext context,
    ApiUserUpdateBodyType updateData,
  ) async {
    try {
      final newData = await apiUserUpDate(updateData);
      if (newData != null) state = AsyncValue.data(newData);
      return newData != null;
    } catch (_) {
      return false;
    }
  }

  //サインアップ/ログイン関数
  Future<UserType?> signAccount(
      String id, Map<String, dynamic> phoneData) async {
    try {
      final newUserData = await apiUserSignup(id, phoneData);
      if (newUserData != null) state = AsyncValue.data(newUserData);
      return newUserData;
    } catch (_) {
      return null;
    }
  }

  //アカウントのログアウト関数
  Future<bool> logOut() async {
    try {
      //mongDBにあるデータのログアウト
      if (!await apiUserLogOut(state.value?.id ?? "")) return false;
      //ファイヤーベース認証のログアウト
      await FirebaseAuth.instance.signOut();
      state = const AsyncValue.data(null);
      return true;
    } catch (_) {
      return false;
    }
  }

  //アカウント削除関数
  Future<bool> deleteAccount(
    UserType user,
    String? reason,
    int? reasonCode,
  ) async {
    final Map<String, dynamic> body = {
      "reason_code": reasonCode?.toString(),
      "reason": reason,
      "language": user.language,
      "birthday": user.birthday,
      "name": user.userName,
    }..removeWhere((key, value) => value == null);

    try {
      //mongDBにあるデータを削除処理をする
      if (!await apiUserDelete(user.id, body)) return false;
      //ファイヤーベース認証の削除
      await dbStorageDeleteImages(user.id, []);
      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      return false;
    }
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他上記に付随する処理
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<void> callNotifier(StartupDataType data) async {
    final swipeUsers = ref.read(swipeUsersDataNotifierProvider.notifier);
    final matchingUsers = ref.read(matchingUsersNotifierProvider.notifier);
    final likedMeUsers = ref.read(likedMeUsersNotifierProvider.notifier);
    final chatLogs = ref.read(chatLogsNotifierProvider.notifier);
    final subscription = ref.read(subscriptionNotifierProvider.notifier);
    final blockUser = ref.read(blockUsersNotifierProvider.notifier);
    await swipeUsers.init(data.swipeUsers);
    matchingUsers.init(data.matchingUsers);
    likedMeUsers.init(data.likedMeUsers);
    chatLogs.init(data.chatLogs);
    subscription.init(data.userData.id);
    blockUser.init(data.blockUsers);
  }

  Future<void> minimalCache(StartupDataType startupData) async {
    final context = navigatorKey.currentContext;
    final swipeUsers = startupData.swipeUsers;
    final fastSwipeUser = swipeUsers.where((e) => !e.isSwipe).toList();
    final url = fastSwipeUser.firstOrNull?.user.profileImages.firstOrNull;
    if (url == null || context == null) return;
    final img = CachedNetworkImageProvider(url, cacheKey: url);
    final provider = ResizeImage(img, width: 400, height: 400);
    await precacheImage(provider, context).timeout(const Duration(seconds: 5));
  }

  // Future<void> fullCache(StartupDataType startupData) async {
  //   final swipeUser = startupData.swipeUsers.where((e) => !e.isSwipe).toList();
  //   final cashImages = [
  //     ...startupData.userData.profileImages,
  //     for (final swipeUser in swipeUser) ...swipeUser.user.profileImages,
  //   ].whereType<String>().toList();

  //   final context = navigatorKey.currentContext;
  //   if (context == null) return;
  //   if (cashImages.isEmpty || !context.mounted) return;
  //   await cacheImages(context, netImgs: cashImages);
  // }
}

// final _assets = <String>[
//   // "logo.png",
//   // "icon/black/home.png",
//   // "icon/black/account.png",
//   // "icon/white/plus.png",
// ];
