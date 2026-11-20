# Release tracks, privacy policies, games state

Verbatim archive from `docs/DECISIONS.md` (split 2026-11-21 to save tokens). The index there says when to read this file.

## Privacy policies
- Hosted by GitHub Pages from the public repo `ya-spark/public` (source: `ya-spark/public`,
  branch `main`, root). Keep that repo public.
- `ya-spark/public` is a submodule of `game-studio` at `public/` (owner, 2026-11-05). Policies live at `blockfall/privacy.md`, `blockpuzzle/privacy.md` and `wingy/privacy.md`; the index page lists them. Changing a policy: edit it there and in the game's `store/google-play/privacy_policy.md`, then move the pin.
- URLs: `https://ya-spark.github.io/public/<game>/privacy` (for example `.../wingy/privacy`,
  `.../blockfall/privacy`). The same text lives in each game's `store/google-play/privacy_policy.md`;
  keep them in sync.
- The games show ads (AdMob) and sell in-app products, so a policy URL is required by Play even
  though the apps ask for no personal details.

## Games (state as of 2026-10-29)
- Block Puzzle (`game-block-puzzle`): sample game from the template.
- Blockfall (`game-block-fall`): stages spec through listing done; build and publish unblocked (secrets and AdMob IDs in place, 2026-10-31), first internal build with tag v1.0.1.
- Wingy (`game-wingy`): stages spec through listing done; build and publish unblocked (secrets and AdMob IDs in place, 2026-10-31), first internal build with tag v1.0.1.
- Check `python3 game-factory/scripts/pipeline.py status` for the current truth.

## Release tracks (owner, 2026-11-06; default changed 2026-11-09)
- **Default release track is closed testing (Alpha, `track=alpha`).** Never release to internal testing unless the owner
  or the issue explicitly says so (owner, 2026-11-09). This applies to every release, including auto-releases after a change.
- Claude may send an app to **any Play track except production**: closed testing (Alpha) by default; internal testing and open
  testing (beta) only when the owner or the issue asks. Use the `release-to-closed-testing` workflow (`track=alpha`, `upload=true`).
- **Browser test before closed testing (owner, 2026-11-09).** Before every closed-testing release, check in a real browser that the
  features in the game's `docs/SPEC.md` work: build the web target (`flutter build web --release`, temporary; Flutter pinned by
  `FLUTTER_VERSION` in the workflows, do not commit `platforms.web.enabled` changes or secrets), serve it locally, drive it with
  the pre-installed Playwright Chromium, and walk each SPEC rule and key `Key('...')` test ID (start, play, game over, restart,
  settings). Report pass/fail per feature with screenshots. Any failure blocks the release and goes back to the code agent.
  Web is a test harness only (Android-only product); platform-only features (ads, billing, Play Games) are checked by the existing unit and bot tests, not in the browser.
- **Alpha goes live at once (owner, 2026-11-09).** `release-to-closed-testing` publishes alpha (closed testing) and internal as `completed`, so
  testers get the build without a Roll out click in Play Console. Beta stays a draft.
- **Testing countries: Australia and India only (owner, 2026-11-09).** The owner's games are tested only in those two countries, so
  the closed testing (alpha) track targets Australia and India, and each game's one-time products (`remove_ads_all`, `coins_500`,
  `coins_1500`, `coins_4000`) need availability and prices there. Tester Google accounts must have a Play country of Australia or
  India, be in the alpha tester list, and install from the closed-testing link. The shop shows "These items are not on Google Play
  yet" when a product is not available in the account's country. Suggested prices: Remove Ads A$4.49 / ₹149, Coin Pack A$1.49 / ₹29,
  Big Coin Pack A$3.99 / ₹79, Coin Chest A$7.99 / ₹149 (US base $2.99, $0.99, $2.49, $4.99). Pricing for other countries is set
  only when a public launch is planned. Do not assume any other market when testing ads, billing or the listing.
- **Production always needs the owner**: no production release, promotion or rollout without the owner's explicit approval in the
  conversation (`promote-to-production` stays owner-only).
- The Play service account holds: view app information, view app quality information, release apps to testing tracks, manage testing
  tracks and tester lists, manage store presence. It must not get production release, Admin, financial or draft-delete permissions.
- Declarations (Advertising ID, Data safety, content rating, target audience, trader status) are made by the owner in Play Console.
