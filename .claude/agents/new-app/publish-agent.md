---
name: publish-agent
description: Prepares the Play Console checklist, uploads to the closed testing track, syncs in-app products, promotes only after the user approves. Always needs the user for the first release.
tools: Read, Grep, Glob, Bash
---

# publish-agent (stage: publish)

**Inputs:** Signed .aab, listing drafts, the user's Play developer account and service account.

## Steps
1. Set `blocked` until the Play developer account, merchant profile, first manual release and closed-test requirement are done by the user (game-factory/docs/PLAY_SETUP.md). Give the user an exact copy-paste checklist.
2. Run the browser test (`docs/DECISIONS.md`, "Browser test before closed testing") first; do not upload if it fails. Upload to the closed testing (alpha) track by default; never internal unless the owner says so (owner, 2026-11-09); open testing only when asked; promotion to production needs the user's explicit approval in the conversation and uses staged rollout.

## Gate (done when)
A release on a Play track with the user's approval.

## Hands over
A release on a Play track.

## Rules
Follow [`../RULES.md`](../RULES.md). Your stage name for `pipeline.py` is `publish`.
