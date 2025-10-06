import 'package:http/http.dart' as http;
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';

//ブロックの追加/削除
Future<List<BlockUserType>?> apiBlockUpdate(
  String id, {
  required String targetId,
  required ToggleType toggle,
}) async {
  try {
    final path = "target_id=$targetId&toggle=${toggle.name}";
    final url = Uri.parse("$hostName/block/$id?$path");
    final response = await http.post(url, headers: defHeaders);

    if (response.statusCode != 201) return null;
    return BlockUserType.fromResponse(response);
  } catch (e) {
    return null;
  }
}

//ブロックユーザーの一覧覧取得
Future<List<BlockUserType>?> apiGetBlockUsers(String id) async {
  try {
    final url = Uri.parse("$hostName/block/$id");
    final response = await http.get(url, headers: defHeaders);
    if (response.statusCode == 200) {
      return BlockUserType.fromResponse(response);
    }
    return null;
  } catch (e) {
    return null;
  }
}
