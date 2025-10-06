import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo_project/utility/api_functions/api_user_utility.dart';

Future<void> apiSendNotification(String targetUserId, String sendUserId) async {
  try {
    final url = Uri.parse("$hostName/user/notify/call");
    final body = {"target_user": targetUserId, "send_user": sendUserId};
    await http.post(url, body: jsonEncode(body), headers: defHeaders);
  } catch (_) {}
}
