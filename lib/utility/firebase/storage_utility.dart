import 'package:firebase_storage/firebase_storage.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/app_utlity.dart';

Future<List<String>> dbStorageProfileImageUploads(
  String myId,
  List<EditImageItemType> images,
) async {
  final futures = images.map((e) => _imageUpload(myId, e)).toList();
  final urls = await Future.wait(futures);
  await dbStorageDeleteImages(myId, urls.whereType<String>().toList());
  return urls.whereType<String>().toList();
}

Future<String?> _imageUpload(String id, EditImageItemType data) async {
  final storageRef = FirebaseStorage.instance.ref("user/$id");
  final meta = {'account_id': id, 'uploader': 'authorized_user'};
  try {
    final file = data.file;
    if (file == null) return null;
    final child = generateUniqueId();
    final mountainsRef = storageRef.child(child);
    await mountainsRef.putFile(file, SettableMetadata(customMetadata: meta));
    return mountainsRef.getDownloadURL();
  } catch (_) {
    return null;
  }
}

Future<void> dbStorageDeleteImages(String id, List<String> newUrls) async {
  final storageRef = FirebaseStorage.instance.ref("user/$id");
  try {
    final result = await storageRef.listAll();
    final futures = result.items.map((ref) async {
      final url = await ref.getDownloadURL();
      if (!newUrls.contains(url)) await ref.delete();
    }).toList();
    await Future.wait(futures);
  } catch (_) {
    return;
  }
}
