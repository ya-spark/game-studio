# Agents

Shared rules for every agent: [RULES.md](RULES.md).

Agents are split into two folders: `new-app/` (building a new game) and `change-app/` (changing an existing game), named after the skill that runs them.

## new-app/

One subagent per pipeline stage, started in order by the `/new-app` skill
(`.claude/skills/new-app/SKILL.md`) in a session or an `@claude` run at the `game-studio` root. Per-game progress is
tracked in `game-factory/registry/games/<id>.json` with `game-factory/scripts/pipeline.py`.

| Stage | Agent | Gate |
|-------|-------|------|
| 1 spec | [spec-agent](new-app/spec-agent.md) | user approves SPEC.md |
| 2 repo | [repo-agent](new-app/repo-agent.md) | first commit on `main`, CI green (user creates the empty repo) |
| 3 coder | [coder-agent](new-app/coder-agent.md) | features on `main`, CI green |
| 4 asset | [asset-agent](new-app/asset-agent.md) | LICENSES.md complete |
| 5 test | [test-agent](new-app/test-agent.md) | tests green |
| 6 build | [build-agent](new-app/build-agent.md) | signed .aab (needs secrets) |
| 7 listing | [listing-agent](new-app/listing-agent.md) | drafts consistent with code |
| 8 publish | [publish-agent](new-app/publish-agent.md) | user approves the release |
| 9 monitor | [monitor-agent](new-app/monitor-agent.md) | ongoing |

The agent files are written but have not been run end to end on a new game yet.

## change-app/

Started in order by the `/change-app` skill (`.claude/skills/change-app/SKILL.md`). Not tracked in
`game-factory/scripts/pipeline.py`; state lives in git (and the issue, if the request came from one).

| Stage | Agent | Gate |
|-------|-------|------|
| 1 change (plan, then code) | [change-agent](change-app/change-agent.md) | brief written, approvals obtained, tests green on main |
| 2 release | [change-release-agent](change-app/change-release-agent.md) | closed-testing build uploaded, or blocker reported |
