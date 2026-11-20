# Work queue (tracker)

This file is a TRACKER: one row per item with where it stands, who acts next and where the detail is. Keep it short: the status board is a table (one row per item), everything else is bullets. Times are AEDT (UTC+11). Read `docs/DECISIONS.md` and `docs/issue-drafts/README.md` first.

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

## Standing rules (never break)
- No release, tag, version bump or store upload.
- No secrets, keystores or real ad IDs.
- Nothing for Play Console, AdMob, prices, Cloudflare or the VPS (owner only).
- Do not touch the three old games' code (their workflows now call the shared ones, like every game).
- No people in any art.
- Content packs beyond Years 0 to 12 maths and English: the owner says when.
- Issues come from `yaseengem` only.

## Status board (updated 6:25 pm AEDT 16 Nov 2026)

| Item | Status | Detail / next |
|---|---|---|
| Web hosting at `/games/` (own container, port 7080) | DONE 2:41 am | `/appgames` untouched (401). |
| Version info (`build-info.json`, `/games/` index) | DONE 3:22 am | `/appgames` has none (owner's rule: not changed). |
| Deploy on pin push (`deploy-games-web`) | DONE, proven by runs 6 to 14 | A Claude run's own pin push DOES start it (runs 12, 13, 14 at 9:05 to 9:46 am); all five games live at the pinned app commits (checked 4:03 pm). |
| Repo names follow the audience (Scout = `game-craft-preteen`, Ranger = `game-craft-lowteen`) | DONE 3:15 am | Internal ids `craft_lowteen` (Scout) and `craft_preteen` (Ranger) stay (historical). |
| `games-web` public | DONE | No secrets or private code in it. |
| W1a landing page, filters, deep links, how-to-play dialog | DONE, live 3:34 am | Start-up fix (parallel pack prefetch) live 3:42 am. |
| W1b Presto, Ranger, Champion on the web | DONE, live 3:53 am | Catalog then had 164 cards. |
| W1c Craft minigames as catalog cards | DONE, live 9:03 am | 775 cards (12 Fun, 152 Quick quiz, 611 minigame cards). |
| #171 M6 Achievements (Ember, Presto) | DONE 9:05 am | Ember 8520637, Presto 535276c, pins moved; 969 and 669 tests; summary posted on the issue. |
| R1b Rules dialog in the Mind hubs (#172) | DONE (Ember 1e886a9, Presto be98899) | Texts changed from the web copy are listed in the issue comment and QUEUE-LOG. |
| R1a Rules dialog in the Craft apps and template (#173) | DONE 9:50 am (template 44424ff, Scout f228373, Ranger ea89ae4, Champion fe5774f) | Template 843, Scout 592, Ranger 615, Champion 623 tests green; Mind engine synced. Changed texts are in the issue comment; the web copy needs the same words. |
| #174 M7 Play Games leaderboards (Ember, Presto) | DONE 4:14 pm | Pushed to both Mind hubs and `public/`; off in the repo (`play_games.enabled: false`). Next: owner creates the Play Console leaderboards and puts the ids in `play_games.leaderboards`. |
| X2 AdSense | Code in the apps (#165), switched OFF | Owner steps later (account, ids, privacy pages). |
| #148 curriculum coverage | PAUSED since 12 Nov at Maths Year 3 | Resume with `@claude Please continue` on #148 when the owner says. |
| Issue 10 purchase check on the VPS | WAITING on the owner | Needs the VPS and Cloudflare set up first. |
| Screenshots | LAST | Once, at the very end, when the owner says (method in `docs/SCREENSHOTS.md`). |
| Web how-to-play text synced with the apps | DONE, live (checked 4:15 pm) | Run 15 (started 4:07 pm) rebuilt all five games at games-web a7412f1; the live Blockfall dialog shows the apps' new wording; 775 cards; `/appgames` 401. `games-web/scripts/sync_rules.py` generates the text from the apps' catalogues (25 games): re-run it after an app's text changes. |
| Preview copies `/appgames/web-ember/` and `/web-scout/` removed | DONE 6:15 pm | Owner said remove (6:05 pm). Full `/appgames` rebuild, `deploy-to-vps-as-web` run 13: the image now holds only the eight apps at their `main`. `/games/` untouched. Not checked in a browser (`/appgames` is behind the login). |
| W2 Landing page redesign (games-web) | SPEC WRITTEN 1:15 am AEDT 21 Nov, not posted | Modern, audience-neutral page: hero with Play / Maths / English / Surprise me, recents on the device, Play shelf, year chips, search. Full text in `docs/FEATURE-SPECS.md` (W2). Next: owner says go, then the orchestrator builds it in `games-web/site/index.html` and moves the pin. |
| W2.1 Landing page revision (Kahoot-style) | GO 2:25 am AEDT 21 Nov, with the tech-lead agent | Owner released it from the vision hold. Learn first in the top bar, hand-drawn SVG art (no AI), Figma art later in one batch. Working tree only, nothing committed. Text in `docs/FEATURE-SPECS.md` (W2.1). |
| Education vision and format contract | WRITTEN and pushed (c3f3866), 21 Nov | `docs/VISION-education.md`: modules joined by question format, game-by-format matrix from the code, gaps, order of work. Next: owner confirms Scout first, then specs for skill map, Study on all formats, shooter, snake-for-series. W2/W2.1, X2 and new skill-less Mind games wait. Format limits in `docs/FORMAT-CONSTRAINTS.md`. |
| Education trail T1 to T7 | T1 POSTED as #175 at 2:08 am AEDT 21 Nov (run in progress); T2 to T7 spec written, not posted | Full text in `docs/FEATURE-SPECS.md` (T1 format limits, T2 skills, T3 mastery, T4 game limits and Study on all formats, T5 trail, T6 shooter and snake, T7 Mind skills). Docs pushed as c3f3866. Next: owner decides the daily release vs the trail (T5), the name, the C5 topic order; T2 needs the C5 topic order review. |
| Pin and push helper scripts | DONE by the owner 3:59 pm (0fa6740) | `scripts/pull-all.sh`, `push-all.sh`, `bump.sh`, `push.sh`: pull everything, push every submodule main, move and push the pins (never forced; a pin must be on the submodule's origin/main). |
| Done earlier | C1 to C5, C7, C8, M1 to M5, X2a, X2b, icons (#167), workflow streamlining, privacy pages | Detail in `docs/QUEUE-LOG.md`, older in `docs/queue-log-archive.md`. |

## Active (running now)
- #175 T1 exact question formats: run started 2:08 am AEDT 21 Nov (game-factory, five apps, content repo, pins).

## Next (post in this order, as dependencies finish)
- Nothing is left to post without the owner. Held for the owner: #148 curriculum (paused), the C5 topic order (review), X2 AdSense (accounts). Not picked: C6 read-aloud, C9 content editor, X3 accessibility pass, X4 localisation (see `docs/FEATURE-SPECS.md`).
- Issue 10 (purchase check on the VPS): only after the owner has set up the VPS and Cloudflare.
- Screenshots: once, at the very end (see `docs/SCREENSHOTS.md`).

## Waiting on the owner
- Decide whether `/appgames` should get version info too.
- Decide which is right for Scout: the docs (Door runner and Balloon pop coin-locked) or the code (free; only Tug of war is locked).
- Review the Scout, Ranger and Champion topic order (C5) and say what moves.
- Review the how-to-play text (`games-web/overlay/common/lib/web_product/web_rules_data.dart` is generated from the apps), the content packs and each app's `docs/SPEC.md`.
- Listen to the M4 sound packs.
- Decide what replaces coins, and whether coins should survive a reinstall at all.
- Turn off the `noindex` header on the games server when the site is public.
- Accounts and setup: AdSense account, ids and privacy pages; Play Console, AdMob and prices; Play Games setup for the Mind hubs (before M7 goes live; steps in `game-factory/docs/PLAY_GAMES_SETUP.md`); name and trademark checks; Cloudflare and VPS; copy the game-content workflows and add secrets; rotate the token from #154; set `CI_ENABLED` when CI should run.
- Say when to resume #148 (owner, 6:05 pm 16 Nov: stays paused).
- Block Puzzle: what replaces the paid coin packs (in discussion 6:20 pm 16 Nov: permanent, Play-restored items against keeping coins with a backup).
