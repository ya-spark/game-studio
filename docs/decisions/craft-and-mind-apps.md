# Craft family and Mind apps

Verbatim archive from `docs/DECISIONS.md` (split 2026-11-21 to save tokens). The index there says when to read this file.

## Craft family: education games (owner, 2026-11-06)
- Three apps, shipped together, one per age band, sharing one engine and one content format. The names **Craft Scout Games** (Foundation to Year 6, ages about 5-12),
  **Craft Ranger Games** (Years 7-10, about 12-16) and **Craft Champion Games** (Years 11-12, senior secondary, about 16-18) are used **only on Google Play** (owner, 2026-11-09). In the repos, the
  factory registry and the code, the apps use the age-band names. Repos (created by the owner, kept as named): `ya-spark/game-craft-preteen`
  (Scout), `ya-spark/game-craft-lowteen` (Ranger)  [swapped on 2026-11-15, see below], `ya-spark/game-craft_highteen` (Champion; the underscore is kept; the generator's `--repo` override is needed because it writes kebab-case repo names).
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

## Education vision and the format contract (owner, 2026-11-21)
- The studio exists to teach; games are the medium. Craft apps teach school subjects by stage; Mind Ember and Presto are positioned as **keeping the mind sharp** (adult brain exercise: memory, attention, logic, mental maths, words). No claim of preventing decline, treating or curing anything.
- Content and games are separate modules joined only by the **question format**: a closed, versioned set (`mcq`, `series`, `pairs`, `category`, `word`, `numeric`, `cloze`). A game declares the formats it plays and its smallest pool; a topic provides the formats it has items for (not all); the matcher offers the games that fit. Games hold no content. Fun score and knowledge score stay separate.
- Mind standalone games get a second, small contract (skill, score, difficulty) and a daily workout with per-skill trend, kept on the device.
- Full text, the game-by-format matrix (from the code), the gaps and the order of work: `docs/VISION-education.md`. Scout proves the loop first (to be confirmed). W2/W2.1, X2 and new skill-less Mind games wait.
- Skill trail (owner, 2026-11-21): learners see a trail of skills (year, topic, skill rung) instead of a game list; games are the interface and only item results move a skill. Next step is Auto (default), Pick a skill, Pick a game or Skip ahead; a child may jump into locked rungs through a 5-item check (4 correct). Thresholds by app (Scout 75% of last 8, Ranger 80% of last 10, Champion 85% of last 10, on 2 days) and the anti-luck rules are in `docs/VISION-education.md` section 8. The visible name is still open (internal `trail`).
- Curriculum alignment is internal only (owner, 2026-11-21): topics and skills follow the Australian curriculum, but nothing a user can see (website, web catalog, apps, store text, privacy pages) says Australia, curriculum, strands, syllabus names or codes. The skill-to-curriculum mapping stays in the private content repo. Code-level labels users never see (`lang="en-AU"` in page source and packs) stay as they are. Details in `docs/VISION-education.md` section 8.
- English content follows Australian English (owner, 2026-11-21): spelling, vocabulary and usage, with English topics and skills aligned internally to the Australian curriculum for English (invisible to users, as for maths). `spelling.dart` already warns on US spellings; a US-to-Australian vocabulary list is not yet built. Owner review of English items stays required. See `docs/VISION-education.md` section 8.
- Question format constraints (owner, 2026-11-21): item limits and game limits are designed to overlap so most items play in most games. A validator-enforced envelope per format, a derived `short`/`long` size class (prompt 150, options 30, tiles 24, same for all apps), and per-game limits the matcher checks; action games take `short`, card games take both. `mcq` is 2 to 4 options, exactly one correct. `expression` stays an optional author note (no game reads it); Equation builder's limit is a whole-number answer 0 to 999 (owner, 2026-11-21, after the first rule was found to rest on a wrong assumption). Full text, limits and measurements: `docs/FORMAT-CONSTRAINTS.md`.
- Skill list approved (owner, 1:01 PM AEDT, 2026-11-21): the authored rung names in `game-content/skill_names.yaml` (listed in `docs/SKILLS-REVIEW.md`) stay as they are. Any later change is a rename in that file and a regenerate.
- Trail name and look (owner, 1:04 PM AEDT, 2026-11-21): **Constellation**, as in the mock. Each topic is a small constellation, each rung a star; stars light up as the child learns and lines join what is done. Replaces the open naming question (internal name stays `trail`).
- Topic list and order (owner, 1:04 PM AEDT, 2026-11-21): keep the current order for now; the topic list and the order are reviewed later (backlog). Supersedes the open C5 order review.

