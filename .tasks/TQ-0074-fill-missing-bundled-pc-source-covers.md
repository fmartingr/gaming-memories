---
id: TQ-0074
title: Fill missing bundled PC source covers
status: done
priority: normal
labels:
  - component/backend
created: 2026-09-25T14:42:54+02:00
updated: 2026-09-25T15:47:14+02:00
---

Audit PC screenshot sources against bundled game covers. Add cover assets for the WoW flavors and align the Overwatch asset with its source album name.

---

## Notes

- 2026-09-25T14:43:13+02:00 — Audited Hytale, Minecraft, Guild Wars 2, and all Battle.net album names. Added copies of the existing WoW cover for Classic, Classic Era, and Forever Beta. Added an Overwatch 2 asset from the existing Overwatch cover. Diablo III and StarCraft II have no cover in the checked library copies. Verified new images and matching hashes.
- 2026-09-25T14:49:58+02:00 — User rejected copied covers. Replace copied WoW flavor images with distinct artwork at the established 920:430 ratio. Replace copied Overwatch 2 asset as well.
- 2026-09-25T14:50:45+02:00 — Replaced duplicate files with distinct artwork. Classic uses SteamGridDB grid 1c870d788b938c7e073516c62a7859e9.png. Classic Era uses the Blizzard Characters and Realms article header V8YJZJCV4ZD61613778090304.jpg. Forever Beta uses the Blizzard Forever Beta article header US61G7YWRORS1789667898380.png. Overwatch 2 uses the branded ntower image 16335-1000-500-a49cfe1f224102b12abd55ccf6f129034b98462e.jpg. All four outputs are 920x430, visually checked, and have distinct hashes.
- 2026-09-25T15:45:30+02:00 — User requested logo-only covers. Replace the artwork behind the WoW flavor logos with a plain background. Keep the existing Overwatch 2 asset because it already shows only its logo.
- 2026-09-25T15:47:14+02:00 — Replaced the three WoW artwork covers with logo-only covers on a plain dark background. Used transparent Classic and Forever logos. Added ERA and BETA labels to identify the source albums. Overwatch 2 already had only its logo on a dark background. Verified all four files as 920x430 PNGs and checked them visually.
