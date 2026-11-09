# [change] factory: minigame framework, compliance profiles and generator (issue 1 of 3: 1C)

**Repo:** game-factory (template, generator, scripts). **Depends on:** 1A and 1B.

## Goal
A standard way to plug minigames into the content, settings that make an app child-safe or adult, and a generator that starts all five apps from the same engine.

## Scope
- **Minigame framework** (`lib/engine/minigames/`): a `MiniGame` interface (`id`, `title`, supported item types, `minPool`, `build`); a `QuizSession` that supplies items from the selector, records answers and passes, awards coins and reports progress, so every minigame scores the same way; a per-app registry that picks which minigames appear in which mode.
- **Reference quiz:** one plain multiple-choice minigame that proves the pipeline end to end. Real minigames come with the app issues.
- **Compliance profiles** in `app.config.yaml`: `audience: child | teen | adult`; `ads.child_directed`; `ads.interstitials_enabled`; `ads.banner_menu_only`; `sign_in.play_games`. For `child` the ads service applies child-directed treatment and a restrictive content rating, no interstitials, and Remove Ads, coin packs and every real-money purchase stay behind the parent gate. `scripts/ad_safety_check.sh` and its self-test are extended so a `child` profile with interstitials enabled fails CI.
- **Generator** (`scripts/new_game.py`): `--profile craft|mind`, `--audience`, and a `--repo` override (the registry writes `ya-spark/game-<kebab-id>` by default, which does not match `game-craft_highteen`). Ids are snake_case: `craft_lowteen`, `craft_preteen`, `craft_highteen`, `mind_1`, `mind_9`. The generator copies `lib/engine/` and the profile defaults.
- **Engine sync:** `scripts/sync_engine.py` copies the factory's `lib/engine/` into a game repo, and a CI drift check fails a game whose copy differs from the factory's version.
- **Docs:** update `scripts/README.md`, the template `docs/SPEC.md` and `docs/CONTENT_FORMAT.md` cross-references.

## Acceptance
All checks pass in the template, in the generator job and in a freshly generated sample game, including its debug APK build. Tests: framework scoring and coin awards, minimum-pool gating, profile gating, generator flags and the `--repo` override, sync script and drift check.

## Out of scope
The design system, themes and Game or Study mode (issue 2), real minigames (apps), real AdMob IDs.
