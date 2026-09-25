---
id: TQ-0076
title: Add WoW Anniversary flavor to Battle.net source
status: done
priority: normal
labels:
  - feature
  - component/backend
created: 2026-09-25T15:55:20+02:00
updated: 2026-09-25T15:56:55+02:00
---

The Battle.net Lutris prefix now contains five World of Warcraft flavor folders. The source has four. Add the observed `_anniversary_` (`wow_anniversary`) folder as a separate game. Keep automatic Windows and macOS screenshot paths under the install. Keep Linux folder selection manual. Update focused tests and the README and site documentation. No flavor has a Screenshots folder yet.

---

## Notes

- 2026-09-25T15:56:55+02:00 — Battle.net Lutris prefix /home/fmartingr/Games/battlenet now has five .flavor.info folders: wow, wow_classic, wow_classic_era, wow_anniversary, and wow_classic_beta. Only wow_anniversary was missing from the source. No Screenshots directory or WoWScrnShot file exists in this install. Added a separate Anniversary album, Windows and macOS default paths, manual Linux path coverage, and generic docs. The 27 Battle.net tests and the settings widget test passed. Dart format and git diff --check passed. Unrelated Hytale edits and tasks were left untouched.
