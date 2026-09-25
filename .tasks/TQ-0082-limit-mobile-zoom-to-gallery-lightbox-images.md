---
id: TQ-0082
title: Limit mobile zoom to gallery lightbox images
status: done
priority: normal
labels:
  - component/frontend
  - feature
created: 2026-09-25T18:10:51+02:00
updated: 2026-09-25T18:25:31+02:00
---

Disable page zoom on mobile published gallery pages. Allow pinch zoom and pan inside the image lightbox only. Keep video playback and gallery navigation usable. Update README and site documentation. Verify the rendered template and gesture behavior.

---

## Notes

- 2026-09-25T18:10:55+02:00 — Fetched origin/master and fast-forwarded this branch to 224199e. The published gallery template owns mobile viewport settings and lightbox gestures.
- 2026-09-25T18:17:11+02:00 — Fast-forwarded the branch to origin/master 224199e. Disabled native mobile page zoom on the published gallery and project site. Added image-only pinch zoom and drag to the gallery lightbox; reset zoom on navigation and close. Updated README and site documentation. Focused Flutter tests pass (20), Flutter analyze passes, Node gesture simulation passes, JavaScript syntax passes, and git diff --check passes. No browser was available for a real-device check.
- 2026-09-25T18:25:31+02:00 — Review pass: pinch now zooms about the point between the fingers; a two-finger gesture on a clip no longer navigates; gesture state reset shared in endGesture(); trimmed redundant checks, CSS and test assertions. Flutter tests (20), analyze, git diff --check and a Node gesture simulation pass.
