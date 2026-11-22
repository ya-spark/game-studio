# Decisions and standing instructions

Owner decisions made in conversation: the memory a fresh session or routine run does not have.
**This file is an index (split 2026-11-21 to save tokens).** Read it, then open a file under
`docs/decisions/` only when your task touches its topic (grep it, do not read it whole). Add new
decisions to the matching topic file with the date, and update the digest here if a rule changes.
The topic files hold the full original text and win over the digest where they differ.

## Owner and how to work
- A game's folder, package and id are its name (owner, 2026-11-22): rename on rewrite; the web shows the game's title.
- Queue layout (owner, 2026-11-22): `docs/QUEUE.md` is a one-line-per-item index (each line under 20 words); detail is one file per item in `docs/queue/`. When an item changes, edit its own file and its one line; dated detail still goes in `docs/QUEUE-LOG.md`.
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
- Queue loop (owner, 2026-11-22): one session does all work with `/run-queue`, wakes hourly for 36 hours; role agents deleted; checks are not a gate (log, still push); VPS web deploy by pin push allowed; app games paused until the web is complete. Detail: `docs/decisions/operations.md`.
- Do not create repos in `ya-spark` (403). The owner creates them; attach them with `add_repo`.
- Ads (owner, 2026-11-22): web AdSense real ids/slots may be used and changed freely; ask only before creating new ad units or deleting ads; AdMob stays out until the owner gives access. Replaces "no real ad ids" for web.
- Revised games (owner, 2026-11-22): a game that is rewritten or revised gets everything a new game gets (`game-factory/docs/BEST_PRACTICES.md`, keyboard, frame and chrome, responsive layout, question and skill contracts, SPEC, Figma or code art, no living beings).
- No living beings in games (owner, 2026-11-22): no people and no animals as characters or in art; characters are toys, robots, shapes or objects.
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

## Digest of the topic files (read the file before acting on anything in it)

- **Vision (owner, 2026-11-21): an education platform; games are the medium.** Content and games are modules joined by a closed set of question formats; Mind hubs are "keeping the mind sharp". Read `docs/VISION-education.md` before planning any app, game or content work.

- `decisions/craft-and-mind-apps.md`: Craft Scout/Ranger/Champion (education, by school stage) and Mind Ember/Presto
  (adult casual hubs). Store names only on Play; repos and ids use age-band names (ids are historical, see `web.md`).
  Packages `com.activemindcraft.<name>`. Content is original, en-AU, never mentions a curriculum, no people in art.
  Children's apps: family-safe ads, parental gate, no Play Games sign-in in Scout/Ranger. Money model, coin prices,
  game access (free vs coins), engine vendoring and the content repo are all there. The 2026-11-15 move away from
  coins is in `web.md`.
- `decisions/release-and-store.md`: **default track is closed testing (alpha), never internal or beta unless asked;
  production always needs the owner**; browser test before every closed-testing release; testing countries are
  Australia and India only; Play service account permissions; privacy policies on GitHub Pages (`ya-spark/public`,
  keep public, in sync with each game's `store/google-play/privacy_policy.md`).
- `decisions/operations.md`: design handoff (Figma file, palettes, fonts, no human figures), content hosting and
  the one purchase-check service exception, `CI_ENABLED` switch, content setup order, hub copies of old games,
  VPS web hosting and DNS, workflow and agent names, automatic UAT deploys (no secrets, DNS, Caddy, tags, versions).
- `decisions/web.md` (read its 2026-11-21 section "Web and app differ on purpose" first: web all free and ad-funded, progress saved in the browser, rungs open by purchase or ad in the app, keyboard play everywhere): web is a separate catalog product in `ya-spark/games-web` (public, no secrets), live at
  `activemindcraft.com/games/<slug>/`, no saved progress, nothing purchasable; `/appgames/` is test copies the studio
  session does not touch; issue posting resumed 2026-11-16; landing page never mentions age or audience.

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
