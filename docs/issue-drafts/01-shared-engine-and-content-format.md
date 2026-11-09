# [change] factory: shared engine and content format for the Craft and Mind apps

**Repo:** game-factory (new shared packages) with the template updated to use them.

## Goal
One shared engine that the five new apps (and later the existing three) reuse.

## Scope
- Content format: pack manifest (id, version, subject, language, school year, topic, difficulty, licence) and typed items (multiple choice including true or false, ordered series,
  pairs, word with hint, category items), plus image and audio references. JSON, validated by a schema and a validator script.
- `ContentSource` interface with two implementations: built-in packs and a static server (signed index, versioned packs, hash and signature checks, offline cache, update check).
  Signing keys are owner secrets and never committed. No backend.
- Paid packs unlock on the device after Play Billing confirms the purchase (client-side entitlement); packs are signed against tampering.
- Minigame framework: a minigame declares the item types it reads and asks a content selector for items by subject, school year, topic and difficulty.
- Per-app compliance profile: child-directed (child-safe ads, no interstitials in Craft apps, parent gate on purchases, no sign-in) versus adult (existing ads pacing, optional Play Games).
- Reuse the existing coins, daily reward, streak, challenge, ads pacing and parent gate code from the template.
- Pure-Dart rules, service interfaces, test IDs, and tests for the loader, selector and validators.

## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` and `bash scripts/ad_safety_check.sh` pass; docs describe the format; a sample pack validates.

## Out of scope
A third content source (other platform with subscription), any backend, real AdMob IDs.
