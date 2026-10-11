---
id: TQ-0084
title: Sort album names without regard to case, accents, or digit width
status: done
priority: normal
labels:
  - bug
  - component/backend
  - component/frontend
created: 2026-10-11T14:03:21+02:00
updated: 2026-10-11T14:21:27+02:00
---

Source: [issue #7](https://github.com/fmartingr/gaming-memories/issues/7).

## Why

Album names sort by UTF-16 code unit (`String.compareTo`). The result does not
match what a person expects:

- `CONTROL` and `DELTARUNE` go to the top of their letter, before `Celeste`.
- `WHAT THE GOLF` goes before `Warcraft`.
- `Röki` and `Bō: Path of the Teal Lotus` go after every unaccented name.
- `tERRORbane` and `shapez` go to the bottom of the list.
- `Game 10` goes before `Game 2`.

The order is the same on every OS, because `compareTo` does not use the locale.

## What

One shared comparator, `compareNames(String a, String b)`. It orders platform,
game, and sub-album names in the app and in the published gallery.

The comparator does these steps:

1. It removes diacritics with the `diacritic` package (`Röki` → `Roki`).
2. It lowercases the result.
3. It compares runs of digits by numeric value (`2` < `10`).
4. It compares all other runs as text.
5. It breaks a tie with `a.compareTo(b)`, so the order is total and stable.

### Acceptance criteria

- `['tERRORbane', 'Röki', 'CONTROL', 'Celeste', 'Roki', 'Game 10', 'Game 2', 'WHAT THE GOLF', 'Warcraft', 'shapez', 'Bō: Path of the Teal Lotus']`
  sorts to
  `['Bō: Path of the Teal Lotus', 'Celeste', 'CONTROL', 'Game 2', 'Game 10', 'Roki', 'Röki', 'shapez', 'tERRORbane', 'Warcraft', 'WHAT THE GOLF']`.
- Digit runs with leading zeros compare by value. `Game 02` and `Game 2` both
  sort before `Game 10`.
- The sidebar, the album tiles, and a full scan show the same order.
- A folder that the library watcher adds goes into the same position that a
  full rescan gives it.
- The published gallery shows folder tiles in the same order as the app.

## Constraints

### Must

- Use one comparator for every album-name sort. Different call sites must not
  give different orders.
- Keep the order deterministic. Two different names never compare as equal.
- Add `diacritic` to `pubspec.yaml` and commit the `pubspec.lock` change.

### Must Not

- Must not change the order of media items. Media items sort by
  `capturedAt`.
- Must not change the published gallery's client-side file sort
  (`gallery_template.dart`, `sortItems`).
- Must not rename folders on disk.

### Out of Scope

- Roman numerals (`Final Fantasy X` vs `Final Fantasy IX`).
- Articles (`The Witcher` under T, not W).
- Separate sort names or sort-name overrides.
- Names that start with punctuation or symbols.
- The settings source list (`settings_page.dart:3764`). It holds fixed English
  names and already sorts without case.
- Path sorts used only for import order (`lib/sources/*`, `publish_plan.dart`,
  `gallery_builder.dart:155`).

## Current State

Verified sort sites for album names. All use `compareTo` on the name or the
path:

| File | Line | What it sorts |
| --- | --- | --- |
| `lib/services/library_scanner.dart` | 70–75 | `scan()` albums, by platform then game |
| `lib/services/library_scanner.dart` | 374 | `_folderListing` folder tiles |
| `lib/services/library_scanner.dart` | 420 | `_directories`, by full path. `scan()`, `folderTree()`, `subAlbumTree()`, and line 388 use it. |
| `lib/controllers/library_controller.dart` | 2413 | Live insert of a platform into `folderTree` |
| `lib/controllers/library_controller.dart` | 2434 | Live insert of a game into `folderTree` |
| `lib/controllers/library_controller.dart` | 2469 | Live insert of a sub-album |
| `lib/controllers/library_controller.dart` | 2653 | Merge of live folders into the visible listing |
| `lib/controllers/library_controller.dart` | 2713 | Live insert of a visible folder tile |
| `lib/services/publish/gallery_builder.dart` | 135 | Published gallery folder tiles |

Other facts:

- `pubspec.yaml` has no collation or diacritic package. The Dart SDK has no
  locale collation.
- There is no `lib/utils/` directory. Shared helpers live in `lib/services/`.
- Tests live in `test/services/`, `test/controllers/`, and
  `test/services/publish/`. `make test ARGS=<path>` runs one file.
- `test/services/library_scanner_test.dart` and
  `test/controllers/library_controller_test.dart` call `folderTree`. No test
  checks name order.
- `site/docs.html` section 03 ("Collect and browse captures") has a bullet list
  of album behaviour. `README.md` "Structured albums" is the matching
  highlight.

## Tasks

### 1. Add the comparator

- **What:** Add the `diacritic` dependency. Add `compareNames` in a new file.
  Add a unit test with the acceptance list, leading zeros, an empty string,
  and a name that is all digits.
- **Files:** `pubspec.yaml`, `pubspec.lock`, `lib/services/name_order.dart`,
  `test/services/name_order_test.dart`.
- **Verify:** `make test ARGS=test/services/name_order_test.dart` passes.
  `make analyze` is clean.

### 2. Use it in the app

- **What:** Replace the name and path compares at every
  `library_scanner.dart` and `library_controller.dart` site in the table.
  `_directories` compares `p.basename` of each path, because all entries
  share one parent. Add one scanner test: create game folders with mixed case,
  accents, and numbers, then check the `folderTree()` order. Add one
  controller test: a watched folder insert lands in the `compareNames`
  position.
- **Files:** `lib/services/library_scanner.dart`,
  `lib/controllers/library_controller.dart`,
  `test/services/library_scanner_test.dart`,
  `test/controllers/library_controller_test.dart`.
- **Verify:** `make test` passes.
- **Note:** macOS and Windows file systems are case-insensitive by default.
  Test folder names must not differ only by case.

### 3. Use it in the published gallery

- **What:** Sort `folders` in `gallery_builder.dart:135` with `compareNames`.
  Leave the `files` sort and `_entries` as they are. Add one builder test for
  folder order.
- **Files:** `lib/services/publish/gallery_builder.dart`,
  `test/services/publish/gallery_builder_test.dart`.
- **Verify:** `make test ARGS=test/services/publish/gallery_builder_test.dart`
  passes.

### 4. Document the order

- **What:** Add one bullet to `site/docs.html` section 03: album lists sort
  names without regard to case or accents, and sort numbers by value. Add the
  same fact to the README "Structured albums" highlight. The section count
  does not change, so the nav and the "On this page" list need no edit.
- **Files:** `site/docs.html`, `README.md`.
- **Verify:** Open `site/docs.html` in a browser. The new bullet shows in
  section 03.

## Validation

- `make check` passes (format, analyze, test).
- Manual check (not run): run `make run`. Make a library with `CONTROL`,
  `Celeste`, `Röki`, `tERRORbane`, `Game 2`, and `Game 10`. The sidebar and
  album tiles show the acceptance order.
- Manual check (not run): with the app open, add a folder `Bō` under a
  platform. It appears in the same position after a full rescan.
- Manual check (not run): run `make gallery-preview LIBRARY=<that library>`.
  The folder tiles show the same order as the app.

## Open Decisions

- **`diacritic` version.** The spec does not pin a version. Task 1 takes the
  latest stable release on pub.dev. Impact: none on behaviour. The package
  covers Latin scripts only. Other scripts keep code-point order after the
  lowercase step.

---

## Notes

- 2026-10-11T14:07:25+02:00 — compareNames in lib/services/name_order.dart: removeDiacritics, then strips U+0300–U+036F combining marks (HFS+ names arrive decomposed), lowercases, compares digit runs by value. Tie falls back to String.compareTo.
  diacritic ^0.1.6 added. Applied at the 3 scanner sites, the 5 controller sites and gallery_builder folders; _directories compares basenames.
  Tests: name_order_test, scanner folderTree order, gallery folder order, and a controller test for a watched insert. The controller test fails with the old compareTo (Röki lands after Rusty Lake).
  make check passes: 457 tests, 1 skipped (Windows-only, unrelated).
  Manual app, watcher and gallery-preview checks were not run.
- 2026-10-11T14:18:39+02:00 — Review fixes: dropped the combining-mark regex, because diacritic 0.1.6 already skips U+0300–U+036F. The publish exclusion list in settings sorts with compareNames on load and on add.
  Order tests now use the full issue #7 list for scan() albums, folderTree, subAlbumTree, folderContents tiles, the gallery folders and a watched insert. Folder-based tests drop the colon from 'Bō: Path of the Teal Lotus', because Windows forbids it.
  Each order test fails when compareNames falls back to compareTo. make check passes.
  Review finding #7 (NFC/NFD duplicate album) is filed as TQ-0085.
- 2026-10-11T14:21:27+02:00 — Ponytail review cuts: digit runs compare with BigInt.parse (the _compareNumbers helper and the _leadingZeros regex are gone), _directories compares full paths with compareNames, and the scanner and gallery tests feed the expected list in reverse. The order tests still fail when compareNames falls back to compareTo. make check passes.
