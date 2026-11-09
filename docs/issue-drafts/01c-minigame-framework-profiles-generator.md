# [change] factory: minigame framework, rewards, compliance profiles, generator and engine sync (issue 1 of 4: 1C)

**Repo:** game-factory (template, generator, scripts). **Depends on:** 1A and 1B finished and passing. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first (the "later decisions" section wins where texts differ).

## Goal
A standard way to plug minigames into the content, the reward and access rules, settings that make an app child-safe or adult, a generator that starts the new apps from the same engine, and a way to keep every app's copy of the engine identical.

## Decisions already made (owner, 2026-11-09)
- `--profile craft` and `--profile mind` generate **without the Block Puzzle game**. Craft gets the engine, profiles, parent area and the Quick quiz; Mind gets a hub shell with no games yet. The plain template still builds the old kind of single game.
- **Craft rewards:** a child earns **stars** (1 per item passed the first time, bonus stars for finishing a topic and for a daily streak). Stars are progress only and are never spent. **Coins** are bought by a parent, plus a small earned trickle: finishing a topic, a daily streak milestone, a daily learning goal and a weekly goal, capped at **60 coins a week per child**. Learning content is never bought with coins.
- **Mind hubs:** coins are earned in play and bought in packs, as in the existing games. No stars.
- **Game access:** each minigame is either `free_with_ads` or `coins` (a permanent unlock with a coin price). Quick quiz and Study mode are always free. Prices are proposed later.
- **Ads:** no interstitials anywhere. Craft apps (child and teen profiles): banner only, no rewarded ads. Mind hubs (adult profile): banner plus an optional rewarded ad for Continue. The banner shows only **before and after a game** (menu, start and results screens), never during play.
- Reading aloud: the prompt and the options with a speaker button, automatic in Scout's younger level, explanations on request; recorded audio first, text-to-speech as the fallback.
- Three compliance profiles: child (Scout, Ranger), teen (Champion), adult (Mind), with a CI check that rejects unsafe combinations.
- The reference quiz ships as a plain "Quick quiz" minigame in all three Craft apps.
- The engine is copied into each game (vendored) by a sync script, one `[change]` issue per sync.
- An empty `AiTutorService` interface, off by default. No AI feature ships.
- Accessibility basics: shared widgets are issue 2; this issue covers the screens it builds.

## Scope
- **Minigame framework** (`lib/engine/minigames/`):
  - `MiniGame` interface: `id`, `title`, supported item types, `minPool`, supported modes, `access` (`free_with_ads` or `coins`) and `coinPrice`, `build`.
  - `QuizSession`: supplies items from the selector, records each answer and pass per child, awards stars, reports progress, so every minigame scores the same way.
  - A per-app registry chooses which minigames appear, in which mode and at which level, and applies the access rule (a locked game shows its coin price; spending coins to unlock is permanent and saved per device).
- **Rewards** (config `rewards`): `stars.per_first_pass: 1`, `stars.topic_bonus`, `stars.streak_bonus`; `coins.weekly_cap_per_child: 60` with the earning events listed above (each milestone pays once). The template's daily reward and daily challenges give stars and capped coins in the Craft apps, and stay coin earners in the Mind hubs.
- **Quick quiz:** a plain multiple-choice (and true or false) minigame that works in Game and Study mode, shows the explanation after each answer, records passes and awards stars. It ships in all three Craft apps.
- **Reading aloud:** a `SpeechService` interface (`speak`, `stop`, `isAvailable`) with a text-to-speech implementation (vendor package pinned exactly, imported only in that file; `en-AU` preferred). A recorded `audio` file is used when an item has one. A speaker button reads the prompt and the options; `speech.auto_read` (config, set per level by each app) reads automatically; explanations on request. Test IDs added.
- **Ads service:** placements `menu`, `pre_game` and `post_game` only; there is no in-play placement. `interstitials_enabled` is false in every profile. Rewarded ads exist only in the adult profile.
- **Compliance profiles** in `app.config.yaml`: `audience: child | teen | adult`. Defaults:
  - `child` (Scout, Ranger) and `teen` (Champion): child-directed ads, banner only, no rewarded ads, parent gate on every real-money purchase and on coin spends for games; `child` has no Play Games sign-in, `teen` allows optional sign-in.
  - `adult` (Mind): banner plus rewarded Continue, optional Play Games sign-in, no parent gate.
  - `scripts/profile_check.sh` (with a self-test) and an extended `ad_safety_check.sh` fail CI on unsafe combinations, for example any interstitial, rewarded ads in a `child` or `teen` app, sign-in in a `child` app, or a missing parent gate.
- **Generator** (`scripts/new_game.py`): `--profile craft|mind`, `--audience child|teen|adult`, `--ci on|off`, and a `--repo` override (the registry writes `ya-spark/game-<kebab-id>` by default, which does not match `game-craft_highteen`); ids stay snake_case. The generator copies `lib/engine/` and the profile defaults.
- **CI off at first in new repos:** the generated `ci.yml` guards every job with `if: ${{ vars.CI_ENABLED == 'true' }}`; the owner sets the repository variable `CI_ENABLED=true` after the first working build. `--ci on` writes the file without the guard. Only `ci` is guarded.
- **Engine sync:** `scripts/sync_engine.py <game-repo-path>` copies `lib/engine/` (and its tests) into a game and writes an `engine.lock` hash; `--check` lists games that are behind. A game's CI fails if `lib/engine/` was changed locally without a sync.
- **AiTutorService:** `lib/engine/ai/` holds an interface and a `NoAiTutorService`; `ai.enabled: false`. No vendor code. Docs note Play's generative-AI policy and the Gemini age terms.
- **Accessibility for the screens built in 1B and 1C** (profile picker, parent area, Quick quiz): screen-reader labels, no break at 150 percent text, contrast at least 4.5 to 1.
- **Docs:** `docs/ENGINE.md`, `scripts/README.md`, the template `docs/SPEC.md` and `docs/CONTENT_FORMAT.md` cross-references.

## Acceptance
All checks pass in the template, in the generator job and in a freshly generated sample game for each profile, including the debug APK build. Tests: framework scoring, star rules (first pass only, topic and streak bonuses), the weekly coin cap per child, access rules (free and coin-locked games, permanent unlock), minimum-pool gating, Quick quiz in both modes, ad placements (no in-play placement, no interstitial), reading aloud, profile gating, `profile_check.sh` accepting good and rejecting bad configs, the generator flags and the `--repo` override, the `CI_ENABLED` guard, the sync script and the lock check, `NoAiTutorService`, text scaling at 150 percent and screen-reader labels on the new screens.

## Out of scope
The design system and the mode screens (issue 2), the real minigames (M1 to M3 and the app issues), real AdMob IDs, any real AI feature, the platform-subscription source, publishing and product sync (1D).
