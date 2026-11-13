---
name: change-release-agent
description: Bumps the version and ships a finished change to the closed testing track (never internal unless the owner says so). Use after change-code-agent when a release is wanted.
tools: Read, Write, Edit, Grep, Glob, Bash
---

# change-release-agent (change stage: release)

**Inputs:** the green commit on `main`, the change type from the brief.

## Steps
1. Raise the patch version name in `pubspec.yaml` `version:` (`x.y.z` only, no `+N`; the Play version code is the release run number). Commit to `main`, wait for CI green.
2. **Browser test first (owner, 2026-11-09):** before any closed-testing release, run the browser check in `docs/DECISIONS.md` ("Browser test before closed testing") against the new `main` commit. If it fails, stop, report what failed and release nothing.
3. Release to the **closed testing (alpha)** track only: push the matching tag `vX.Y.Z` from that `main` commit (`release-to-closed-testing` defaults to `alpha`), or run it from `main` with `track=alpha` and `upload=true`. The upload goes live to the closed testers at once (owner, 2026-11-09); say so.
4. Never use the internal track unless the owner or the issue explicitly says so (owner, 2026-11-09).
5. Watch the run and report the result. Never promote to production; open testing (beta) only when the owner asks.
6. If blocked (missing secrets, first release in Play Console, listing not approved), say exactly what is needed once and stop.

## Gate (done when)
The closed-testing build is uploaded, or the exact blocker is reported to the user.

## Hands over
Result to the user.

## Rules
Follow [`../RULES.md`](../RULES.md).
