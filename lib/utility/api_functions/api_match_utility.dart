import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';

Future<bool?> apiCreateMatch(
  String myId,
  String targetUserId,
  int actionIndex,
) async {
  try {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    final url = Uri.parse("$hostName/match/create");
    final body = jsonEncode(creatMatchBody(myId, targetUserId, actionIndex));
    final response = await http.post(url, body: body, headers: defHeaders);
    if (response.statusCode != 201) return null;
    return json.decode(response.body) as bool?;
  } catch (_) {
    return null;
  }
}

Future<LikedMeUsersType?> apiGetLikedMeUsers(String myId) async {
  try {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    final url = Uri.parse("$hostName/match/fetch/likedmeusers");
    final body = jsonEncode({"id": myId});
    final response = await http.post(url, body: body, headers: defHeaders);

    if (response.statusCode != 201) return null;
    final data = json.decode(response.body) as List;
    return LikedMeUsersType(
      isFetch: true,
      count: data.length,
      users: UserPreviewType.fromList(data),
    );
  } catch (_) {
    return null;
  }
}

Future<Map<String, dynamic>?> apiRefetchOnNotification(String myId) async {
  try {
    final url = Uri.parse("$hostName/match/fetch/notification");
    final body = jsonEncode({"id": myId});
    final response = await http.post(url, body: body, headers: defHeaders);
    if (response.statusCode != 201) return null;
    return json.decode(response.body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// 上記に付随する関数
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
Map<String, dynamic> creatMatchBody(
  String myId,
  String targetUserId,
  int actionIndex,
) {
  return {
    "initiator_user": myId,
    "target_user": targetUserId,
    "action": actionIndex,
  };
}
