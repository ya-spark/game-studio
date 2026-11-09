# [change] factory: generator profiles, CI guard and engine sync (issue 1 of 6: 1C3)

**Repo:** game-factory (generator, scripts, template). **Depends on:** 1C1 and 1C2. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first. Part 3 of 3 of the original 1C.

## Goal
A generator that starts the new apps from the same engine, with CI off at first in new repos, and a way to keep every app's copy of the engine identical.

## Decisions already made (owner, 2026-11-09)
- `--profile craft` and `--profile mind` generate **without the Block Puzzle game**. Craft gets the engine, profiles, parent area and the Quick quiz; Mind gets a hub shell with no games yet. The plain template still builds the old kind of single game. A learning profile sets `content.enabled: true`.
- New repos start with CI off (the `CI_ENABLED` repository variable); the owner turns it on after the first working build.
- The engine is copied into each game (vendored) by a sync script, one `[change]` issue per sync.

## Scope
- **Generator** (`scripts/new_game.py`): `--profile craft|mind`, `--audience child|teen|adult`, `--ci on|off`, and a `--repo` override (the registry writes `ya-spark/game-<kebab-id>` by default, which does not match `game-craft_highteen`); ids stay snake_case (`craft_lowteen`, `craft_preteen`, `craft_highteen`, `mind_1`, `mind_9`). It copies `lib/engine/` and the profile defaults. It already rewrites package imports in `tool/` (fixed in `ec8b9f6`); keep that behaviour and its test.
- **CI off at first:** the generated `ci.yml` guards every job with `if: ${{ vars.CI_ENABLED == 'true' }}`; `--ci on` writes the file without the guard. Only `ci` is guarded.
- **Engine sync:** `scripts/sync_engine.py <game-repo-path>` copies `lib/engine/` (and its tests) into a game and writes an `engine.lock` hash; `--check` lists games that are behind. A game's CI fails if `lib/engine/` was changed locally without a sync.
- **Generator job in the factory CI:** generate a sample game for each profile and run the same gates inside it (give the exact YAML in your final comment if a workflow change is needed).
- **Docs:** `scripts/README.md`, the template `docs/SPEC.md`, `docs/ENGINE.md` (how to run a sync as one `[change]` issue).

## Note on workflow files
The `@claude` token cannot push `.github/workflows` files. Put the exact YAML for any workflow change in your final comment and the owner will add it.

## Run discipline (the workflow stops a run after 100 turns, so work in small steps)
Do the work in small steps. After each step whose checks pass, commit and push it to `main` (and move the pin) so nothing is lost. If you are running low on turns, push what passes, then comment exactly what is done and what remains, so the owner can post the rest as a new issue.

## Acceptance
Generator tests pass, including the flags, the `--repo` override, the `CI_ENABLED` guard (present by default, absent with `--ci on`, valid YAML), a generated sample for each profile that passes format, analyze and tests, and the sync script with its lock check.

## Out of scope
The design system (issue 2), the real minigames, real AdMob IDs.
