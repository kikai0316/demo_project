import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demo_project/model/chat_log_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';

Future<ChatLogType?> apiUpDateChatLogs(
  String myId,
  ApiChatLogBodyType body,
) async {
  try {
    final url = Uri.parse("$hostName/chatlog/update/$myId");
    final eBody = jsonEncode(body.toJson());
    final response = await http.post(url, body: eBody, headers: defHeaders);
    if (response.statusCode != 201) return null;
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ChatLogType.fromJson(data);
  } catch (_) {
    return null;
  }
}
