import 'dart:io';

import 'package:path/path.dart' as p;

import 'library_scanner.dart';

/// Where a game's capture time comes from.
enum BattleNetCaptureDate {
  /// Parsed from a World of Warcraft screenshot file name.
  fileName,

  /// Parsed from a Warcraft III screenshot file name.
  warcraftIIIFileName,

  /// The file's modification time.
  modified,
}

/// A screenshot folder a game writes to by default.
class BattleNetScreenshotPath {
  /// A fixed location, such as a game's installation folder.
  const BattleNetScreenshotPath.absolute(String root, this.segments)
    : absoluteRoot = root;

  /// A location under the user's home directory.
  const BattleNetScreenshotPath.underHome(this.segments) : absoluteRoot = null;

  final String? absoluteRoot;
  final List<String> segments;

  /// The full path, or null when it sits under a home directory we do not
  /// have. Inside the macOS sandbox `$HOME` is the app container, so [home]
  /// has to be the real one.
  String? resolve(String? home) {
    final root = absoluteRoot ?? home;
    return root == null ? null : p.joinAll([root, ...segments]);
  }
}

/// A game this source imports.
///
/// Games are found by looking for their screenshot folder, not by asking
/// Battle.net what is installed. Reading Battle.net's `product.db` needs a
/// grant for `/Users/Shared` that the app has no business asking for, while
/// checking whether a folder exists needs no grant at all: the macOS sandbox
/// denies reading a file's contents but allows reading its metadata.
class BattleNetGame {
  const BattleNetGame({
    required this.id,
    required this.name,
    required this.albumName,
    required this.defaultPaths,
    this.coverAsset,
    this.extensions = defaultExtensions,
    this.captureDate = BattleNetCaptureDate.modified,
  });

  static const defaultExtensions = {'.jpg', '.jpeg', '.png'};

  /// Stable key for settings and folder grants. Never change one: it would
  /// orphan the setting and the grant that go with it.
  final String id;

  /// What the Settings row is called.
  final String name;

  /// The album it imports into, under the `PC` platform folder.
  final String albumName;

  /// Bundled logo filename for this game's album, when one is available.
  final String? coverAsset;

  /// Candidate folders per operating system. A game absent from this map has
  /// no client on that platform and can still be pointed at a custom folder.
  final Map<String, List<BattleNetScreenshotPath>> defaultPaths;

  final Set<String> extensions;
  final BattleNetCaptureDate captureDate;

  bool supports(String path) =>
      !p.basename(path).startsWith('.') &&
      extensions.contains(p.extension(path).toLowerCase());
}

const _wowMacOSInstall = '/Applications/World of Warcraft';
const _wowWindowsInstall = r'C:\Program Files (x86)\World of Warcraft';

/// One entry per World of Warcraft flavour, because each keeps its own
/// screenshots and they are worth keeping apart in the library.
BattleNetGame _worldOfWarcraft({
  required String id,
  required String name,
  required String albumName,
  required String flavor,
  required String coverAsset,
}) {
  return BattleNetGame(
    id: id,
    name: name,
    albumName: albumName,
    coverAsset: coverAsset,
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.absolute(_wowMacOSInstall, [
          flavor,
          'Screenshots',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.absolute(_wowWindowsInstall, [
          flavor,
          'Screenshots',
        ]),
      ],
    },
    extensions: const {'.jpg', '.jpeg', '.png', '.tga'},
    captureDate: BattleNetCaptureDate.fileName,
  );
}

final battleNetGames = <BattleNetGame>[
  _worldOfWarcraft(
    id: 'wow_retail',
    name: 'World of Warcraft',
    albumName: 'World of Warcraft',
    flavor: '_retail_',
    coverAsset: 'world-of-warcraft.png',
  ),
  _worldOfWarcraft(
    id: 'wow_classic',
    name: 'World of Warcraft - Classic',
    albumName: 'World of Warcraft - Classic',
    flavor: '_classic_',
    coverAsset: 'wow-classic.jpg',
  ),
  _worldOfWarcraft(
    id: 'wow_classic_era',
    name: 'World of Warcraft - Classic Era',
    albumName: 'World of Warcraft - Classic Era',
    flavor: '_classic_era_',
    coverAsset: 'wow-classic.jpg',
  ),
  _worldOfWarcraft(
    id: 'wow_anniversary',
    name: 'World of Warcraft - Classic Anniversary',
    albumName: 'World of Warcraft - Classic Anniversary',
    flavor: '_anniversary_',
    coverAsset: 'wow-classic-anniversary.webp',
  ),
  _worldOfWarcraft(
    id: 'wow_forever_beta',
    name: 'World of Warcraft - Forever (Beta)',
    albumName: 'World of Warcraft - Forever (Beta)',
    flavor: '_classic_beta_',
    coverAsset: 'wow-forever-beta.png',
  ),
  _worldOfWarcraft(
    id: 'wow_forever',
    name: 'World of Warcraft - Forever',
    albumName: 'World of Warcraft - Forever',
    flavor: '_forever_',
    coverAsset: 'wow-forever.png',
  ),
  const BattleNetGame(
    id: 'diablo_iv',
    name: 'Diablo IV',
    albumName: 'Diablo IV',
    coverAsset: 'diablo-iv.png',
    defaultPaths: {
      'windows': [
        BattleNetScreenshotPath.underHome(['Pictures', 'Diablo IV']),
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Diablo IV',
          'Screenshots',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'diablo_iii',
    name: 'Diablo III',
    albumName: 'Diablo III',
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Diablo III',
          'Screenshots',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Diablo III',
          'Screenshots',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'starcraft_ii',
    name: 'StarCraft II',
    albumName: 'StarCraft II',
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'StarCraft II',
          'Screenshots',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'StarCraft II',
          'Screenshots',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'heroes_of_the_storm',
    name: 'Heroes of the Storm',
    albumName: 'Heroes of the Storm',
    coverAsset: 'heroes-of-the-storm.png',
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.underHome([
          'Library',
          'Application Support',
          'Blizzard',
          'Heroes of the Storm',
          'Screenshots',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Heroes of the Storm',
          'Screenshots',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'warcraft_iii_reforged',
    name: 'Warcraft III: Reforged',
    albumName: 'Warcraft III - Reforged',
    coverAsset: 'warcraft-iii-reforged.png',
    captureDate: BattleNetCaptureDate.warcraftIIIFileName,
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Warcraft III',
          'ScreenShots',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Warcraft III',
          'ScreenShots',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'overwatch',
    name: 'Overwatch',
    albumName: 'Overwatch',
    coverAsset: 'overwatch.png',
    defaultPaths: {
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Overwatch',
          'ScreenShots',
          'GameClientApp',
        ]),
      ],
    },
  ),
  const BattleNetGame(
    id: 'overwatch_2',
    name: 'Overwatch 2',
    albumName: 'Overwatch 2',
    coverAsset: 'overwatch-2.png',
    defaultPaths: {
      'macos': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Overwatch',
          'ScreenShots',
          'Overwatch',
        ]),
      ],
      'windows': [
        BattleNetScreenshotPath.underHome([
          'Documents',
          'Overwatch',
          'ScreenShots',
          'Overwatch',
        ]),
      ],
    },
  ),
];

BattleNetGame? battleNetGameById(String id) {
  for (final game in battleNetGames) {
    if (game.id == id) {
      return game;
    }
  }
  return null;
}

/// A game's folder, and whether it is there.
class BattleNetGameFolder {
  const BattleNetGameFolder({
    required this.game,
    required this.path,
    required this.exists,
    required this.isCustom,
  });

  final BattleNetGame game;

  /// Null when the platform has no default location and no custom folder is
  /// set — the row still appears, so a custom folder can be chosen.
  final String? path;

  /// Whether the folder is on disk. Checking this needs no folder grant.
  final bool exists;

  final bool isCustom;

  /// Whether the source should ask for access to it. A game nobody has
  /// installed never asks.
  bool get isUsable => path != null && (exists || isCustom);
}

/// Resolves each game's screenshot folder for this machine.
class BattleNetLocator {
  const BattleNetLocator({
    this.operatingSystem,
    this.userHomeDirectory,
    this.allowEnvironmentHome = true,
  });

  final String? operatingSystem;
  final String? userHomeDirectory;
  final bool allowEnvironmentHome;

  String get _platform => operatingSystem ?? Platform.operatingSystem;

  String? get _home =>
      userHomeDirectory ?? (allowEnvironmentHome ? homeDirectory() : null);

  /// The folders this game writes to by default on this platform.
  List<String> defaultPathsFor(BattleNetGame game) {
    final home = _home;
    return [
      for (final candidate in game.defaultPaths[_platform] ?? const [])
        ?candidate.resolve(home),
    ];
  }

  /// Resolves one game, preferring a custom folder over the defaults.
  ///
  /// Existence is checked synchronously because it is a `stat`, which the
  /// sandbox allows without a grant, and because the settings rows and the
  /// folder requirements both need the answer while building.
  BattleNetGameFolder resolve(BattleNetGame game, {String? customPath}) {
    final custom = customPath?.trim() ?? '';
    if (custom.isNotEmpty) {
      final path = expandUserPath(custom);
      return BattleNetGameFolder(
        game: game,
        path: path,
        exists: _exists(path),
        isCustom: true,
      );
    }

    final candidates = defaultPathsFor(game);
    for (final candidate in candidates) {
      if (_exists(candidate)) {
        return BattleNetGameFolder(
          game: game,
          path: candidate,
          exists: true,
          isCustom: false,
        );
      }
    }
    return BattleNetGameFolder(
      game: game,
      path: candidates.firstOrNull,
      exists: false,
      isCustom: false,
    );
  }

  bool _exists(String path) {
    try {
      return Directory(path).existsSync();
    } on FileSystemException {
      // Metadata can be denied outright, in which case the folder is simply
      // not something this app can see.
      return false;
    }
  }
}
