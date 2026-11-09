# [change] factory: content delivery, daily release, Full Unlock and extra packs (issue 1 of 3: 1B)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 1A.

## Goal
Get content into the app, decide what a child can open, and let parents buy more.

## Scope
- **`ContentSource` interface** (`listPacks`, `loadPack`, `checkForUpdates`) in `lib/engine/content/`, with two implementations: built-in (`assets/content/`, always available, listed in `assets/LICENSES.md`) and static server.
- **Static server source:** HTTPS only, one fixed host from `app.config.yaml` (`content.base_url: https://content.activemindcraft.com/v1/`). Layout: `<app_id>/index.json` and `index.sig`, and `packs/<pack_id>/<version>/preview.json` and `full.json` plus assets. Static files only, no backend.
- **Verification:** every pack file's sha256 is checked against the index. **Signing is optional until the owner adds a key:** `content.signing_public_key` and `content.signing_key_id` hold `PLACEHOLDER_*` values until then and an unsigned index is accepted. Once a real key is set, a valid Ed25519 signature is required on every index and the app never falls back to unsigned. After an app has seen a signed index it never accepts an unsigned one (no downgrade), and ignores an index with an older version than the cached one (no rollback). The build prints a warning while signing is off.
- **Cache:** app documents directory, written only when a file is complete; the newest verified version wins over the built-in one; offline always works. Update check on launch and at most once a day, silent, failures ignored.
- **Selector:** `select(subject, year, topic, type, difficulty, count, random)`, deterministic with an injected `Random`, avoids recently seen items, only draws from items that are open to the player.
- **Daily release of built-in content** (config `content.daily_release`, defaults `initial_per_subject: 10`, `per_day_per_subject: 2`, `require_passed: true`):
  - The child's year level is chosen at first launch by a parent, and the release follows it. Changing the year starts a new release; items already open stay open.
  - Items open in `seq` order, per subject and year. The next 2 open each day only when every open item has been passed (answered correctly at least once). No catching up on missed days. The day is the device's local date. Known limit: a changed device date opens items sooner; accepted.
  - A "minimum playable pool" is checked before a minigame appears (issue 1C declares each game's need).
- **Full Unlock:** one non-consumable per app, `unlock_full` in `products.yaml`, behind the parent gate. It opens all built-in content, including updates to it. Extra packs stay separate.
- **Extra packs:** one non-consumable `pack_<id>` per pack. The preview is free to download without a purchase and is playable in both modes. The full part downloads only after Play Billing confirms the purchase and keeps the preview items. A parent area behind the "Ask a grown-up" gate lists packs (description, outline, download size), downloads previews and buys full packs. No pressure wording, no timers, no nagging. The unlock is decided on the device.
- **Progress:** per-item and per-topic results (attempted, passed) in `SaveService` with a save-version migration, feeding the "revise mistakes" list used by Study mode (issue 2).
- **Child-app network rules:** no personal data and no analytics, one fixed host, Android cleartext traffic disabled, `INTERNET` permission checked, noted for the privacy policy.
- New dependencies (hashing and Ed25519) pinned exactly and imported only in the implementation files.

## Acceptance
All template checks pass. Tests: hash mismatch rejected; partial download leaves no cache; offline fallback; unsigned accepted while no key is set; with a test key set, unsigned and wrongly signed rejected, no downgrade, no rollback; daily release (initial, passed rule, a missed day, a date change, a year change); Full Unlock opens everything; extra pack preview download, purchase gating and full download; save migration; selector determinism.

## Out of scope
Minigames and the framework (1C), the design system and modes (issue 2), real signing keys, the platform-subscription source.
