import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import 'app_log.dart';

/// The bundled logo for each supported PC source album.
const pcCoverAssets = <String, String>{
  'Diablo IV': 'diablo-iv.png',
  'Guild Wars 2': 'guild-wars-2.jpg',
  'Minecraft': 'minecraft.png',
  'Overwatch 2': 'overwatch-2.png',
  'World of Warcraft': 'world-of-warcraft.png',
  'World of Warcraft - Classic': 'wow-classic.jpg',
  'World of Warcraft - Classic Era': 'wow-classic-era.jpg',
  'World of Warcraft - Classic Anniversary': 'wow-classic-anniversary.webp',
  'World of Warcraft - Forever (Beta)': 'wow-forever-beta.png',
};

class BundledPcCovers {
  const BundledPcCovers({this.bundle});

  final AssetBundle? bundle;

  /// Adds a logo to an existing album, unless that album has a cover already.
  Future<void> writeIfMissing(Directory album, String albumName) async {
    final assetName = pcCoverAssets[albumName];
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
    } on FlutterError catch (error) {
      diagnosticLog.warning(
        'The bundled cover for $albumName could not be read.',
        category: 'source',
        error: error,
      );
    } on FileSystemException catch (error) {
      diagnosticLog.warning(
        'The bundled cover for $albumName could not be saved.',
        category: 'source',
        error: error,
      );
    }
  }
}
