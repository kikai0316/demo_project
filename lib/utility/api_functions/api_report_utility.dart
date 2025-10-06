import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:demo_project/utility/api_functions/api_user_utility.dart';

//通報の作成API
Future<bool> apiCreateReport(
  String myId,
  Map<String, dynamic> body,
) async {
  try {
    final url = Uri.parse("$hostName/report/create");
    final eBody = jsonEncode(body);
    final response = await http.post(url, body: eBody, headers: defHeaders);
    return response.statusCode == 201;
  } catch (e) {
    return false;
  }
}
