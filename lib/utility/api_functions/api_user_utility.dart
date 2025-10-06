import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:demo_project/main.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/startup_data_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/location_utility.dart';

const hostName = String.fromEnvironment("api");
const apiKey = String.fromEnvironment("apiKey");
final defHeaders = {'Content-Type': 'application/json', "x-api-key": apiKey};

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ユーザーデータ取得関連API
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//最初に取得するAPIすべて取得する
Future<StartupDataType?> apiGetStartupData(String id) async {
  try {
    final url = Uri.parse("$hostName/user/startup/$id");
    final body = jsonEncode(await createStartupBody());
    final response = await http.post(url, body: body, headers: defHeaders);
    if (response.statusCode != 201) return null;
    return StartupDataType.fromJson(response);
  } catch (_) {
    return null;
  }
}

//スワイプユーザーの次を取得する
Future<List<SwipeUserType>?> apiFetchSwipeUsers(UserType data) async {
  try {
    final url = Uri.parse("$hostName/user/fetch/swipe/${data.id}");
    final body = jsonEncode(await createReFetchMatchingUserBody(data.location));
    final response = await http.post(url, body: body, headers: defHeaders);
    if (response.statusCode != 201) return null;
    return SwipeUserType.fromList(json.decode(response.body) as List);
  } catch (_) {
    return null;
  }
}

//特定のユーザーを取得する
Future<UserType?> apiFetchUser(String id) async {
  try {
    final url = Uri.parse("$hostName/user/fetch/$id");
    final response = await http.post(url, headers: defHeaders);
    if (response.statusCode != 201) return null;
    final data = json.decode(response.body) as Map<String, dynamic>;
    return UserType.fromJson(data);
  } catch (_) {
    return null;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ユーザー関連API
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// //ユーザー関連API
Future<UserType?> apiUserUpDate(ApiUserUpdateBodyType body) async {
  try {
    final url = Uri.parse("$hostName/user/update/${body.id}");
    final eBody = jsonEncode(body.toJson());
    final response = await http.put(url, body: eBody, headers: defHeaders);
    if (response.statusCode != 200) return null;
    final data = json.decode(response.body) as Map<String, dynamic>;
    return UserType.fromJson(data);
  } catch (e) {
    return null;
  }
}

//ユーザーサインアップ＆ログイン
Future<UserType?> apiUserSignup(
  String id,
  Map<String, dynamic> phoneData,
) async {
  try {
    final url = Uri.parse("$hostName/user/signup/phone");
    final ebody = jsonEncode(await createSignuprBody(id, phoneData));
    final response = await http.post(url, body: ebody, headers: defHeaders);
    if (response.statusCode != 201) return null;
    final item = json.decode(response.body) as Map<String, dynamic>;
    return UserType.fromJson(item);
  } catch (e) {
    return null;
  }
}

//アカウントログアウトAPI
Future<bool> apiUserLogOut(String userId) async {
  try {
    final url = Uri.parse("$hostName/user/logout/$userId");
    final response = await http.post(url, headers: defHeaders);
    if (response.statusCode == 201) return true;
    return false;
  } catch (e) {
    return false;
  }
}

//アカウント削除API
Future<bool> apiUserDelete(
  String userId,
  Map<String, dynamic> body,
) async {
  try {
    final url = Uri.parse("$hostName/user/delete/$userId");
    final eBody = jsonEncode(body);
    final response = await http.delete(url, body: eBody, headers: defHeaders);
    if (response.statusCode == 200) return true;
    return false;
  } catch (e) {
    return false;
  }
}
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Future<Map<String, dynamic>> createStartupBody() async {
  final location = await getLocation();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return {
    "fcm_token": fcmToken,
    "language": appLocalizations?.lang ?? "en",
    "location": {
      "type": 'Point',
      "coordinates": [location.longitude, location.latitude],
    },
    "max_distance": 100000,
  };
}

Future<Map<String, dynamic>> createReFetchMatchingUserBody(
  List<double> location,
) async {
  final data = await getLocation();
  return {
    "location": {"type": 'Point', "coordinates": data},
    "max_distance": 100000,
  };
}

Future<Map<String, dynamic>> createSignuprBody(
  String id,
  Map<String, dynamic> phoneData,
) async {
  final token = await FirebaseMessaging.instance.getToken();
  return {
    "uid": id,
    "language": appLocalizations?.lang ?? "en",
    "phone_number": {
      "country_code": phoneData["country_code"] as String,
      "number": phoneData["national_number"] as String,
    },
    if ((token ?? "").isNotEmpty) "fcm_token": token,
  };
}
