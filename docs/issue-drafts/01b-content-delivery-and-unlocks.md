# [change] factory: profiles, content delivery, daily release, Full Unlock and extra packs (issue 1 of 3: 1B)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 1A (content model and tools) being finished and passing. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
Get content into the app, decide what each child can open, and let parents buy more. Several children can share one device.

## Decisions already made (owner, 2026-11-09)
- Release pace: 10 items open at the start, then 2 a day, per subject for the child's year level; the next 2 open only when every open item has been passed.
- The child picks the year level at first launch; a parent can change it later.
- Several child profiles per device with a profile picker on every launch (limit 4). A profile is a made-up nickname plus a built-in avatar; no photos, nothing leaves the device.
- One shared coin balance for the device. Remove Ads, Full Unlock and extra packs are bought once and shared by the whole device.
- Parent area: year level and mode lock per child; progress report per child; extra packs, purchases and download settings; delete a profile and its progress. Packs are listed for the child's year level with a switch to see all years. No daily play-time limit in this release.
- Downloads: previews on any connection; full packs on Wi-Fi, and above about 20 MB on mobile data the parent is asked first. Update checks are small and silent.
- Signing is optional until the owner adds a key.

## Scope
- **`ContentSource` interface** (`listPacks`, `loadPack`, `checkForUpdates`) in `lib/engine/content/`, with two implementations: built-in (`assets/content/`, always available, listed in `assets/LICENSES.md`) and static server.
- **Static server source:** HTTPS only, one fixed host from `app.config.yaml` (`content.base_url: https://content.activemindcraft.com/v1/`). Layout: `<app_id>/index.json` and `index.sig`, and `packs/<pack_id>/<version>/preview.json` and `full.json` plus assets. Static files only, no backend.
- **Verification:** every pack file's sha256 is checked against the index. **Signing is optional until the owner adds a key:** `content.signing_public_key` and `content.signing_key_id` hold `PLACEHOLDER_*` values until then and an unsigned index is accepted. Once a real key is set, a valid Ed25519 signature is required on every index and the app never falls back to unsigned. After an app has seen a signed index it never accepts an unsigned one (no downgrade), and ignores an index older than the cached one (no rollback). The build prints a warning while signing is off.
- **Cache:** app documents directory, written only when a file is complete; the newest verified version wins over the built-in one; offline always works. Update check on launch and at most once a day, silent, failures ignored.
- **Selector:** `select(subject, year, topic, type, difficulty, count, random)`, deterministic with an injected `Random`, avoids recently seen items, draws only from items open to that child.
- **Child profiles** (up to 4 per device): a profile picker on every launch; a profile is a nickname (the screen warns against real names) and an avatar from a built-in set. Per child: year level, Game or Study mode and its lock, progress, daily release state. Shared by the device: the coin balance, Remove Ads, Full Unlock and extra packs. Stored in `SaveService` with a save-version migration; an existing single-player save becomes the first profile. Deleting a profile removes only that child's progress.
- **Daily release of built-in content** (config `content.daily_release`, defaults `initial_per_subject: 10`, `per_day_per_subject: 2`, `require_passed: true`):
  - Items open in `seq` order, per subject and year. The next 2 open each day only when every open item has been passed (answered correctly at least once). No catching up on missed days. The day is the device's local date. Known limit: a changed device date opens items sooner; accepted.
  - Items stay open once opened. Changing a child's year starts a new release for that year; items already open stay open.
  - A minimum playable pool is checked before a minigame appears (issue 1C declares each game's need).
- **Full Unlock:** one non-consumable per app, `unlock_full` in `products.yaml`, behind the parent gate. It opens all built-in content, including updates to it. Extra packs stay separate.
- **Extra packs:** one non-consumable `pack_<id>` per pack. The preview is free to download without a purchase and is playable in both modes. The full part downloads only after Play Billing confirms the purchase and keeps the preview items. No pressure wording, no timers, no nagging. The unlock is decided on the device.
- **Parent area** (behind the "Ask a grown-up" gate, test IDs added): choose a child, then change the year level and lock Game or Study mode; a progress report per child (topics passed, items still to pass, the next release); extra packs and purchases (the list shows the child's year with a switch to see all years; sizes shown; preview download; buy Full Unlock and full packs; restore purchases); download settings (Wi-Fi only, or ask before mobile data); delete a profile and its progress.
- **Downloads:** previews on any connection; a full pack above about 20 MB asks the parent first on mobile data.
- **Progress:** per-item and per-topic results (attempted, passed) per child, feeding the "revise mistakes" list used by Study mode (issue 2).
- **Child-app network rules:** no personal data and no analytics, one fixed host, Android cleartext traffic disabled, `INTERNET` permission checked, noted for the privacy policy.
- New dependencies (hashing and Ed25519) pinned exactly and imported only in the implementation files.

## Acceptance
All template checks pass. Tests: hash mismatch rejected; partial download leaves no cache; offline fallback; unsigned accepted while no key is set; with a test key set, unsigned and wrongly signed rejected, no downgrade, no rollback; daily release (initial, the passed rule, a missed day, a date change, a year change); two profiles keep separate progress and share one coin balance; deleting a profile; migration of an old single-player save; Full Unlock opens everything; extra pack preview download, purchase gating and full download; mobile-data prompt above the size limit; selector determinism; parent area reachable only through the gate.

## Out of scope
Minigames, the framework and text-to-speech playback (1C), the design system and modes (issue 2), the Game or Study mode screens themselves, a daily play-time limit, real signing keys, the platform-subscription source.
