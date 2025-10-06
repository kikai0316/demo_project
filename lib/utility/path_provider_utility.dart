import 'dart:convert';
import 'dart:io';
import 'package:demo_project/model/first_action_model.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

//アプリ内で最初のアクションまとめを読み
Future<FirstActionsType> localGetFirstActions() async {
  final file = await localFile("fast_action");
  try {
    if (await file.exists()) {
      final String jsonData = await file.readAsString();
      return FirstActionsType.fromJson(jsonData);
    }
    return FirstActionsType();
  } catch (_) {
    return FirstActionsType();
  }
}

//アプリ内で最初のアクションまとめを書き込む
Future<void> localWriteFirstActions({
  bool? startup,
  bool? editStory,
  bool? notification,
  bool? photo,
  bool? location,
}) async {
  final file = await localFile("fast_action");
  try {
    final data = await localGetFirstActions();
    final update =
        data.update(startup, editStory, notification, photo, location);
    await file.writeAsString(jsonEncode(update.toJson()));
  } catch (e) {
    return;
  }
}

Future<void> localWriteSwipeCounts() async {
  try {
    final file = await localFile("swipe_counts");
    final String jsonData = await file.readAsString();
    final decode = jsonDecode(jsonData) as List;
    final datas = decode.map((e) => DateTime.parse(e as String)).toList();
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(hours: 24));
    final onlyLast24Hours =
        datas.where((t) => !t.isBefore(cutoff) && !t.isAfter(now)).toList();
    final body = [...onlyLast24Hours, DateTime.now()].map((e) => e.toString());
    await file.writeAsString(jsonEncode(body));
  } catch (_) {
    return;
  }
}

Future<int> localReadSwipeCounts([
  File? initFile,
]) async {
  try {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(hours: 24));
    final file = initFile ?? await localFile("swipe_counts");
    final String jsonData = await file.readAsString();
    final decode = jsonDecode(jsonData) as List;
    final datas = decode.map((e) => DateTime.parse(e as String)).toList();
    return datas.where((t) => !t.isBefore(cutoff) && !t.isAfter(now)).length;
  } catch (_) {
    return 0;
  }
}
