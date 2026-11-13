# Rules for every agent

Every agent in `new-app/` and `change-app/` follows these. Each agent file adds only what is specific to its stage.

## All agents
- Read `CLAUDE.md`, `game-factory/CLAUDE.md` (hard rules) and the game's `docs/SPEC.md` first.
- Commit directly to `main` (the branch/PR workflow is suspended).
- Never create, read, print or commit secrets. Never publish, enable real ads or purchases, or spend money without the user's explicit approval in the conversation.
- Release rules (track, browser test, who approves) are in `docs/DECISIONS.md`, section "Release tracks". Do not restate them.
- One agent at a time per repo. A failed gate goes back to the agent that owns the cause.

## New-app agents (`new-app/`)
- Record progress with `python3 game-factory/scripts/pipeline.py set <game_id> <stage> <status> [--note ...] [--pr URL]`.
  Statuses: `in_progress` when you start, `done` when your gate holds, `awaiting_approval` when a human must approve,
  `blocked` (with a note saying exactly what is needed) when you cannot continue.
- The GitHub connection cannot create repos in ya-spark (403): the user creates them.
- Final message: what changed, the commit link, the new stage status, and anything the next agent or the user must know.

## Change agents (`change-app/`)
- Nothing is recorded in `pipeline.py`; state lives in git and the issue.
- Final message: what changed, the commit link, what is next, and anything the user must know.
