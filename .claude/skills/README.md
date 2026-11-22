# Skills

The role agents were removed (owner, 2026-11-22). One session does the work.

- [`run-queue`](run-queue/SKILL.md): the loop. Works through `docs/QUEUE.md` (index; item detail in `docs/queue/`), pushes, deploys to the VPS, wakes itself hourly.
- [`change-app`](change-app/SKILL.md): a change to an existing game or the web (app repos paused).
- [`new-app`](new-app/SKILL.md): a new game (app games paused; web games go through `games-web`).
