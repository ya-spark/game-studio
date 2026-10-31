# game-studio (master repo)

This repo only pins submodules. Do not put code here. See `README.md`.

- Branch/PR workflow is suspended for now: changes may be committed and pushed directly to `main`, in any repo.
- Never commit secrets. There are no Actions secrets or workflows here.
- Real work happens in `game-factory/` (the `/new-app` skill and stage agents) and in each game repo.

## Submodules and pins

`game-studio` is the master repo. The four submodules are `game-factory/` and `apps/game-block-fall`, `apps/game-block-puzzle`, `apps/game-wingy`.

- Whenever `main` of any submodule repo changes, the master pin must be updated to that new `main` commit. Do it in the same session, not later.
- To move a pin: `git submodule update --remote <path>` (or check out the submodule's `main` tip) and commit only the pointer change.
- Pins must always point to a commit that is on the submodule's `main`, never to a commit that is not on `main`.
- Do not leave pins stale: before finishing any task that touched a submodule, confirm `git submodule status` matches each submodule's `origin/main`.
- Submodule changes go to its `main`, then move the pin here.
