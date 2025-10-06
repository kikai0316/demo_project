import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

DecorationImage assetImg(String file, {BoxFit? fit}) {
  return DecorationImage(
    image: AssetImage("assets/$file"),
    fit: fit ?? BoxFit.cover,
  );
}

DecorationImage? networkImg(String? url, {BoxFit? fit}) {
  if (url == null) return null;
  return DecorationImage(image: NetworkImage(url), fit: BoxFit.cover);
}

DecorationImage memorytImg(Uint8List memory, {BoxFit fit = BoxFit.cover}) {
  return DecorationImage(image: MemoryImage(memory), fit: fit);
}

DecorationImage? fileImg(File? fileData) {
  if (fileData == null) return null;
  return DecorationImage(image: FileImage(fileData), fit: BoxFit.cover);
}

DecorationImage? decorationChangeImage({
  File? file,
  String? network,
  String? asset,
  Uint8List? memory,
}) {
  if (file != null) return fileImg(file);
  if (network != null) return networkImg(network);
  if (memory != null) return memorytImg(memory);
  if (asset != null) return assetImg(asset);
  return null;
}
