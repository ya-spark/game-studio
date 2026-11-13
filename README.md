# game-studio

Master repo and single entry point of the game studio. It pins exact commits of the factory and of
every game as git submodules, so one clone gives the whole studio, and it holds the orchestration:
the `/new-app` and `/change-app` skills and stage agents (`.claude/`), the issue inbox
(`.github/ISSUE_TEMPLATE/`, `docs/INBOX.md`), the owner's decisions (`docs/DECISIONS.md`) and the
`@claude` workflow (`.github/workflows/run-claude-from-issues.yml`). Application code lives in the submodules.

```
game-studio
├── game-factory/            # submodule: scripts, registry, game template
└── apps/
    └── game-block-puzzle/  # submodule: one repo per game
```

## Clone

```bash
git clone --recurse-submodules https://github.com/ya-spark/game-studio.git
# already cloned without submodules:
git submodule update --init --recursive
```

All repos are public; use HTTPS (a token is only needed to push).

## Rules

- All work goes through this repo: write issues here, mention `@claude`, open sessions at this root.
  Never work from inside a submodule on its own (see `docs/INBOX.md`).
- The master **pins** commits; it does not follow `main`. An `@claude` run (or a live session) moves a pin
  forward with a direct commit to `main` once the submodule's `main` has the commit and its CI is green.
- Game CI and releases run in each game's own repo and never depend on this one.
- Inside a submodule, check out `main` before committing (avoids a detached HEAD).
- No secrets live in the files. The only Actions secrets here are `CLAUDE_CODE_OAUTH_TOKEN` and `CROSS_REPO_TOKEN`; signing keys and Play credentials exist only in each game repo's secrets.
- Adding a game: the `/new-app` flow (from this root) creates it; then add it here with
  `git submodule add https://github.com/ya-spark/game-<id>.git apps/game-<id>`.
