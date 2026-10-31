# game-studio (master repo)

This repo only pins submodules. Do not put code here. See `README.md`.

- **Never change `main` directly, in any repo.** For every change: create a branch, make the change, open a PR, then merge the PR into `main` (Claude may merge its own PRs when the checks are green).
- Never commit secrets. There are no Actions secrets or workflows here; pins are moved by Claude in PRs.
- Real work happens in `game-factory/` (the `/new-app` skill and stage agents) and in each game repo.
- Always check out a branch inside a submodule before committing there.

## Submodules and pins

`game-studio` is the master repo. The four submodules are `game-factory/` and `apps/game-block-fall`, `apps/game-block-puzzle`, `apps/game-wingy`.

- Whenever a PR merges into `main` of any submodule repo, the master pin must be updated to that new `main` commit. Do it in the same session, not later.
- To move a pin: branch in this repo, `git submodule update --remote <path>` (or check out the submodule's `main` tip), commit only the pointer change, open a PR, merge it when checks are green.
- Pins must always point to a commit that is on the submodule's `main`, never to an unmerged branch commit.
- Do not leave pins stale: before finishing any task that touched a submodule, confirm `git submodule status` matches each submodule's `origin/main`.
- Submodule changes themselves follow the same rule: branch inside the submodule, PR, merge to its `main`, then move the pin here.
