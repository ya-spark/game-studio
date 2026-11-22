# How to use the queue (full text, verbatim from the old queue)

## How to use this file
- Update it in the same commit as any change in the status of a spec or item: posted, started, a step done, run failed or stopped, blocked, paused, resumed, finished, or an owner answer. Put the time in AEDT.
- Detail does not go here. A dated finding, a run result or a long note goes at the top of the log in `docs/QUEUE-LOG.md`; the full text of an item (spec, decisions, scope) is in `docs/FEATURE-SPECS.md`; a decision is also written in `docs/DECISIONS.md`.
- Starting a session or continuing the work:
  1. List `game-studio` workflow runs (`run-claude-from-issues`). Count the active ones (in progress or queued); keep at most 3 at once (usage limits).
  2. Read the latest comment of every issue under "Active". A run that finished with a summary is done; one that failed with no comment stopped early (usage limit or turns): comment `@claude Please continue` on that issue.
  3. Move a pin only if a run did not (`git submodule status` must match each repo's `origin/main`); `scripts/pull-all.sh`, `scripts/push-all.sh`, `scripts/bump.sh` and `scripts/push.sh` do the pulling, pushing and pin bumping (all read-only with `-n` where they take it).
  4. Post the next item from "Next" when its dependency is done, then record it here.
  5. Mark a finished item DONE on the status board with the issue number and time (the board keeps the one-line history; detail goes to `docs/QUEUE-LOG.md`), then commit and push this file to `main`.
- Where the rest lives:
  - `docs/FEATURE-SPECS.md`: full text of the live backlog items (X2, W1, W2, R1, and others); the finished C1 to C8 and M1 to M7 are in `docs/specs-archive-C-M.md`.
  - `docs/QUEUE-LOG.md`: the dated log (newest first), the games-web first proofs, the owner decisions of 2026-11-15, and the history of earlier work.
  - `docs/DESIGN-web-catalog.md`: the web catalog and rules dialog design.
  - `docs/SCREENSHOTS.md`: how to take store screenshots without an emulator (last step).
