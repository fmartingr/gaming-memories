---
id: TQ-0079
title: Use bundled PC logos for source albums
status: done
priority: normal
labels:
  - feature
  - component/backend
created: 2026-09-25T16:27:11+02:00
updated: 2026-09-25T16:34:20+02:00
---

Use the PC game logo assets for the matching source albums. Preserve user cover files. Do not create empty albums for missing screenshot folders. Cover Battle.net games with matching assets, Guild Wars 2, and Minecraft. Keep the existing Hytale cover setting. Use full World of Warcraft names for the album folders and source labels. Preserve the existing `World of Warcraft` retail folder name to avoid splitting its library history. Update documentation and focused tests.

---

## Notes

- 2026-09-25T16:28:49+02:00 — The user asked for full World of Warcraft names instead of WoW in folder names. The existing library has a World of Warcraft folder, so retail keeps that full base name. Other flavor albums will use World of Warcraft - <flavor>.
- 2026-09-25T16:34:20+02:00 — Mapped the shipped PC logos to Battle.net game albums, Guild Wars 2, and Minecraft. Existing cover.* files win for these sources, missing screenshot albums are not created, and optional logo failures do not fail a screenshot import. Hytale keeps its existing cover switch. Renamed WoW flavor album folders and settings labels to full World of Warcraft names; kept the existing retail World of Warcraft folder. The 44 focused source tests, one settings widget test, and Dart analysis passed. git diff --check passed.
