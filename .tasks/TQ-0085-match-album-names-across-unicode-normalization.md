---
id: TQ-0085
title: Match album names across Unicode normalization forms
status: rejected
priority: normal
labels:
  - bug
  - component/backend
created: 2026-10-11T14:18:39+02:00
updated: 2026-10-11T14:36:22+02:00
---

Found in the TQ-0084 code review.

## Finding

The controller finds a folder again after a live insert with exact name
equality: `folder.name == parts[0]` in `lib/controllers/library_controller.dart`
(the platform, game and sub-album lookups in `_upsert…`).

A name can arrive in two Unicode forms. A scan of an HFS+ volume, or of files
synced from one, gives `Röki` decomposed (NFD). A watcher event can give the
same name precomposed (NFC). The `indexWhere` misses, the controller adds a
second `Röki`, and `compareNames` puts the two side by side. The sidebar shows
the game twice until a full rescan.

This lookup is older than TQ-0084. The new sort only makes the two copies sit
next to each other.

## Fix direction

Compare names in one normalization form at these lookups. The Dart SDK has no
Unicode normalization, so this needs a package or a decision on scope.

---

## Notes

- 2026-10-11T14:29:34+02:00 — Probe on macOS 27, Dart Directory.watch(recursive: true) plus Directory.list, one folder created NFC and one NFD:
  - APFS: the event and the listing both give each name in the form it was created in.
  - HFS+ (disk image): the event and the listing both give NFD for both folders.
  The watcher path and the scanned name come from the same volume, so they agree. The duplicate album in the finding does not reproduce. Linux and Windows return names as stored, so they agree too.
- 2026-10-11T14:33:05+02:00 — Linux probe in Docker (dart:3.8, linux_arm64), Directory.watch plus Directory.list, one NFC and one NFD folder:
  - overlayfs and tmpfs: the event and the listing both give each name in the form it was created in.
  Windows was not run (no VM here). Docs: FILE_NOTIFY_INFORMATION.FileName is the name relative to the watched directory, as UTF-16. No Microsoft source says NTFS normalizes names; community reports say it stores them as given.
  Separate Windows risk from the same doc, not tested: when a file has a short (8.3) and a long name, ReadDirectoryChangesW returns one of them, and which one is unspecified.
- 2026-10-11T14:36:22+02:00 — Rejected: the watcher and the folder listing give the same name form on macOS APFS, macOS HFS+, Linux overlayfs and Linux tmpfs, so the duplicate album does not occur. Windows is expected to behave the same (NTFS stores names as given), but it was not run.
