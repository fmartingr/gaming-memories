---
id: TQ-0079
title: Support more Battle.net games and Forever release
status: done
priority: normal
labels:
  - component/backend
created: 2026-09-25T17:16:13+02:00
updated: 2026-09-25T17:38:48+02:00
---

Add Heroes of the Storm, legacy Overwatch, Warcraft III: Reforged, and World of Warcraft - Forever to Battle.net. Link the Classic Era asset to its game. Check screenshot paths, avoid duplicate Overwatch imports, update tests and user docs.

Verify the live Heroes of the Storm and Warcraft III: Reforged screenshots in the Lutris profiles. The Warcraft III screenshot uses `WC3ScrnShot_092526_173407_000.png` in `Documents/Warcraft III/ScreenShots`. Its file modification time is one second later than the time in its name. Use the filename date for Warcraft III imports. Keep the date behavior for other games. Verify valid and invalid filenames with focused tests.

---

## Notes

- 2026-09-25T17:19:46+02:00 — Added game entries and cover links for Heroes of the Storm, Warcraft III: Reforged, legacy Overwatch, and the _forever_ release folder. Classic Era now uses its named asset. The Lutris installs have game data folders but no screenshot folders yet. Blizzard forum guidance supports the Heroes and Warcraft III paths; the legacy Overwatch GameClientApp path is separate from Overwatch 2. Focused tests, the Settings row test, logo inventory test, and Dart analysis passed.
- 2026-09-25T17:38:48+02:00 — The live Warcraft III screenshot confirmed the ScreenShots folder and the WC3ScrnShot date pattern. Filename time 17:34:07 differs from file modification time 17:34:08. The source now uses the filename time. Focused source tests and Dart analysis passed. TQ-0080 merged into this task.
