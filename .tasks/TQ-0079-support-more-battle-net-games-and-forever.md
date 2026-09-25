---
id: TQ-0079
title: Support more Battle.net games and Forever release
status: done
priority: normal
labels:
  - component/backend
created: 2026-09-25T17:16:13+02:00
updated: 2026-09-25T17:19:46+02:00
---

Add Heroes of the Storm, legacy Overwatch, Warcraft III: Reforged, and World of Warcraft - Forever to Battle.net. Link the Classic Era asset to its game. Check screenshot paths, avoid duplicate Overwatch imports, update tests and user docs.

---

## Notes

- 2026-09-25T17:19:46+02:00 — Added game entries and cover links for Heroes of the Storm, Warcraft III: Reforged, legacy Overwatch, and the _forever_ release folder. Classic Era now uses its named asset. The Lutris installs have game data folders but no screenshot folders yet. Blizzard forum guidance supports the Heroes and Warcraft III paths; the legacy Overwatch GameClientApp path is separate from Overwatch 2. Focused tests, the Settings row test, logo inventory test, and Dart analysis passed.
