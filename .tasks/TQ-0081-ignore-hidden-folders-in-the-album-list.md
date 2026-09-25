---
id: TQ-0081
title: Ignore hidden folders in the album list
status: done
priority: normal
labels:
  - bug
  - component/backend
created: 2026-09-25T16:39:13+02:00
updated: 2026-09-25T17:12:50+02:00
---

Hide dot-prefixed folders on Linux and macOS and folders with the hidden attribute on Windows. Apply the rule to album discovery, nested folders, and live updates. Add focused tests and document the behavior.

---

## Notes

- 2026-09-25T16:43:13+02:00 — The scanner now skips dot-prefixed directories at each album level. On Windows, it also checks the native hidden file attribute. The live library controller rejects hidden folder additions. Added scanner and watcher tests, plus README and site documentation. Focused scanner and controller tests pass on Linux; the Windows attribute test is skipped on this host. Static analysis and git diff checks pass.
- 2026-09-25T17:03:32+02:00 — Review follow-up: removed duplicate hidden checks from subAlbumTree, mediaTree, and mediaItemAt. The controller gate covers live updates. Made the hidden check synchronous and dropped its isDirectory flag. Corrected the docs: dot-prefixed folders are hidden on every platform. Added a test for a library root inside a hidden folder.
  Known limitation: on Windows, a change to the hidden attribute (attrib +H or -H) sends only a modify event. The open library does not add or remove the folder until the next full scan.
- 2026-09-25T17:12:50+02:00 — Simplification pass: removed the hidden-path check from folderContents. Selection comes only from listed folders, and those listings already skip hidden folders. Folded the folderContents hidden test into its Directory condition and restored the stream chain in _directories.
