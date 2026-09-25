import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'app_log.dart';

/// Adds a logo to an existing album, unless that album has a cover already.
Future<void> writeBundledCoverIfMissing(
  Directory album,
  String? assetName, {
  AssetBundle? bundle,
}) async {
  if (assetName == null) {
    return;
  }

  final asset = 'assets/covers/platforms/pc/$assetName';
  try {
    if (!await album.exists()) {
      return;
    }
    final hasCover = await album
        .list(followLinks: false)
        .any(
          (entry) =>
              entry is File &&
              p.basenameWithoutExtension(entry.path).toLowerCase() == 'cover',
        );
    if (hasCover) {
      return;
    }
    final data = await (bundle ?? rootBundle).load(asset);
    final extension = p.extension(assetName);
    await File(p.join(album.path, 'cover$extension'))
        .writeAsBytes(Uint8List.sublistView(data), flush: true);
  } catch (error) {
    diagnosticLog.warning(
      'The bundled cover for ${p.basename(album.path)} could not be written.',
      category: 'source',
      error: error,
    );
  }
}
