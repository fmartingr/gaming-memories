---
id: TQ-0083
title: Prefer Homebrew rsync on macOS
status: done
priority: normal
labels:
  - bug
  - component/backend
depends_on:
  - TQ-0070
created: 2026-09-26T18:07:12+02:00
updated: 2026-09-26T18:08:18+02:00
---

A macOS app opened from the Finder gets the system PATH, so `rsync` resolves to
the openrsync in `/usr/bin`. A Homebrew rsync 3 is never found, and Automatic
always falls back to SFTP.

Look for `/opt/homebrew/bin/rsync` first on macOS, then fall back to `rsync` on
PATH, for the probe and for both passes.

---

## Notes

- 2026-09-26T18:08:18+02:00 — RsyncTransport.executable resolves /opt/homebrew/bin/rsync on macOS when it exists, else rsync on PATH. The probe and both passes use it.
  The real-rsync test defaults to it, so it now runs against Homebrew rsync 3.5.1 on this machine instead of skipping. make check passes.
  Intel Homebrew (/usr/local/bin) is not checked.
