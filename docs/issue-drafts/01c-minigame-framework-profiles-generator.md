# [change] factory: minigame framework, compliance profiles, generator and engine sync (issue 1 of 3: 1C)

**Repo:** game-factory (template, generator, scripts). **Depends on:** 1A and 1B being finished and passing. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
A standard way to plug minigames into the content, settings that make an app child-safe or adult, a generator that starts the new apps from the same engine, and a way to keep every app's copy of the engine identical.

## Decisions already made (owner, 2026-11-09)
- `--profile craft` and `--profile mind` generate **without the Block Puzzle game**. Craft gets the engine, profiles, parent area and the Quick quiz; Mind gets a hub shell with no games yet. The plain template still builds the old kind of single game.
- Quiz coins: 1 per correct answer, a small streak bonus, a daily cap.
- Reading aloud: the prompt and the options with a speaker button, automatic in Scout's younger level, explanations on request; recorded audio first, text-to-speech as the fallback.
- Three compliance profiles: child (Scout, Ranger), teen (Champion), adult (Mind), with a CI check that rejects unsafe combinations.
- The reference quiz ships as a plain "Quick quiz" minigame in all three Craft apps.
- The engine is copied into each game (vendored). A change is copied by a sync script, run by one `[change]` issue per sync.
- An empty `AiTutorService` interface, off by default. No AI feature ships.
- Accessibility basics (text size, contrast, reduce motion, screen-reader labels): the shared widgets are issue 2; this issue covers the screens it builds.

## Scope
- **Minigame framework** (`lib/engine/minigames/`):
  - `MiniGame` interface: `id`, `title`, supported item types, `minPool` (the number of open items a game needs before it appears), supported modes, `build`.
  - `QuizSession`: supplies items from the selector, records each answer and pass per child, awards coins, reports progress, so every minigame scores the same way.
  - Coin rules in `app.config.yaml` under `quiz.coins`: `per_correct: 1`, `streak_bonus_every: 5`, `streak_bonus: 2`, `daily_cap: 50`. The cap is per child per day (the coin balance itself is shared by the device).
  - A per-app registry chooses which minigames appear, in which mode and at which level.
- **Quick quiz:** a plain multiple-choice (and true or false) minigame that works in Game and Study mode, shows the explanation after each answer, records passes and awards coins by the rules above. It ships in all three Craft apps.
- **Reading aloud:** a `SpeechService` interface (`speak`, `stop`, `isAvailable`) with a text-to-speech implementation (the vendor package pinned exactly and imported only in that file; the `en-AU` voice is preferred). A recorded `audio` file is used when an item has one. A speaker button reads the prompt and the options; `speech.auto_read` (config, set per level by each app) reads automatically; explanations are read on request. Test IDs added.
- **Compliance profiles** in `app.config.yaml`: `audience: child | teen | adult`. Defaults: 
  - `child`: `ads.child_directed: true`, no interstitials, banner on the menu only, no Play Games sign-in, parent gate on every real-money purchase.
  - `teen` (Champion): child-safe ads, no interstitials, banner on the menu only, optional Play Games sign-in, parent gate on purchases.
  - `adult` (Mind): the existing ads pacing, optional Play Games sign-in, no parent gate.
  - The ads service applies child-directed treatment and a restrictive content rating when the profile asks for it.
  - A new `scripts/profile_check.sh` (with a self-test, like `ad_safety_check.sh`) and an extended `ad_safety_check.sh` fail CI on unsafe combinations, for example `child` with interstitials, sign-in or a missing parent gate, or `adult` settings in a `child` app.
- **Generator** (`scripts/new_game.py`): `--profile craft|mind` and `--audience child|teen|adult`; a `--repo` override (the registry writes `ya-spark/game-<kebab-id>` by default, which does not match `game-craft_highteen`); ids stay snake_case (`craft_lowteen`, `craft_preteen`, `craft_highteen`, `mind_1`, `mind_9`). The generator copies `lib/engine/` and the profile defaults. The plain template behaviour is unchanged.
- **Engine sync:** `scripts/sync_engine.py <game-repo-path>` copies `lib/engine/` (and its tests) into a game and writes an `engine.lock` hash; `sync_engine.py --check` lists the games that are behind. A check in each game's CI fails if `lib/engine/` was changed locally without a sync (the hash no longer matches). The factory's CI keeps a documented note on how to run a sync as one `[change]` issue.
- **AiTutorService:** `lib/engine/ai/` holds an interface (`isAvailable`, `explain`) and a `NoAiTutorService` that reports unavailable; `ai.enabled: false` in config. No vendor code. A note in the docs: Google Play's generative-AI policy needs in-app reporting, and the Gemini API terms limit use in apps for under-18s, so any real implementation needs its own issue and decision.
- **Accessibility for the screens built in 1B and 1C** (profile picker, parent area, Quick quiz): a screen-reader label on every control, no layout break at 150 percent text, contrast at least 4.5 to 1.
- **Docs:** `docs/ENGINE.md`, `scripts/README.md`, the template `docs/SPEC.md` and `docs/CONTENT_FORMAT.md` cross-references.

## Acceptance
All checks pass in the template, in the generator job and in a freshly generated sample game for each profile (`craft` and `mind`), including the debug APK build. Tests: framework scoring, the daily coin cap per child, minimum-pool gating, Quick quiz in both modes, reading aloud (recorded audio first, text-to-speech fallback), profile gating, `profile_check.sh` accepting good and rejecting bad configs, the generator flags and the `--repo` override, the sync script and the lock check, `NoAiTutorService`, text scaling at 150 percent and screen-reader labels on the new screens.

## Out of scope
The design system, themes and the Game or Study mode screens (issue 2), the real minigames (the five app issues), real AdMob IDs, any real AI feature, the platform-subscription source.
