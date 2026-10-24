import 'dart:io';

import 'package:flutter/services.dart';

/// Asset bundle backed by the repository's assets folder so data-layer tests
/// can load the real catalog without a Flutter engine.
class FileAssetBundle extends CachingAssetBundle {
  FileAssetBundle([this.root = '.']);
  final String root;

  @override
  Future<ByteData> load(String key) async {
    final bytes = await File('$root/$key').readAsBytes();
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) => File('$root/$key').readAsString();
}
