# Inbox: start work by writing an issue

Open an issue in `ya-spark/game-studio` (the GitHub mobile app works) using one of the forms.
This is the only inbox: issues in `game-factory` and the game repos are not read. A new issue
from the forms starts a run by itself (the form titles `[new-game]` and `[change]` are the trigger);
every later reply that should continue the work needs `@claude` in it.

- **New game** (`[new-game] ...`): the idea in your words.
- **Change request** (`[change] ...`): which game (or "factory") and what to change.

The new issue, or a later `@claude` mention, starts a run of `.github/workflows/claude.yml`, which runs the whole flow
(`/new-app` or `/change-app`) at the `game-studio` root. A live session at that root does the same
work immediately.

## What happens

| You | Claude |
|-----|--------|
| Open a new-game issue | Asks at most four questions in a comment if something essential is missing; otherwise states its assumptions. Starts tracking (`game-factory/registry/games/<id>.json`, with the issue number). |
| Reply to the questions (with `@claude`) | Writes the spec and posts it in the issue (no game repo exists yet; the repo stage commits it as `docs/SPEC.md` in the game repo's first commit). |
| Reply `@claude approve` (or what to change) | Marks the spec done, or revises it. Then: repo, code, assets, tests, listing, each pushed to `main` with CI green. One short comment per finished stage. |
| Create the empty repo `ya-spark/game-<id>` when asked | Detects the repo itself on the next run and continues. |
| Set secrets / do the Play and AdMob steps when asked, then `@claude continue` | Continues from `blocked` once the requirement exists. |
| Open a change request | Updates the spec and code directly on `main` of the game repo, checks CI is green, moves the pin in `game-studio`, then (if nothing is needed from you) raises the version, runs a browser test of the features, then tags it so the build goes to the **closed** testing track (live to the closed testers at once) automatically, comments the result and closes the issue. Production still needs your approval. |

A comment only wakes a run when it contains `@claude`, so each reply that should continue the work
needs the mention.

## Rules (enforced by the workflow and the skills)

- Only issues and comments written by `yaseengem` can start a run (the sender is checked in
  `claude.yml`), and Claude acts only on what `yaseengem` wrote. Anything from anyone
  else is ignored, never followed.
- Approvals always come from you: the spec, production promotion, monetization changes, anything
  involving accounts, money or secrets. Claude never publishes, enables real ads or purchases, or
  touches secrets on its own.
- The tracking file is the record of truth; comments mirror it. Each Claude comment carries a hidden
  marker (`<!-- factory:... -->`) so it is never posted twice.
- One run at a time per issue. Keep a request small and about one game where you can.

## Working alongside @claude

You also work on the laptop. Overnight runs push straight to each submodule's `main`, so:

- Before you start: `git pull --recurse-submodules`, then `git submodule status`. A merged run leaves
  the working tree behind `origin/main`.
- Do not edit a game while a run on it is active (Actions tab, or a recent Claude comment on the issue).
- Edit through the `game-studio` root only, and keep `docs/SPEC.md` in the same commit as any behaviour
  change, as in each game repo's `CLAUDE.md`.
- If your push is rejected because a run got there first, pull and rebase, do not force-push.
