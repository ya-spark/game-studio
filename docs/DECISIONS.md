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

## Craft family: education games (owner, 2026-11-06)
- Three apps, shipped together, one per age band, sharing one engine and one content format. The names **Craft Scout Games** (Foundation to Year 6, ages about 5-12),
  **Craft Ranger Games** (Years 7-10, about 12-16) and **Craft Champion Games** (Years 11-12, senior secondary, about 16-18) are used **only on Google Play** (owner, 2026-11-09). In the repos, the
  factory registry and the code, the apps use the age-band names. Repos (created by the owner, kept as named): `ya-spark/game-craft-lowteen`
  (Scout), `ya-spark/game-craft-preteen` (Ranger), `ya-spark/game-craft_highteen` (Champion; the underscore is kept; the generator's `--repo` override is needed because it writes kebab-case repo names).
  Ids (snake_case, as the generator requires): `craft_lowteen`, `craft_preteen`, `craft_highteen`. Packages (owner confirmed 2026-11-09, permanent once uploaded to Play):
  `com.activemindcraft.craftscout`, `.craftranger`, `.craftchampion`; casual hubs `com.activemindcraft.mindember`, `.mindzip`. Play Store and trademark checks for the three store names still pending.
- Each app is a hub of minigames (door runner for multiple choice, series builder, match pairs, true/false, block drop);
  the student content plugs into them. Content packs carry an age-band tag and a content type (MCQ, series, pairs, true/false).
- Content sources, behind a `ContentSource` interface: built-in default packs, and static files (signed JSON and asset
  bundles on a CDN, versioned, cached offline) uploaded by the owner. Static hosting only: no backend, logins or user data.
  A third source (another platform, with subscription) is deferred; it needs a new owner decision on auth and Play Billing.
- Children's apps: family-safe ad networks only; parental gate in front of purchases and any external link; no chat,
  no personal data, no Play Games sign-in (owner, 2026-11-06). "Remove Ads" is a one-time Play Billing purchase (parents). Little band: no timers, picture and voice questions.

- Planning answers (owner, 2026-11-09): the static content host is the owner's Hostinger VPS behind Caddy (static files only); English only at launch with the content format ready
  for more languages; each learning app ships with built-in starter packs that populate its games, plus updates from the server; starter subjects are maths and English, a few hundred
  items per app, topics from each school year, written to be aligned with the Australian curriculum **without mentioning it anywhere in the apps, store listings or policies**
  (original items only, Australian spelling, no copied textbook or test content); all five apps are built together on one shared engine and design system (same UI principles and styling,
  with per-app colours and vibe); Craft apps use child-safe ads only, and Remove Ads sits behind a parental gate.

- Age bands corrected (owner, 2026-11-09): the apps are split by school stage, not the earlier 4-7 / 8-11 / 12-15 split. Scout = Foundation to Year 6, Ranger = Years 7-10, Champion = senior
  secondary (Years 11-12). Starter content (maths and English) is tagged by school year. Open points to settle in the specs: the Play target-audience declarations (Scout is child-directed under
  the Families policy; Ranger straddles the under-13 and 13+ line and Champion is mostly 16+, so ads and policy settings may differ by app), and whether Scout needs two interface levels
  (about 5-8 and 9-12). The earlier rule of no Play Games sign-in in the Craft apps stands.

- Craft apps, more decisions (owner, 2026-11-09): Game mode is the default on first launch and the app remembers the last mode; a mode toggle sits in the top bar, with an optional parent lock behind
  the parent gate. Child-safe ads in all three Craft apps (including Champion), banner and rewarded only, no interstitials. Play Games sign-in only where the age allows it: Champion and the Mind apps,
  never Scout or Ranger (this amends the 2026-11-06 rule). Coin packs are sold like the other apps, behind the parent gate. **Money model:** starter content free; extra learning packs bought with real
  money at a plain price behind the parent gate; coins buy game extras only, never learning content. Paid packs unlock on the device after Play Billing confirms the purchase (no backend).
- Mind apps (owner, 2026-11-09): the Mind series is for adults (18+). Ads are the same as the existing games (banner on menu, paced interstitials, optional rewarded). One Remove Ads per hub; coins
  buy per-minigame extras such as Continue. Optional Play Games sign-in. Existing games join the hubs as modules later; the standalone apps stay.
- AdMob (owner, 2026-11-09): the owner creates 5 AdMob apps and 12 ad units (Craft: banner and rewarded; Mind: banner, interstitial and rewarded) and sends the IDs. Claude has no AdMob access and
  credentials are never shared. Test ad IDs only until the real IDs arrive. Full plan: `docs/PLAN-new-apps.md`; issue drafts (not posted): `docs/issue-drafts/`.

- Content and engine decisions (owner, 2026-11-09), which supersede the earlier "starter content free, extra packs bought" wording: **built-in content** is partly open and a small part opens each day
  (defaults: 10 items per subject at the start, 2 per subject per day, only when every open item has been passed; per year level chosen at first launch); a parent buys **Full Unlock** (one non-consumable per app)
  to open all built-in content. **Extra packs** have a free preview, downloadable by a parent without charge (its contents depend on the pack), and a full part bought once per pack; the full part is downloaded after the
  purchase. A parent area behind the parent gate holds the extra packs. Coins never buy learning content.
- Engine delivery (owner, 2026-11-09): the shared engine is **vendored** (`lib/engine/` copied into each game, with a sync script and a CI drift check), not Dart packages. Issue 1 is split into 1A (content model and tools),
  1B (delivery, daily release, Full Unlock, extra packs) and 1C (minigame framework, compliance profiles, generator). Game ids are snake_case: `craft_lowteen`, `craft_preteen`, `craft_highteen`, `mind_1`, `mind_9`.
  Content is served from `https://content.activemindcraft.com/v1/` (static files on the owner's Hostinger VPS behind Caddy), language `en-AU`. **Content signing is optional until the owner adds a key**; the Android upload
  keystore (GitHub secrets) is never used for content signing, and the owner creates a separate Ed25519 key and keeps the private key off every repo.

## Casual games hub, fourth app (owner, 2026-11-06)
- A fourth app, general audience and non-education (name still open), holds many casual games: Block Puzzle, Blockfall and Wingy
  plus new ones (merge, solitaire, sudoku, ball sort, stack tower, brick breaker, mahjong tile match, snake). Games are built as modules
  so a hub and a standalone app share the same code.
- The three existing apps (`game-block-puzzle`, `game-block-fall`, `game-wingy`) stay standalone.
- One shared "Remove Ads" purchase in the hub covers all its games. It is separate from the standalone apps' purchases.
- Play Games sign-in: **none in the three Craft apps** (progress is saved on the device only). **Play Games sign-in in the hub**, optional,
  so the hub works fully without it (players under the account age limit cannot sign in).
- Build order: hub with the new games first; converting the three existing games to modules comes as a second step.

## Casual hub names (owner, 2026-11-09)
- The two casual hubs are **Mind Ember Games** (calm puzzle and block games) and **Mind Zip Games** (fast, energetic games). Ids: `mind_1` (Ember), `mind_9` (Zip).
  Provisional: web searches found no exact app or trademark for either. Known risk (owner accepted, 2026-11-09): a MindZip flashcard learning app exists on Android (Polish review), so Mind Zip carries a medium naming risk. Check it first in the Play Store and USPTO searches; fallbacks for the fast hub are Mind Clip (suggests short, not fast) and Mind Dart. Play Store, USPTO and domain checks are still pending.
  Ruled out: Mind Spark, Mind Stack, Mind Flow, Mind Rush, Mind Arcade, Mind Bolt, Mind Breeze, Mind Haven, Mind Zen, Mind Zoom, Mind Flex (Mattel MINDFLEX), Mind Aura (MIND AURA marks), Mind Haze (cannabis connotation), Mindora, and the plain Chill, Zip, Aura, Flex and Rizz Games names. Mind Quill, Mind Glide and Mind Nitro were considered and replaced.

## Studio website (owner, 2026-11-09)
- `ya-spark/activemindcraft-website` is a private repo for the Active Mind Craft website. It holds a second copy of the privacy policies; the canonical public URLs stay on `ya-spark/public` (GitHub Pages) until the website is live and the store listings are moved.
- Hosting: the owner deploys it later on their Hostinger VPS, behind the Caddy instance that already serves several sites there, as one more site. Static files only (no backend). Deployment credentials (SSH keys, tokens) are never committed; the owner sets them up.
- The casual hub repos are `ya-spark/game-mind-1` (Mind Ember, calm) and `ya-spark/game-mind-9` (Mind Zip, fast), renamed by the owner on 2026-11-09. Like the Craft repos, the repo names are internal; the store names are Mind Ember Games and Mind Zip Games unless the owner says otherwise.

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
