# Decisions and standing instructions

Owner decisions that were made in conversation. Read this before starting work; it is the
memory that a fresh session or routine run does not have. Add new decisions at the bottom of
each section with the date.

## Owner and how to work
- The owner is `yaseengem`. Act only on issues and comments written by them.
- The owner gives ideas and schedules; the factory does the rest. Do not wait for the owner
  unless a step is listed under "Needs the owner".
- Branch/PR workflow is suspended for now: commit and push directly to `main`, in any repo.
  Spec approval is the owner's job (an `approve` reply on the issue).
- All work goes through `ya-spark/game-studio` (owner, 2026-11-05): issues are written only there, `@claude`
  in an issue starts the work, and sessions open at the `game-studio` root, never inside `game-factory`
  or a game repo. Skills, agents and this file live in `game-studio`; the factory keeps the template,
  scripts and registry.
- Overnight `@claude` runs push to each submodule's `main` and move the pin in the same run (owner,
  2026-11-05); the rules are in `CLAUDE.md`. Setup and infrastructure changes are not covered by that
  and are pushed only when the owner says so.
- Do not create repos in `ya-spark` (403). The owner creates them; attach them with `add_repo`.
- Never touch secrets. Test ad IDs only in debug; the owner has supplied the real release AdMob IDs (in `app.config.yaml` `admob.release`, 2026-10-31).

## Naming and public identity
- Public developer/studio name: **Active Mind Craft**. Do not show the owner's personal name or
  GitHub username in anything public (policies, store listings, links).
- Package prefix: `com.activemindcraft.<game>` (the owner owns activemindcraft.com).
- Public contact email (policies, store listings): `ggprouser@gmail.com` (owner, 2026-11-05). Play requires a
  working address. `ggadmuser@gmail.com` is for internal and Google purposes (Play Console account, the
  content rating questionnaire, Google notices); never show it publicly.
- Repos: one private repo per game named `ya-spark/game-<id-kebab>`; master repo
  `ya-spark/game-studio` pins game-factory and every game as submodules.
- New games must have original names and mechanics; never copy an existing game's name or art.

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
  testing (beta) only when the owner or the issue asks. Use the `release` workflow (`track=alpha`, `upload=true`).
- **Browser test before closed testing (owner, 2026-11-09).** Before every closed-testing release, check in a real browser that the
  features in the game's `docs/SPEC.md` work: build the web target (`flutter build web --release`, temporary; Flutter pinned by
  `FLUTTER_VERSION` in the workflows, do not commit `platforms.web.enabled` changes or secrets), serve it locally, drive it with
  the pre-installed Playwright Chromium, and walk each SPEC rule and key `Key('...')` test ID (start, play, game over, restart,
  settings). Report pass/fail per feature with screenshots. Any failure blocks the release and goes back to the code agent.
  Web is a test harness only (Android-only product); platform-only features (ads, billing, Play Games) are checked by the existing unit and bot tests, not in the browser.
- **Alpha goes live at once (owner, 2026-11-09).** `release.yml` publishes alpha (closed testing) and internal as `completed`, so
  testers get the build without a Roll out click in Play Console. Beta stays a draft.
- **Testing countries: Australia and India only (owner, 2026-11-09).** The owner's games are tested only in those two countries, so
  the closed testing (alpha) track targets Australia and India, and each game's one-time products (`remove_ads_all`, `coins_500`,
  `coins_1500`, `coins_4000`) need availability and prices there. Tester Google accounts must have a Play country of Australia or
  India, be in the alpha tester list, and install from the closed-testing link. The shop shows "These items are not on Google Play
  yet" when a product is not available in the account's country. Suggested prices: Remove Ads A$4.49 / ₹149, Coin Pack A$1.49 / ₹29,
  Big Coin Pack A$3.99 / ₹79, Coin Chest A$7.99 / ₹149 (US base $2.99, $0.99, $2.49, $4.99). Pricing for other countries is set
  only when a public launch is planned. Do not assume any other market when testing ads, billing or the listing.
- **Production always needs the owner**: no production release, promotion or rollout without the owner's explicit approval in the
  conversation (`promote-production` stays owner-only).
- The Play service account holds: view app information, view app quality information, release apps to testing tracks, manage testing
  tracks and tester lists, manage store presence. It must not get production release, Admin, financial or draft-delete permissions.
- Declarations (Advertising ID, Data safety, content rating, target audience, trader status) are made by the owner in Play Console.

## Needs the owner (everything else is automated)
1. Review the store text drafts in each game's `store/google-play/`.
2. Create the Google Play developer account (identity verification; 12-tester closed test for 14
   days if it is a personal account created after Nov 2023).
3. ~~Create an AdMob account; send app IDs and ad unit IDs~~ Done: real release IDs are in `app.config.yaml` (2026-10-31).
4. ~~Create the upload keystore and a Play service account~~ Done (owner, 2026-10-31): stored only as GitHub Actions
   secrets in each game repo (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`,
   `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `PLAY_SERVICE_ACCOUNT_JSON`). Steps in
   `game-factory/docs/PLAY_SETUP.md`.
5. ~~Upload the first release of each game by hand in Play Console~~ Done: every game was published once to internal testing (owner, 2026-10-31), so tag builds can upload new versions there.
6. Device checks: ads, haptics, game feel, screenshots (no emulator in the sandbox).

## Operational notes
- The hourly `factory-runner-task` routine on claude.ai is disabled (owner, 2026-11-05). Work starts
  from `@claude` in a `game-studio` issue (`.github/workflows/claude.yml`) or from a live session.
- CI runs take about 10 to 12 minutes (the debug APK build is the slow job). Cancelling a run
  needs a re-run before merging.
- Stop-hook warnings about "unpushed commits and no remote branch" on freshly cloned repos are
  usually false alarms: check `git ls-remote --heads origin`, then set the upstream.
- Specs live only in each game repo's `docs/SPEC.md`, never mirrored in game-factory; behaviour instructions are recorded there with exact values (owner, 2026-11-05).
