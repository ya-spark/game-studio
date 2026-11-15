# Work queue (tracker)

This file is a TRACKER: one row per item with where it stands, who acts next and where the detail is. Keep it short: the status board is a table (one row per item), everything else is bullets. Times are AEDT (UTC+11). Read `docs/DECISIONS.md` and `docs/issue-drafts/README.md` first.

## How to use this file
- Update it in the same commit as any change in the status of a spec or item: posted, started, a step done, run failed or stopped, blocked, paused, resumed, finished, or an owner answer. Put the time in AEDT.
- Detail does not go here. A dated finding, a run result or a long note goes at the top of the log in `docs/QUEUE-LOG.md`; the full text of an item (spec, decisions, scope) is in `docs/FEATURE-SPECS.md`; a decision is also written in `docs/DECISIONS.md`.
- Starting a session or continuing the work:
  1. List `game-studio` workflow runs (`run-claude-from-issues`). Count the active ones (in progress or queued); keep at most 3 at once (usage limits).
  2. Read the latest comment of every issue under "Active". A run that finished with a summary is done; one that failed with no comment stopped early (usage limit or turns): comment `@claude Please continue` on that issue.
  3. Move a pin only if a run did not (`git submodule status` must match each repo's `origin/main`).
  4. Post the next item from "Next" when its dependency is done, then record it here.
  5. Mark a finished item DONE on the status board with the issue number and time (the board keeps the one-line history; detail goes to `docs/QUEUE-LOG.md`), then commit and push this file to `main`.
- Where the rest lives:
  - `docs/FEATURE-SPECS.md`: full text of the backlog items (C1 to C8, M1 to M7, X2, W1, R1, and others).
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

## Status board (updated 9:10 am AEDT 16 Nov 2026)

| Item | Status | Detail / next |
|---|---|---|
| Web hosting at `/games/` (own container, port 7080) | DONE 2:41 am | `/appgames` untouched (401). |
| Version info (`build-info.json`, `/games/` index) | DONE 3:22 am | `/appgames` has none (owner's rule: not changed). |
| Deploy on pin push (`deploy-games-web`) | DONE, proven by run 6 | Unknown yet: whether a Claude run's own pin push starts it. |
| Repo names follow the audience (Scout = `game-craft-preteen`, Ranger = `game-craft-lowteen`) | DONE 3:15 am | Internal ids `craft_lowteen` (Scout) and `craft_preteen` (Ranger) stay (historical). |
| `games-web` public | DONE | No secrets or private code in it. |
| W1a landing page, filters, deep links, how-to-play dialog | DONE, live 3:34 am | Start-up fix (parallel pack prefetch) live 3:42 am. |
| W1b Presto, Ranger, Champion on the web | DONE, live 3:53 am | Catalog then had 164 cards. |
| W1c Craft minigames as catalog cards | DONE, live 9:03 am | 775 cards (12 Fun, 152 Quick quiz, 611 minigame cards). |
| #171 M6 Achievements (Ember, Presto) | DONE 9:05 am | Ember 8520637, Presto 535276c, pins moved; 969 and 669 tests; summary posted on the issue. |
| R1b Rules dialog in the Mind hubs (#172) | DONE (Ember 1e886a9, Presto be98899) | Texts changed from the web copy are listed in the issue comment and QUEUE-LOG. |
| R1a Rules dialog in the Craft apps and template (#173) | POSTED 9:10 am, running | Runs in parallel with R1b (a different code base). |
| M7 Play Games leaderboards | NEXT, after R1b (same hubs and save) | Cannot be tested on a device until the owner does the Play Console steps. |
| X2 AdSense | Code in the apps (#165), switched OFF | Owner steps later (account, ids, privacy pages). |
| #148 curriculum coverage | PAUSED since 12 Nov at Maths Year 3 | Resume with `@claude Please continue` on #148 when the owner says. |
| Issue 10 purchase check on the VPS | WAITING on the owner | Needs the VPS and Cloudflare set up first. |
| Screenshots | LAST | Once, at the very end, when the owner says (method in `docs/SCREENSHOTS.md`). |
| Done earlier | C1 to C5, C7, C8, M1 to M5, X2a, X2b, icons (#167), workflow streamlining, privacy pages | Detail in `docs/QUEUE-LOG.md`. |

## Active (running now)
- #172 R1b done; #173 R1a (Craft apps, template): posted 9:10 am; read their checklist and summary comments, restart a stopped run with `@claude Please continue`.

## Next (post in this order, as dependencies finish)
- M7 Play Games leaderboards (Ember and Presto): after #172 is done.
- Issue 10 (purchase check on the VPS): only after the owner has set up the VPS and Cloudflare.
- Screenshots: once, at the very end (see `docs/SCREENSHOTS.md`).

## Waiting on the owner
- Remove the two preview copies `/appgames/web-ember/` and `/appgames/web-scout/` (on the owner's word).
- Decide whether `/appgames` should get version info too.
- Decide which is right for Scout: the docs (Door runner and Balloon pop coin-locked) or the code (free; only Tug of war is locked).
- Review the Scout, Ranger and Champion topic order (C5) and say what moves.
- Review the how-to-play text (`games-web/overlay/common/lib/web_product/web_rules.dart`), the content packs and each app's `docs/SPEC.md`.
- Listen to the M4 sound packs.
- Decide what replaces coins, and whether coins should survive a reinstall at all.
- Turn off the `noindex` header on the games server when the site is public.
- Accounts and setup: AdSense account, ids and privacy pages; Play Console, AdMob and prices; Play Games setup for the Mind hubs (before M7 goes live; steps in `game-factory/docs/PLAY_GAMES_SETUP.md`); name and trademark checks; Cloudflare and VPS; copy the game-content workflows and add secrets; rotate the token from #154; set `CI_ENABLED` when CI should run.
- Say when to resume #148.
