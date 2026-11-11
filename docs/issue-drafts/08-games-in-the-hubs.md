# [change] bring Block Puzzle, Blockfall and Wingy into the Mind hubs as synced copies (issue 08)

**Repos:** game-mind-1 (Mind Ember), game-mind-9 (Mind Presto), game-factory (the sync script). **Depends on:** the Mind hub apps (issues 06 and 07). Owner decision (2026-11-11): synced copies, not shared modules. See `docs/DECISIONS.md` ("Existing games in the hubs as synced copies").

## Goal
Mind Ember includes Block Puzzle and Blockfall; Mind Presto includes Wingy. Each appears as a tile in the hub (stars, best score, coin price when locked) and shares the hub's single coin balance, one Remove Ads purchase and the ad pacing. The standalone apps are **not changed**.

## Scope
- **Sync script** `scripts/sync_game.py <game-repo> <hub-repo> <game>` in game-factory (modelled on `sync_engine.py`): copies the game's rules, screens and assets from the standalone repo into the hub under `lib/games/<game>/`, rewrites the package imports, writes a lock file with the source commit and a hash of the copy, and `--check` reports hubs that are behind or edited locally. The hub's CI (when on) fails if a copy was edited without a sync.
- **Adapter:** the copy talks to the hub through a small interface (coins, Remove Ads, ad pacing, audio, theme); the hub supplies it. Standalone-only things (its own shop, its own coin packs, its own ad calls) are replaced in the copy by the adapter. Keep each game's behaviour (rules, feel, drag offsets) exactly as in its `docs/SPEC.md`.
- **Hub wiring:** register each game in the hub's registry as a tile with free or coin access; the hub's Games tab and Continue card use them (from 2B2).
- **Docs:** `docs/ENGINE.md` or a new `docs/GAME_SYNC.md` (how a fix in a standalone app reaches the hub through one sync issue), and the hub's `docs/SPEC.md`.

## Safety rules
- Do not change the standalone repos. Read them only.
- No release, tag, version bump or store upload. Never touch secrets, keystores or real ad IDs.
- Run the hub's checks; if a game's copy cannot be proven to behave as its source (its own rules tests copied and passing in the hub), stop and comment.

## Run discipline
Small steps (script and tests, Block Puzzle in Ember, Blockfall in Ember, Wingy in Presto, docs); commit and push each passing step and move the pin; final summary comment with about 15 turns left; no `.github/workflows` pushes.

## Out of scope
Changing the standalone apps, new games for the hubs (later), real ads and store setup.
