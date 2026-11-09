# [change] convert Block Puzzle, Blockfall and Wingy into modules for the hubs

**Repos:** game-block-puzzle, game-block-fall, game-wingy, game-mind-1, game-mind-9. Later step, after 01 to 07.

## Goal
Each existing game becomes a module that its standalone app and the Mind hubs both use, so a fix reaches both. The three standalone apps stay published and unchanged for players.

## Scope
Extract rules and screens into modules; keep each `docs/SPEC.md` accurate; the hub shares coins, Remove Ads and ads pacing; the standalone apps keep their own purchases.

## Acceptance
Each repo's checks pass and the standalone apps behave as before. Pins in game-studio move to the new `main` commits.
