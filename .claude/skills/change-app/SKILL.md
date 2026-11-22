---
name: change-app
description: Changes an existing game or the web (fix, tweak, feature). App game repos are PAUSED (owner, 2026-11-22); web changes go ahead. Use when the user says /change-app or asks to change, fix or add something.
---

# /change-app

No role agents any more (owner, 2026-11-22). The session does the change itself.

1. Find the target: `games-web`, `game-factory` (shared games, scripts), `game-content`, or an `apps/*` repo.
   App repos are paused: do not change them. Tell the owner and queue it in `docs/QUEUE.md` (one line, detail in `docs/queue/<item>.md`).
2. Make the change in the submodule checkout and update its `docs/SPEC.md` (behaviour, exact values) in the same commit.
3. Run checks where the tools exist. A failing check is logged in `docs/QUEUE-LOG.md`; it does not stop the push.
4. Push the submodule `main`, move the pin here, push `main`. The pin push deploys the web (`deploy-games-web`).
5. Update the item file in `docs/queue/` and its line in `docs/QUEUE.md` with the AEDT time. Report briefly: what changed, commit link, what is next.

Web AdSense ids and slots may be used and edited freely; ask the owner only before creating new ad units or deleting ads (owner, 2026-11-22). Never: secrets, AdMob ids, Play uploads, tags, version bumps, production promotion, force-push.
Issue-driven work follows "How a run handles an issue" in `docs/INBOX.md`.
