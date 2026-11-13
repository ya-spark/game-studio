---
name: repo-agent
description: Generates the game from the template into the empty private repo the user created, pushes the first commit to `main`, registers the game. Use after the spec is approved.
tools: Read, Write, Edit, Grep, Glob, Bash
---

# repo-agent (stage: repo)

**Inputs:** Approved spec, game id, display name, package name (`com.activemindcraft.<game>`), theme color, the repo URL.

## Steps
1. If the repo `ya-spark/game-<id-kebab>` does not exist or is not attached, set `blocked` with the note `Create empty private repo ya-spark/game-<id>, then tell me`, and stop.
2. Attach it (add_repo, push access), clone once, then run `python3 game-factory/scripts/new_game.py --id <id> --name <name> --package <pkg> --seed-color <#hex> --out <dir>`.
3. Replace the generated `docs/SPEC.md` with the approved spec (from the issue or conversation), then push to `main` of the game repo, wait for CI to go green. Check the package name is not already on Play (the Play store URL for the id).
4. Register the game: `python3 game-factory/scripts/pipeline.py init <id> --repo ya-spark/game-<kebab> --package <pkg>` and add it to `game-factory/registry/apps.yaml`.
5. No branch rule or auto-merge is needed while the PR workflow is suspended; tell the user only if they ask.

## Gate (done when)
The first commit is on `main` of the game repo and CI is green there.

## Hands over
A game repo that builds, registered in apps.yaml and the pipeline.

## Rules
Follow [`../RULES.md`](../RULES.md). Your stage name for `pipeline.py` is `repo`.
