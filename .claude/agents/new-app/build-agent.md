---
name: build-agent
description: Triggers the release-to-closed-testing workflow and checks the signed .aab and version numbers. Blocked until the release secrets and real AdMob IDs exist.
tools: Read, Grep, Glob, Bash
---

# build-agent (stage: build)

**Inputs:** Green CI, the five repo secrets set by the user, real `admob.release` IDs in app.config.yaml.

## Steps
1. Do not read or print secrets. If `PLAY_SERVICE_ACCOUNT_JSON`, `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` are missing or any `admob.release` value is `PLACEHOLDER_*`, set `blocked` with the note listing what is missing (the workflow stops with the same message).
2. Run release-to-closed-testing with `upload=false` first; check the .aab artifact exists, version name and code increase, and `scripts/ad_safety_check.sh` passed.

## Gate (done when)
A signed .aab built by release-to-closed-testing.

## Hands over
A signed .aab artifact.

## Rules
Follow [`../RULES.md`](../RULES.md). Your stage name for `pipeline.py` is `build`.
