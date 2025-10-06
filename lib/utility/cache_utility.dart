// Uint8Listの事前キャッシュ
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Future<void> cacheImages(
  BuildContext context, {
  List<String> netImgs = const <String>[],
  List<Uint8List> memoryImgs = const <Uint8List>[],
  List<String> assetImgs = const <String>[],
  List<File> fileImages = const <File>[],
}) async {
  try {
    AssetImage asset(String asset) => AssetImage("assets/image/$asset");
    final netDatas = netImgs.map((img) => NetworkImage(img)).toList();
    final memoryDatas = memoryImgs.map((img) => MemoryImage(img)).toList();
    final assetDatas = assetImgs.map((img) => asset(img)).toList();
    final fileDatas = fileImages.map((img) => FileImage(img)).toList();
    final cacheDatas = [
      ...netDatas,
      ...memoryDatas,
      ...assetDatas,
      ...fileDatas
    ];
    if (cacheDatas.isEmpty) return;
    final cacheFutures = cacheDatas.map((image) {
      return precacheImage(image as ImageProvider<Object>, context);
    }).toList();
    await Future.wait(cacheFutures);
  } catch (_) {
    return;
  }
}
