import 'dart:convert';

import 'package:http/http.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/chat_log_model.dart';
import 'package:demo_project/model/user_model.dart';

class StartupDataType {
  UserType userData;
  List<SwipeUserType> swipeUsers;
  bool isLogin;
  bool isDelete;
  LikedMeUsersType likedMeUsers;
  List<UserPreviewType> matchingUsers;
  List<ChatLogType> chatLogs;
  List<BlockUserType> blockUsers;

  StartupDataType({
    required this.userData,
    required this.swipeUsers,
    required this.isLogin,
    required this.isDelete,
    required this.likedMeUsers,
    required this.matchingUsers,
    required this.chatLogs,
    required this.blockUsers,
  });
  factory StartupDataType.fromJson(Response response) {
    final data = json.decode(response.body) as Map<String, dynamic>;
    final user = data["user"] as Map<String, dynamic>;

    return StartupDataType(
      userData: UserType.fromJson(user),
      isDelete: user["is_deleted"] as bool,
      isLogin: user["is_login"] as bool,
      swipeUsers: SwipeUserType.fromList(data["swipe_users"] as List? ?? []),
      likedMeUsers: LikedMeUsersType.fromJson(data),
      matchingUsers: UserPreviewType.fromList(data["matching_users"] as List),
      chatLogs: ChatLogType.fromList(data["chat_logs"] as List),
      blockUsers: BlockUserType.fromList(data["block_users"] as List),
    );
  }
}
