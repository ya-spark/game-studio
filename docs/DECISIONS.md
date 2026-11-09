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
- Three apps, shipped together, one per age band, sharing one engine and one content format (final names, owner, 2026-11-06):
  **Craft Scout Games** (ages 4-7), **Craft Ranger Games** (8-11), **Craft Champion Games** (12-15). Ids: `craft-scout`, `craft-ranger`, `craft-champion`
  (repos `ya-spark/game-craft-scout` etc., created by the owner; packages `com.activemindcraft.craftscout` etc.). Play Store and trademark checks still pending.
- Each app is a hub of minigames (door runner for multiple choice, series builder, match pairs, true/false, block drop);
  the student content plugs into them. Content packs carry an age-band tag and a content type (MCQ, series, pairs, true/false).
- Content sources, behind a `ContentSource` interface: built-in default packs, and static files (signed JSON and asset
  bundles on a CDN, versioned, cached offline) uploaded by the owner. Static hosting only: no backend, logins or user data.
  A third source (another platform, with subscription) is deferred; it needs a new owner decision on auth and Play Billing.
- Children's apps: family-safe ad networks only; parental gate in front of purchases and any external link; no chat,
  no personal data, no Play Games sign-in (owner, 2026-11-06). "Remove Ads" is a one-time Play Billing purchase (parents). Little band: no timers, picture and voice questions.

## Casual games hub, fourth app (owner, 2026-11-06)
- A fourth app, general audience and non-education (name still open), holds many casual games: Block Puzzle, Blockfall and Wingy
  plus new ones (merge, solitaire, sudoku, ball sort, stack tower, brick breaker, mahjong tile match, snake). Games are built as modules
  so a hub and a standalone app share the same code.
- The three existing apps (`game-block-puzzle`, `game-block-fall`, `game-wingy`) stay standalone.
- One shared "Remove Ads" purchase in the hub covers all its games. It is separate from the standalone apps' purchases.
- Play Games sign-in: **none in the three Craft apps** (progress is saved on the device only). **Play Games sign-in in the hub**, optional,
  so the hub works fully without it (players under the account age limit cannot sign in).
- Build order: hub with the new games first; converting the three existing games to modules comes as a second step.

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

## Release tracks (owner, 2026-11-06)
- Claude may send an app to **any Play track except production**: internal testing, closed testing (Alpha) and open testing (beta).
  Use the `release` workflow (`track=internal|alpha|beta`, `upload=true`) or a version tag.
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
