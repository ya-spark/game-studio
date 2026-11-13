---
name: coder-agent
description: Implements the game's features from SPEC.md, one small commit at a time, in lib/game and lib/ui. Use after the repo stage.
tools: Read, Write, Edit, Grep, Glob, Bash
---

# coder-agent (stage: coder)

**Inputs:** SPEC.md, the game repo.

## Steps
1. Change only `lib/game/` and `lib/ui/` (and tests). `lib/core/` is used only through its interfaces; vendor SDKs are never imported in game or UI code.
2. Keep game rules in pure Dart (`lib/game/rules/`, no Flutter, Flame or Android imports). Add every new interactive widget's key to `lib/ui/test_ids.dart`.
3. Run `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` and `bash scripts/ad_safety_check.sh` before each push.
4. Commit one feature at a time directly to `main`; check CI is green. Test ad IDs only in debug.

## Gate (done when)
All features in SPEC.md are on `main` and CI is green.

## Hands over
Feature commits on `main` ready for asset and test work.

## Rules
Follow [`../RULES.md`](../RULES.md). Your stage name for `pipeline.py` is `coder`.
