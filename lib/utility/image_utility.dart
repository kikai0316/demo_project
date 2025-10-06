import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/notistack/top_snackbar_utility.dart';
import 'package:demo_project/utility/permission_handler_utility.dart';
import 'package:permission_handler/permission_handler.dart';

void _showErrorSnackBar(
  BuildContext context,
  double safeAreaWidth,
  bool isPermissionError,
) {
  if (!context.mounted) return;
  final ln = AppLocalizations.of(context)!;
  nTopSnackBar(
    context,
    safeAreaWidth,
    message: isPermissionError ? ln.noPermission : ln.someErrorOccurred,
    textColor: mainBackgroundColor,
    addRightWidget: isPermissionError
        ? nTextButton(
            safeAreaWidth,
            onTap: () => openAppSettings(),
            text: ln.openSettings,
            fontSize: safeAreaWidth / 30,
            isUnderline: true,
          )
        : null,
  );
}

Future<List<File>> getMobileImages(
  BuildContext context,
  double safeAreaWidth,
  ValueNotifier<bool> isLoading, [
  int limit = 5,
]) async {
  isLoading.value = true;
  try {
    if (!await checkPhotoPermission()) {
      if (context.mounted) _showErrorSnackBar(context, safeAreaWidth, true);
      return [];
    }
    final ImagePicker picker = ImagePicker();
    if (limit == 1) {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) return [];
      return compressFiles([img]);
    }
    final List<XFile> newImgs = await picker.pickMultiImage(limit: limit);
    if (newImgs.isEmpty) return [];
    if (!context.mounted) return [];
    return compressFiles(newImgs);
  } catch (e) {
    if (context.mounted) _showErrorSnackBar(context, safeAreaWidth, false);
    return [];
  } finally {
    isLoading.value = false;
  }
}

Future<File?> cropProfileImg(BuildContext context, File? img) async {
  if (img == null) return null;
  final ln = AppLocalizations.of(context)!;
  final ImageCropper cropper = ImageCropper();
  final CroppedFile? croppedFile = await cropper.cropImage(
    sourcePath: img.path,
    aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 14.5),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: ln.edit,
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original, // squareから変更
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: ln.edit,
        // rectX: 50,
        // rectY: 50,
        // rectWidth: 5000,
        // rectHeight: 5000,
        aspectRatioLockEnabled: true,
        aspectRatioPickerButtonHidden: true,
        resetAspectRatioEnabled: false,
        resetButtonHidden: true,
        doneButtonTitle: ln.done,
        cancelButtonTitle: ln.cancel,
      ),
    ],
  );

  if (croppedFile != null) return File(croppedFile.path);
  return null;
}

//画像の圧縮
Future<List<File>> compressFiles(List<XFile> newImg) async {
  final compressedFiles = await Future.wait(
    newImg.map((file) async {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.path,
        "${file.path}_ooo.jpg",
        quality: 80,
        minWidth: 670,
      );
      if (compressedFile == null) return null;
      return File(compressedFile.path); // 圧縮に失敗した場合は元ファイルを返す
    }),
  );
  return compressedFiles.whereType<File>().toList();
}
// //widgetを画像にする関数
// Future<List<Uint8List>> getBytesFromWidgets(
//   List<GlobalKey> globalKeys, {
//   double pixelRatio = 5,
// }) async {
//   try {
//     final futures = globalKeys.map((key) async {
//       final boundary =
//           key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
//       if (boundary == null) return null;
//       final uiImage = await boundary.toImage(pixelRatio: pixelRatio);
//       final byteData = await uiImage.toByteData();
//       if (byteData == null) return [];
//       final rgbaBytes = byteData.buffer.asUint8List();
//       final result = await compute(
//         encodeImageToJpg,
//         {
//           'rgbaBytes': rgbaBytes,
//           'width': uiImage.width,
//           'height': uiImage.height,
//         },
//       );
//       return result;
//     }).toList();
//     final results = await Future.wait(futures);
//     return results.whereType<Uint8List>().toList();
//   } catch (e) {
//     return [];
//   }
// }

// Uint8List encodeImageToJpg(Map<String, dynamic> args) {
//   final rgbaBytes = args['rgbaBytes'] as Uint8List;
//   final width = args['width'] as int;
//   final height = args['height'] as int;

//   final image = img.Image.fromBytes(
//     width: width,
//     height: height,
//     bytes: rgbaBytes.buffer,
//     order: img.ChannelOrder.rgba,
//     numChannels: 4,
//   );

//   return Uint8List.fromList(img.encodePng(image));
// }

// //urlの画像をUint8List型にする
// Future<Uint8List?> getBytesFromUrl(String imageUrl) async {
//   try {
//     final response = await http.get(Uri.parse(imageUrl));
//     if (response.statusCode != 200) return null;
//     return response.bodyBytes;
//   } catch (e) {
//     return null;
//   }
// }

// //画像が有効化を検証する
// Future<bool> isValidImageUrlLight(String url) async {
//   try {
//     const timeLimit = Duration(seconds: 5);
//     final response = await http.head(Uri.parse(url)).timeout(timeLimit);
//     if (response.statusCode != 200) return false;
//     final contentType = response.headers['content-type'];
//     return contentType?.startsWith('image/') ?? false;
//   } catch (e) {
//     return false;
//   }
// }
