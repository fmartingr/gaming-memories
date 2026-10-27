---
id: TQ-0086
title: Remove WoW Forever Beta from the Battle.net source
status: done
priority: normal
labels:
  - component/backend
created: 2026-10-27T18:47:53+01:00
updated: 2026-10-27T19:40:26+01:00
---

WoW Forever is released, and its folder is `_forever_`. Remove the Forever Beta flavor (`wow_forever_beta`, `_classic_beta_`) and its cover. Keep the Forever flavor. Update tests and the site documentation.

---

## Notes

- 2026-10-27T18:48:45+01:00 — WoW Forever support with the _forever_ folder was already in the source from TQ-0079. Removed the wow_forever_beta entry, its tests, the wow-forever-beta.png cover, and _classic_beta_ from site/docs.html. Kept assets/covers/badges/beta.png because it is a reusable badge and is not bundled. README has no flavor list. make format-check analyze test passed (454 tests).
- 2026-10-27T19:40:26+01:00 — Code review: the Battle.net source test writes a _classic_beta_ screenshot again and checks that no Forever (Beta) album is made. Old wow_forever_beta settings and folder grants are left in place, so a downgrade keeps them.
