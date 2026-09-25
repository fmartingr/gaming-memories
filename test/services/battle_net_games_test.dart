import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_memories/services/battle_net_games.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory home;

  setUp(() async {
    home = await Directory.systemTemp.createTemp('gaming-memories-home-');
  });

  tearDown(() => home.delete(recursive: true));

  BattleNetLocator locator({String os = 'macos', String? homePath}) {
    return BattleNetLocator(
      operatingSystem: os,
      userHomeDirectory: homePath ?? home.path,
      allowEnvironmentHome: false,
    );
  }

  BattleNetGame game(String id) => battleNetGameById(id)!;

  test('game ids are unique and stable', () {
    final ids = battleNetGames.map((game) => game.id).toSet();

    expect(ids, hasLength(battleNetGames.length));
    // These are settings keys and grant ids; renaming one orphans both.
    expect(ids, {
      'wow_retail',
      'wow_classic',
      'wow_classic_era',
      'wow_anniversary',
      'wow_forever_beta',
      'wow_forever',
      'diablo_iv',
      'diablo_iii',
      'starcraft_ii',
      'heroes_of_the_storm',
      'warcraft_iii_reforged',
      'overwatch',
      'overwatch_2',
    });
  });

  test('each World of Warcraft flavour has its own album', () {
    expect(game('wow_retail').albumName, 'World of Warcraft');
    expect(game('wow_classic').albumName, 'World of Warcraft - Classic');
    expect(
      game('wow_classic_era').albumName,
      'World of Warcraft - Classic Era',
    );
    expect(
      game('wow_anniversary').albumName,
      'World of Warcraft - Classic Anniversary',
    );
    expect(
      game('wow_forever_beta').albumName,
      'World of Warcraft - Forever (Beta)',
    );
    expect(game('wow_forever').albumName, 'World of Warcraft - Forever');
  });

  test('World of Warcraft reads TGA and dates from the file name', () {
    for (final id in [
      'wow_retail',
      'wow_classic',
      'wow_classic_era',
      'wow_anniversary',
      'wow_forever_beta',
      'wow_forever',
    ]) {
      expect(game(id).extensions, contains('.tga'));
      expect(game(id).captureDate, BattleNetCaptureDate.fileName);
    }
    expect(game('diablo_iii').captureDate, BattleNetCaptureDate.modified);
    expect(game('diablo_iii').extensions, isNot(contains('.tga')));
    expect(
      game('warcraft_iii_reforged').captureDate,
      BattleNetCaptureDate.warcraftIIIFileName,
    );
  });

  test('resolves the World of Warcraft flavour folders', () {
    const flavors = {
      'wow_retail': '_retail_',
      'wow_classic': '_classic_',
      'wow_classic_era': '_classic_era_',
      'wow_anniversary': '_anniversary_',
      'wow_forever_beta': '_classic_beta_',
      'wow_forever': '_forever_',
    };
    for (final entry in flavors.entries) {
      expect(locator().defaultPathsFor(game(entry.key)), [
        p.join('/Applications/World of Warcraft', entry.value, 'Screenshots'),
      ]);
      expect(locator(os: 'windows').defaultPathsFor(game(entry.key)), [
        p.join(
          r'C:\Program Files (x86)\World of Warcraft',
          entry.value,
          'Screenshots',
        ),
      ]);
      expect(locator(os: 'linux').defaultPathsFor(game(entry.key)), isEmpty);
    }
  });

  test('new game screenshot paths stay separate', () {
    expect(
      locator(os: 'windows').defaultPathsFor(game('heroes_of_the_storm')),
      [p.join(home.path, 'Documents', 'Heroes of the Storm', 'Screenshots')],
    );
    expect(locator().defaultPathsFor(game('heroes_of_the_storm')), [
      p.join(
        home.path,
        'Library',
        'Application Support',
        'Blizzard',
        'Heroes of the Storm',
        'Screenshots',
      ),
    ]);
    for (final os in ['macos', 'windows']) {
      expect(locator(os: os).defaultPathsFor(game('warcraft_iii_reforged')), [
        p.join(home.path, 'Documents', 'Warcraft III', 'ScreenShots'),
      ]);
    }
    expect(locator().defaultPathsFor(game('overwatch')), isEmpty);
    expect(locator(os: 'windows').defaultPathsFor(game('overwatch')), [
      p.join(
        home.path,
        'Documents',
        'Overwatch',
        'ScreenShots',
        'GameClientApp',
      ),
    ]);
    expect(
      locator(os: 'windows').defaultPathsFor(game('overwatch')),
      isNot(locator(os: 'windows').defaultPathsFor(game('overwatch_2'))),
    );
  });

  test(
    'home-based games resolve against the given home, not the environment',
    () {
      expect(locator().defaultPathsFor(game('starcraft_ii')), [
        p.join(home.path, 'Documents', 'StarCraft II', 'Screenshots'),
      ]);
      // Inside the macOS sandbox $HOME is the app container, so a locator with
      // no home must not guess one.
      const sandboxed = BattleNetLocator(
        operatingSystem: 'macos',
        allowEnvironmentHome: false,
      );
      expect(sandboxed.defaultPathsFor(game('starcraft_ii')), isEmpty);
    },
  );

  test('Diablo IV has no macOS client but keeps a Windows path', () {
    expect(locator().defaultPathsFor(game('diablo_iv')), isEmpty);
    expect(
      locator(os: 'windows').defaultPathsFor(game('diablo_iv')),
      hasLength(2),
    );
  });

  test('a platform with no entry resolves to nothing', () {
    expect(locator(os: 'linux').defaultPathsFor(game('wow_retail')), isEmpty);
  });

  group('resolve', () {
    test('reports a default folder that is there', () {
      final screenshots = Directory(
        p.join(home.path, 'Documents', 'Diablo III', 'Screenshots'),
      )..createSync(recursive: true);

      final folder = locator().resolve(game('diablo_iii'));

      expect(folder.path, screenshots.path);
      expect(folder.exists, isTrue);
      expect(folder.isCustom, isFalse);
      expect(folder.isUsable, isTrue);
    });

    test('a missing game keeps its path but is not usable', () {
      final folder = locator().resolve(game('diablo_iii'));

      expect(folder.path, isNotNull);
      expect(folder.exists, isFalse);
      // A game nobody has installed must never ask for a folder grant.
      expect(folder.isUsable, isFalse);
    });

    test('a custom folder wins over the default', () {
      Directory(p.join(home.path, 'Documents', 'Diablo III', 'Screenshots'))
          .createSync(recursive: true);
      final custom = Directory(p.join(home.path, 'elsewhere'))..createSync();

      final folder = locator().resolve(
        game('diablo_iii'),
        customPath: custom.path,
      );

      expect(folder.path, custom.path);
      expect(folder.isCustom, isTrue);
      expect(folder.isUsable, isTrue);
    });

    test('a custom folder is usable even before it exists', () {
      final folder = locator().resolve(
        game('diablo_iii'),
        customPath: p.join(home.path, 'not-yet'),
      );

      expect(folder.exists, isFalse);
      // The user chose it, so the source still asks for access to it and
      // reports the real problem rather than silently skipping the game.
      expect(folder.isUsable, isTrue);
    });

    test('a game with no path on this platform is still listed', () {
      final folder = locator().resolve(game('diablo_iv'));

      expect(folder.path, isNull);
      expect(folder.isUsable, isFalse);
    });

    test('picks the first default folder that exists', () {
      final documents = Directory(
        p.join(home.path, 'Documents', 'Diablo IV', 'Screenshots'),
      )..createSync(recursive: true);

      final folder = locator(os: 'windows').resolve(game('diablo_iv'));

      // Pictures comes first in the table but is not there.
      expect(folder.path, documents.path);
      expect(folder.exists, isTrue);
    });
  });
}
