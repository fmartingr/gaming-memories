import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_memories/services/battle_net_games.dart';
import 'package:gaming_memories/services/bundled_pc_covers.dart';
import 'package:gaming_memories/sources/guild_wars_2_source.dart';
import 'package:gaming_memories/sources/hytale_source.dart';
import 'package:gaming_memories/sources/minecraft_source.dart';
import 'package:path/path.dart' as p;

class _CoverBundle extends CachingAssetBundle {
  _CoverBundle(this.assets);

  final Map<String, List<int>> assets;
  final loaded = <String>[];

  @override
  Future<ByteData> load(String key) async {
    loaded.add(key);
    final bytes = assets[key];
    if (bytes == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('gaming-memories-covers-');
  });

  tearDown(() => root.delete(recursive: true));

  test('every mapped logo file exists', () {
    for (final assetName in [
      ...battleNetGames.map((game) => game.coverAsset).whereType<String>(),
      MinecraftSource.coverAsset,
      GuildWars2Source.coverAsset,
    ]) {
      expect(
        File(p.join('assets/covers/platforms/pc', assetName)).existsSync(),
        isTrue,
        reason: assetName,
      );
    }
  });

  test('every bundled PC logo belongs to a source game', () {
    final linked = {
      ...battleNetGames.map((game) => game.coverAsset).whereType<String>(),
      MinecraftSource.coverAsset,
      GuildWars2Source.coverAsset,
      p.basename(HytaleSource.coverAsset),
    };
    final assets = Directory('assets/covers/platforms/pc')
        .listSync()
        .whereType<File>()
        .map((file) => p.basename(file.path))
        .toSet();

    expect(linked, assets);
  });

  test('writes the matching logo with its file extension', () async {
    final album = Directory(
      p.join(root.path, 'World of Warcraft - Classic Anniversary'),
    )..createSync();
    final bundle = _CoverBundle({
      'assets/covers/platforms/pc/wow-classic-anniversary.webp': [1, 2, 3],
    });

    await BundledPcCovers(bundle: bundle)
        .writeIfMissing(album, 'wow-classic-anniversary.webp');

    expect(File(p.join(album.path, 'cover.webp')).readAsBytesSync(), [1, 2, 3]);
    expect(bundle.loaded, [
      'assets/covers/platforms/pc/wow-classic-anniversary.webp',
    ]);
  });

  test('keeps a user cover and does not load the bundled logo', () async {
    final album = Directory(p.join(root.path, 'Minecraft'))..createSync();
    final cover = File(p.join(album.path, 'cover.JPG'))
      ..writeAsStringSync('mine');
    final bundle = _CoverBundle(const {});

    await BundledPcCovers(bundle: bundle)
        .writeIfMissing(album, 'minecraft.png');

    expect(cover.readAsStringSync(), 'mine');
    expect(bundle.loaded, isEmpty);
  });

  test('does not create an album without screenshots', () async {
    final album = Directory(p.join(root.path, 'Minecraft'));
    final bundle = _CoverBundle(const {});

    await BundledPcCovers(bundle: bundle)
        .writeIfMissing(album, 'minecraft.png');

    expect(album.existsSync(), isFalse);
    expect(bundle.loaded, isEmpty);
  });

  test('a missing logo does not fail the source', () async {
    final album = Directory(p.join(root.path, 'Minecraft'))..createSync();

    await BundledPcCovers(bundle: _CoverBundle(const {}))
        .writeIfMissing(album, 'minecraft.png');

    expect(album.listSync(), isEmpty);
  });
}
