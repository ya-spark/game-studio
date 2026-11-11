# [change] shared game modules: the mechanism, and Block Puzzle as the first module (issue 08a)

**Repos:** game-block-puzzle (and a decision recorded in game-studio / game-factory). **Depends on:** the Mind hub apps (06, 07) existing. Owner decision (2026-11-11): each existing game becomes one shared module used by its standalone app and the Mind hubs. See `docs/DECISIONS.md` ("Existing games as shared modules").

## Goal
Choose how a game module is shared between repos, then convert **Block Puzzle only**, proving the standalone app is unchanged.

## Step 1: design (write `docs/MODULES.md` in game-factory, short)
Compare and choose one: (a) the game's code in a Dart package inside its own repo, used by the hub through a pinned git dependency (needs read access for builds of private repos: say exactly what token or deploy key and where it is stored; never commit secrets); (b) a package folder in game-factory used through a pinned git dependency; (c) the engine sync approach (vendored copy kept identical by a script and a lock). Give the trade-offs for fixes reaching both apps, builds in GitHub Actions, the release workflow, and offline development. Recommend one. The module API: what the hub supplies (coin balance, Remove Ads, ad pacing, audio, theme) and what the game exposes (a widget and a small interface).

## Step 2: convert Block Puzzle
Extract rules and screens into the module without changing behaviour; the standalone app depends on the module; keep `docs/SPEC.md` accurate. **Prove no behaviour change:** all existing tests pass unchanged; add a test that runs the same recorded bot games through the module and the old code path and gets identical results; screenshots or widget goldens of the main screens before and after are identical.

## Safety rules
- No release, tag, version bump or store upload. The owner approves any release separately.
- Never touch secrets, keystores or real ad IDs.
- If a check cannot prove sameness, stop and comment instead of pushing.

## Run discipline
Small steps; commit and push each passing step to `main` of the repo and move the pin; final summary comment with about 15 turns left; no `.github/workflows` pushes (give YAML in the comment).

## Out of scope
Blockfall and Wingy (08b), the hub inclusion (08c).
