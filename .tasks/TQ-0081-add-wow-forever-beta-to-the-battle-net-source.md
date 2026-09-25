---
id: TQ-0081
title: Add WoW Forever Beta to the Battle.net source
status: done
priority: normal
labels:
  - feature
  - component/backend
created: 2026-09-25T14:25:53+02:00
updated: 2026-09-25T14:33:54+02:00
---

Add the WoW Forever Beta flavor (`wow_classic_beta`, `_classic_beta_`) to the Battle.net source. The local Lutris install has no Screenshots directory yet. Verify the expected path in tests, update the README and site documentation, and state the local folder result.

---

## Notes

- 2026-09-25T14:27:44+02:00 — Lutris lists Battle.net at /home/fmartingr/Games/battlenet, which has no WoW install. Battle.net (W3) uses /home/fmartingr/Games/battlenet-w3 and has World of Warcraft/_classic_beta_ with product wow_classic_beta. No Screenshots directory or WoWScrnShot file exists under that install. Added the flavor with the standard WoW screenshot path. The two Battle.net test files passed (27 tests), and the Battle.net settings widget test passed. Dart format and git diff --check passed.
- 2026-09-25T14:32:15+02:00 — Removed the redundant including WoW Forever Beta phrase from the general Battle.net descriptions in README.md and site/docs.html. Kept the specific screenshot folder note in the docs. git diff --check passed.
- 2026-09-25T14:33:54+02:00 — Made the Battle.net summary generic in README.md and site/docs.html. Reviewed the other source summaries; their descriptions do not enumerate games. Kept source names and exact folder paths in the detailed instructions. git diff --check passed.
