---
id: TQ-0077
title: Create reusable beta ribbon and WoW Forever Beta cover
status: done
priority: normal
labels:
  - component/backend
created: 2026-09-25T15:59:43+02:00
updated: 2026-09-25T16:01:57+02:00
---

Create a transparent reusable beta ribbon asset. Composite it at the top right of the 1536x718 WoW Forever logo without changing the base file.

---

## Notes

- 2026-09-25T16:01:57+02:00 — Created a transparent 360x132 reusable BETA ribbon at assets/covers/badges/beta.png and registered the badge directory in pubspec.yaml. Composited the ribbon at the top right of wow-forever.png to make a separate 1536x718 RGBA wow-forever-beta.png. Verified all pixels outside the ribbon bounds are unchanged and the base file matches its committed hash.
