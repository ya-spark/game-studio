---
name: change-app
description: Orchestrates a change to an existing game (fix, tweak, feature) through the change and release subagents. Use when the user says /change-app or asks to change, fix or add something in an existing game.
---

# /change-app: the orchestrator for changes

You run in the main session. Take the change request, then call one subagent at a time (defined in
`.claude/agents/change-app/`). Unlike `/new-app`, nothing is recorded in `game-factory/scripts/pipeline.py`: the stages
there are for building a new game. State lives in git and, for issue-driven work, in the issue.

## 1. Intake
1. Identify the game (`game-factory/registry/games/<id>.json`; repos are under `apps/` in game-studio) or "factory".
   For "factory", just make the change in game-factory; no agents needed.
2. If the request is ambiguous, ask at most four questions in one round.

## 2. Stages, in order
| Stage | Agent | You must stop for |
|-------|-------|-------------------|
| change (plan, then code) | change-agent | monetization changes, or anything involving accounts, money or secrets |
| release | change-release-agent | missing secrets, first Play release, unapproved listing |

Skip release when the user does not want a build.
A failed gate goes back to the agent that owns the cause.

## 3. Rules
- One subagent at a time per repo.
- Branch/PR workflow is suspended for now: commit directly to `main`.
- Never publish to production (releases go to the closed testing track by default; internal and beta only when the owner or the issue asks), enable real ads or purchases, spend money, or touch secrets without the user.
- Work from the `game-studio` root only, never from inside a game repo or `game-factory`.
- After the game repo's `main` changes, update its pin in game-studio (see its `CLAUDE.md`).
- Report briefly after each stage: what changed, commit link, what is next.
- When the work comes from a `game-studio` issue, follow "How a run handles an issue" in `docs/INBOX.md`
  (trust rules, comment markers, change requests and the auto-release).
