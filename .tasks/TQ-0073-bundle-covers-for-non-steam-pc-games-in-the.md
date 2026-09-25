---
id: TQ-0073
title: Bundle covers for non-Steam PC games in the library
status: done
priority: normal
labels:
  - component/backend
created: 2026-09-25T14:40:57+02:00
updated: 2026-09-25T14:41:38+02:00
---

Copy existing game covers from the user library into bundled PC game assets. Update source cover paths and asset registration as needed.

---

## Notes

- 2026-09-25T14:41:23+02:00 — Copied existing PC game covers from the user library. Found additional Battle.net game albums and Guild Wars 2. Updated Hytale asset path and registered the PC asset directory.
- 2026-09-25T14:41:38+02:00 — Verified all eight bundled PC cover images with Pillow. Flutter tests could not start because fvm tried to write engine cache files outside the writable workspace.
