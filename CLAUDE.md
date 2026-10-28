# game-studio (master repo)

This repo only pins submodules. Do not put code here. See `README.md`.

- Never push to `main`; branch + PR. Claude may merge its own PRs when the checks are green.
- Never commit secrets. There are no Actions secrets or workflows here; pins are moved by Claude in PRs.
- Real work happens in `app-factory/` (the `/new-app` skill and stage agents) and in each game repo.
- Always check out a branch inside a submodule before committing there.
