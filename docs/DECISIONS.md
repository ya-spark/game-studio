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
  `com.activemindcraft.craftscout`, `.craftranger`, `.craftchampion`; casual hubs `com.activemindcraft.mindember`, `.mindpresto`. Play Store and trademark checks for the three store names still pending.
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

- Design decisions (owner, 2026-11-09): Claude proposes each app's palette and style and designs it in Figma in a live session, the owner reviews; handoff is exported assets (SVG for icons, avatars and mascots, WebP for illustrated backgrounds)
  plus a tokens file committed to the repos, because automatic runs cannot open Figma. All art is original and listed in `assets/LICENSES.md`: no stock illustrations and no AI-generated images. Open-licensed fonts are bundled.
  Navigation in the Craft apps is a bottom bar that changes with the mode (Game: Play, Challenges, Shop; Study: Learn, Progress, Revise) plus a mode toggle in the top bar. The interface level of Scout and Ranger follows the year
  level (Scout: Foundation to Year 2 and Years 3 to 6; Ranger: Years 7 to 8 and Years 9 to 10). New repos start with CI off (the `CI_ENABLED` repository variable), and the owner turns it on after the first working build.

- **Later decisions (owner, 2026-11-09), which win where earlier text differs:**
  - Craft rewards: children earn **stars** (1 per item passed the first time, bonus stars for finishing a topic and for a daily streak); stars are progress only, never spent, and parents see them in the progress report.
    **Coins** are bought by a parent, plus a small earned trickle for finishing a topic, daily streak milestones, a daily learning goal and a weekly goal, capped at 60 coins a week per child. Coins buy avatars, colours and
    permanent unlocks of coin-locked minigames; they never buy learning content. The Mind hubs keep coins earned in play and bought in packs, no stars.
  - Games are either `free_with_ads` or `coins` (a permanent unlock); Quick quiz and Study mode are always free. This applies to the Craft apps and the Mind hubs. Prices are proposed later and approved by the owner.
  - Ads: no interstitials anywhere. Craft apps: child-safe banner only, no rewarded ads. Mind hubs: banner plus an optional rewarded ad for Continue. The banner shows only before and after a game, never during play.
    Remove Ads is one purchase per app and removes every ad. This replaces the earlier 12 ad units: the owner needs 5 AdMob apps and 7 ad units (a banner for each Craft app; a banner and a rewarded unit for each Mind hub).
  - Learning content is bought with **real money**, never coins, with a Play product per extra pack created dynamically from the pack manifests (price tiers, permanent product-id rule, optional year bundles); Full Unlock is one product per app.
  - The content lives in a separate private repo, `ya-spark/game-content`, a submodule of game-studio. Hosting starts on the owner's Hostinger VPS behind Caddy (no extra cost), with the free Cloudflare proxy in front later if needed;
    deploy is over SSH with a key restricted to the content folder. One `sync-products` workflow in the content repo creates products for all five apps through the Play API with the existing service account
    (Manage store presence covers in-app products; the owner adds each app to its permissions); it never runs from an overnight run. Content signing stays optional until the owner adds a key.
  - Scout content: about 100 items per subject and year, 1,400 in total (maths and English, Foundation to Year 6), written in seven content issues in `game-content`. Ranger and Champion content follow the same pattern.
  - Issue structure: 1A (done, #90), 1B (#91), 1C, 1D, the Figma design phase, 02, shared minigames M1 (door runner, balloon pop), M2 (memory match, sort into bins), M3 (series builder, word builder), 09 (content repo), then the five app issues,
    then the content issues, then 08. Drafts are in `docs/issue-drafts/`.

- **Game access and coin prices (owner delegated the choice, 2026-11-09; Claude's recommendation adopted):** principle: practice-style games that teach stay free with ads; the arcade-style extras cost coins. Coin prices: a coin-locked game
  200 coins in the Craft apps and 300 in the Mind hubs; an avatar 40; a colour theme 60; a streak freeze 100. Coin packs stay 500, 1500 and 4000 as in the other games; the real-money price points are decided later with the price tiers.
  Craft Scout: free with ads = Quick quiz, memory match, sort into bins, series builder, word builder; coins = door runner, balloon pop. Craft Ranger: free = Quick quiz, series builder, word search and crossword, equation builder,
  sort into bins, true or false; coins = door runner and tug-of-war quiz. Craft Champion: free = Quick quiz, equation builder, cloze and grammar fix, flash review, true or false; coins = door runner and tug-of-war quiz.
  Mind Ember: free = Sudoku, Solitaire, ball sort; coins = mahjong and merge. Mind Presto: free = snake, brick breaker, stack tower; coins = runner and balloon pop. The existing three games stay free with ads inside the hubs. Quick quiz and Study mode are always free.
  With the 60 coins a week trickle, a child can earn a coin-locked game in about a month, or a parent can buy a coin pack.

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
- The two casual hubs are **Mind Ember Games** (calm puzzle and block games) and **Mind Presto Games** (fast, energetic games; "presto" means very fast). Ids: `mind_1` (Ember), `mind_9` (Presto).
  Provisional: web searches found no exact app or trademark for either. Nearest to Presto: many PRESTO marks owned by others (for example Presto AB, Presto Innovations, LLC) and a reaction game called Presto Starto (Fish Mug Games); check
  classes 9, 28 and 41 on the official registers. Play Store, USPTO and domain checks are still pending.
  Ruled out: Mind Zip (a MindZip learning app by MindZip.net GmbH, Munich, is active), Mind Spark, Mind Stack, Mind Flow, Mind Rush, Mind Arcade, Mind Bolt, Mind Breeze, Mind Haven, Mind Zen, Mind Zoom, Mind Flex (Mattel MINDFLEX),
  Mind Aura (MIND AURA marks), Mind Haze (cannabis connotation), Mind Pulse (MINDPULSE registered), Mind Flick (MINDFLICK registered), Mind Dash (an app with that name), Mindora, and the plain Chill, Zip, Aura, Flex and Rizz Games names.
  Clean fallbacks for the fast hub: Mind Gust, Mind Dart, Mind Rally, Mind Whirl, Mind Tempo, Mind Clip. Package names (owner confirmed 2026-11-09): `com.activemindcraft.mindember` and `com.activemindcraft.mindpresto`
  (changed from `.mindzip` before any upload).

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
  from `@claude` in a `game-studio` issue (`.github/workflows/run-claude-from-issues.yml`) or from a live session.
- CI runs take about 10 to 12 minutes (the debug APK build is the slow job). Cancelling a run
  needs a re-run before merging.
- Stop-hook warnings about "unpushed commits and no remote branch" on freshly cloned repos are
  usually false alarms: check `git ls-remote --heads origin`, then set the upstream.
- Specs live only in each game repo's `docs/SPEC.md`, never mirrored in game-factory; behaviour instructions are recorded there with exact values (owner, 2026-11-05).
- Design phase done (owner, 2026-11-10): the Figma file is https://www.figma.com/design/ymFJswpzJer3Uicm5VfBKd and the handoff files are in `game-factory/template/flutter-game-template/design/` (tokens, icons, mascot, hero scenes, fonts, README). Palettes approved: Scout warm cream and sky blue, Ranger deep navy with teal and orange, Champion near-black with violet and lime, Mind Ember warm charcoal and orange, Mind Presto midnight with cyan and magenta; Craft apps have Game and Study looks. Fonts: Nunito (Scout, Ranger) and Plus Jakarta Sans (Champion and the Mind apps), both open licence. **No human figures, faces or silhouettes in any art** (characters are friendly shapes). Hero scenes are SVG, not WebP. Cards: Scout shows stars, bars and status chips with no percentages; Ranger and Champion also show accuracy; mastery levels Learning, Getting there, Mastered; extra pack cards show "Preview free" and a locked "Full pack" with **no price** (the price appears only behind the parent gate); a "try next" card sits at the top of Play and Learn. Shop, Challenges, Progress, Revise and the parent area are not designed in Figma yet; issue 02 builds them from the tokens.
- Content hosting and access (owner, 2026-11-11): content stays on the owner's Hostinger VPS (Caddy), published by the `game-content` `publish` workflow over a restricted SSH key. The free Cloudflare proxy goes in front of `content.activemindcraft.com` (cache for free content, rate limits, hidden origin; the VPS accepts web traffic only from Cloudflare; the paid folder and the `/auth` path are never cached). Paid packs are protected by a **purchase check on the VPS**: the app sends its Play purchase token to a small service on the VPS, which verifies it with the Google Play Developer API and returns a short-lived signed download link for one pack; Caddy serves paid files only with a valid link. This is a **deliberate, limited exception to the no-backend rule**: that one service, purchase checking only, no accounts, no personal or child data (a purchase token only), the Play service-account key kept on the VPS and never in a repo, the privacy policy names it. Built later as its own issue; until then paid packs rely on unguessable file paths and Play Billing on the device. No Cloudflare Worker, R2 or GCP for now. Later, the privacy policy site (now GitHub Pages from `ya-spark/public`) is also moved behind Cloudflare.
- CI switch (owner, 2026-11-11): CI is off until the coding is finished and the first real build works. It is controlled by the repository variable `CI_ENABLED` (Settings, Secrets and variables, Actions, Variables): set it to `true` to turn CI on, delete it or set anything else to turn it off. `game-factory`'s `template-ci` follows it (a run started by hand always runs), and so do the CI files the generator writes into every new game repo. The switch applies to the core repos (`game-factory`, `game-content` once its `ci.yml` is copied in) and to every new app or hub repo; the three existing games (Block Puzzle, Blockfall, Wingy) are left exactly as they are. `game-factory` is currently OFF (the variable is not set). The `@claude` runs still run their own local checks (format, analyze, tests, scripts) before pushing. Run `template-ci` by hand once before generating the real apps.
- Content and store setup order (owner, 2026-11-11): **Claude writes the initial content** (Craft Scout first, 1,400 items in issues C1 to C7, maths and English, Foundation to Year 6; Ranger and Champion content follow), the owner reviews it before any pack is marked live; packs are original, en-AU, no curriculum wording, no people, an explanation on every item. The draft `topics.yaml` stands as written unless the owner changes it. **Finish the apps first**; the Play Console, AdMob and Cloudflare setup and the real prices for the content price tiers (placeholders t1 to t6 for now) come later, before the first release.
- Existing games in the hubs as synced copies (owner, 2026-11-11; this replaces the same-day "shared module" decision): Block Puzzle, Blockfall and Wingy stay exactly as they are as standalone apps and are **copied** into the Mind hubs (Ember: Block Puzzle, Blockfall; Presto: Wingy), kept identical by a sync script and a lock file, the same way the engine is synced. The standalone app is the source of truth: a fix is made there and a sync issue carries it to the hub. The copy gets an adapter so it uses the hub's single coin balance, one Remove Ads and the ad pacing (banner before and after a game only, optional rewarded Continue, no interstitials); saves are separate from the standalone apps. The standalone apps are not changed by this work. No release, tag or store upload without the owner's explicit approval.

- Hostinger VPS web hosting (owner, 2026-11-12): the five new apps also get a web build, hosted on the same Hostinger VPS behind Caddy at one web host (one folder per app, for example `/scout/`, `/ranger/`, `/champion/`, `/ember/`, `/presto/`). **Access control is done in Caddy** (basic auth on the web host), never in the apps. Builds are uploaded by a GitHub workflow over SSH with a restricted deploy-only key, the same pattern as the content publish. This widens the earlier "web is a test harness only" rule to a hosted web copy on the Hostinger VPS; the product stays Android-only, `platforms.web.enabled` stays false in `app.config.yaml` unless the issue says otherwise, and platform-only features (ads, billing, Play Games, notifications) are stubbed on web, never faked as working. No secrets in repos; the VPS, Caddy, DNS and Cloudflare steps are the owner's (see `docs/DEPLOY-TO-VPS-AS-WEB.md`).
- DNS (owner, 2026-11-12): everything under `activemindcraft.com` (content, web, and later the privacy site) points at the Hostinger VPS, served by one Caddy.
- VPS location (owner, 2026-11-12): the Hostinger VPS is in India. Latency to Australia is higher than from Singapore or Malaysia, so the free Cloudflare proxy (Sydney edge cache for free content) matters more; the web copy and the purchase check are low-traffic and fine.
- Workflow structure and names (owner, 2026-11-13): every name says what it does. Studio: `run-claude-from-issues`, `deploy-to-vps-as-web`. Game pipelines live once in `game-factory/.github/workflows/shared-*.yml` (`shared-check-code`, `shared-release-to-closed-testing`, `shared-check-play-status`, `shared-promote-to-production`); each game repo has a thin caller named `check-code`, `release-to-closed-testing`, `check-play-status`, `promote-to-production`. Every game uses them: the five new apps, the template and the three older games (Block Puzzle, Blockfall, Wingy), which were converted on 2026-11-13 at the owner's request (this ends the earlier "leave the three old games exactly as they are" rule for CI files; their code is still not touched). The older games also have `make-store-screenshots`. A check that needs a script runs only when the game has that script. The per-game `web-vps.yml` files are removed. Change agents are `change-agent` (plan and code) and `change-release-agent`; the agent folders are `.claude/agents/new-app/` and `change-app/`.

- Web as a product, funded by AdSense (owner, 2026-11-14): the web copies of the five new apps become a public product earning from Google AdSense only (IDs added later by the owner); this replaces "web is a test harness only" for these five apps. The web save stays in the browser and is never moved to or from the Android app. Child-directed apps are included and tagged with Google's age tag (TFAT): Scout and Ranger `CHILD`, Champion `TEEN`, non-personalised ads only; Mind Ember and Mind Presto carry no child tag. Ads only at menu, before and after a game, never in play; no interstitials or rewarded ads on web; no real-money items on web. The three older games' code stays untouched. Plan and owner steps: `docs/QUEUE.md`, item X2. Claude does not assess COPPA or local law; the owner reviews the privacy text and Google's current policy before going live.
- Automatic web deploys (owner, 2026-11-14): Claude deploys the web UAT copies by running `deploy-to-vps-as-web` whenever a game's work has finished, its checks pass and its pin matches `main`, without asking the owner (one deploy at a time, batched per monitoring round, only the affected games). This replaces "only the owner runs a real deploy" in `docs/DEPLOY-TO-VPS-AS-WEB.md`. Claude still never touches secrets, DNS, Caddy, the login, Cloudflare, store releases, tags or version bumps; a VPS, SSH or secrets failure stops deploys and is reported to the owner. The UAT copies stay behind the Caddy login until the owner removes it (see X2 in `docs/QUEUE.md`).
