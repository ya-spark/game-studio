# Skills

- [`new-app`](new-app/SKILL.md): the `/new-app` orchestrator. Takes a game prompt, runs the Q&A,
  then drives the stage subagents in `.claude/agents/new-app/` using `game-factory/scripts/pipeline.py` for state.
- [`change-app`](change-app/SKILL.md): the `/change-app` orchestrator for changes to an existing game or the factory.
