# game-studio

Master repo of the game studio. It holds no code of its own: it pins exact commits of the
factory and of every game as git submodules, so one clone gives the whole studio.

```
game-studio
├── app-factory/            # submodule: scripts, agents, skills, game template
└── apps/
    └── game-block-puzzle/  # submodule: one repo per game
```

## Clone

```bash
git clone --recurse-submodules https://github.com/ya-spark/game-studio.git
# already cloned without submodules:
git submodule update --init --recursive
```

All repos are private; use HTTPS with a token that can read them.

## Rules

- The master **pins** commits; it does not follow `main`. The workflow
  `.github/workflows/bump-submodules.yml` opens a PR that moves the pins forward; merge it when
  the games' CI is green.
- Game CI and releases run in each game's own repo and never depend on this one.
- Inside a submodule, check out a branch before committing (avoids a detached HEAD).
- No secrets live here. Signing keys and Play credentials exist only in each game repo's secrets.
- Adding a game: the `/new-app` flow in `app-factory` creates it; then add it here with
  `git submodule add https://github.com/ya-spark/game-<id>.git apps/game-<id>`.
