---
name: new-app
description: Starts a new game. PAUSED for app games (owner, 2026-11-22); web games are added through games-web. Use when the user says /new-app or asks for a new game.
---

# /new-app (paused)

The stage subagents are gone (owner, 2026-11-22). The session itself does the work, one stage at a time.

- App games are paused until the web is complete. If asked for a new app game, say so and ask if the owner wants
  it queued in `docs/QUEUE.md` (one line, detail in `docs/queue/<item>.md`) instead of built now.
- A new web game: add the game package in `game-factory/games/<game>/` (rules, ui, assets, tests, `docs/SPEC.md`),
  list it in `games-web/games.yaml`, push, move pins, and let `deploy-games-web` publish it.
- Generators and state helpers stay in `game-factory/scripts/` (`new_game.py`, `pipeline.py`, see `scripts/README.md`).
- Rules: `CLAUDE.md` (pins, no secrets) and `game-factory/CLAUDE.md`. Work from the `game-studio` root.
