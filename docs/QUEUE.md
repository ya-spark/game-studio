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
| W2 Landing page redesign (games-web) | BUILT, pushed 2:50 AM AEDT 21 Nov (games-web 746e946) | Superseded by W2.1 (same page). Not checked in a real browser (no browser in the session). |
| W2.1 Landing page revision (Kahoot-style) + Active Mind Craft logos | BUILT, pushed 2:50 AM AEDT 21 Nov (games-web 746e946), deploy started by the pin push | Sticky top bar (Learn first), shelves, 14 hand-drawn tiles, three-circles logos in the top bar and footer. NOT browser-tested: owner to look at `/games/`, then run the testing agent if wanted. Trademark search for the logo not done. Figma art later, in one batch. |
| Education vision and format contract | WRITTEN and pushed (c3f3866), 21 Nov | `docs/VISION-education.md`: modules joined by question format, game-by-format matrix from the code, gaps, order of work. Next: owner confirms Scout first, then specs for skill map, Study on all formats, shooter, snake-for-series. W2/W2.1, X2 and new skill-less Mind games wait. Format limits in `docs/FORMAT-CONSTRAINTS.md`. |
| Education trail T1 to T7 | T1 and T2 to T7 PUSHED 10:54 AM AEDT 21 Nov (IDE session) | Pushed: game-factory c622041, Scout f39db0d, Ranger d5e53e1, Champion 7c3c6f8, Ember 9914fd7, Presto 366d9f8, content (`factory.lock` now c622041), pins moved. Built: game-factory template, five apps, `game-content` (`skills.yaml`, `gen_skills.py`, tool `--skills`). All checks green (template 967 tests; Scout 722, Ranger 745, Champion 753, Ember 1,124, Presto 806). Waiting on the owner: push; review of the generated skill list and the C5 topic order; the daily release against the trail (skip-ahead only works within open items until then); the trail's visible name (still `trail`). Not built: the parent lock to Auto, Mind skill thresholds from real scores, web catalog and rules text for the new games. Details in `docs/FEATURE-SPECS.md`. |
| K1 Keyboard play in every game (app and web) | PARTLY DONE and pushed 11:51 AM AEDT: Shooter, Snake built with it (number keys, arrows and WASD, Tab focus, tests); the trail uses standard focusable controls; existing games and the shared choice screen still to do. NEW 11:43 AM AEDT 21 Nov, queued | New games (Shooter, Snake, the trail) get it now; the existing games follow later. Per game: every control reachable by Tab and Enter or Space, plus arrow and letter keys where it fits, a visible focus ring, no mouse-only gesture. |
| M8 Rung opening by purchase or ad, coins with sign-in | SPEC NEEDED (owner decided 2026-11-21) | Replaces the daily release. Web: all open, an ad may show when a rung opens. App: purchase opens any, else a rewarded ad; extra packs by purchase, coins or ad; coins only with Play Games sign-in. Check Families and child-directed rules first. See `docs/decisions/web.md`. |
| W3 Web ads and browser-saved progress | SPEC NEEDED | AdSense H5 Games Ads (closed beta, application, child-directed eligibility unconfirmed); trail progress in browser local storage with privacy text; supersedes X2's no-rewarded and no-save rules. Owner: AdSense account and approval. |
| Skill list review | APPROVED by the owner 1:01 PM AEDT; kept as is. (was: NAMES PUSHED 11:51 AM AEDT 21 Nov, awaiting the owner | All 152 topics have real rung names (Ranger, then Champion, then Scout last), in `docs/SKILLS-REVIEW.md`; the item ranges are unchanged. Reply with renames; a different split is a bigger change.) |
| Trail visible name | MOCK SHOWN 11:51 AM AEDT (owner asked to see Constellation) | Artboards `Your sky` and `Star states` (private claude.ai artifact). Owner to pick: Constellation, themed per app, or Trail everywhere. |
| Study topic sheet, web how-to text, Mind levels | DONE and pushed 11:51 AM AEDT | Map sheet has "Other question types" (Flash review on non-mcq items); `games-web/scripts/sync_rules.py` re-run (27 games); Mind level thresholds kept as proposals (tune later with real scores). |
| W4 Responsive web layout for NEW apps and games | RULE AND HELPERS PUSHED (c3466c6) 12:38 PM AEDT 21 Nov | Owner: not for the current apps, only new ones from here. Template has `lib/ui/layout/responsive.dart` (compact, medium, expanded; `ResponsiveBody`, `TwoPane`, `gridColumns`), tests and `docs/WEB_LAYOUT.md`; `game-factory/CLAUDE.md` carries the rule. Every new screen is checked at 390, 800 and 1440 wide. |
| W5 Browser notifications on the web | SPEC NEEDED (owner said add, 1:01 PM AEDT) | Reminders and review nudges for the web. Limit to settle first: no backend means no push when the site is closed; decide what a client-only version does (in-page reminders, installed web app) or whether it waits for the backend. See `docs/decisions/web.md`. |
| Topic list and order review | BACKLOG, owner deferred 1:04 PM AEDT 21 Nov | Owner: "keep the order, good for now; we will review the topics list and the order later". Today's order is the teaching order in `game-content/topics.yaml` (and it sets the trail: a topic's first rung opens after the first rung of the topic before it). Review: topics per year, their names and their order, then skills follow (`skill_names.yaml` stays unless a topic changes). Replaces the old C5 review item. |
| Trail look: Constellation | DECIDED 1:04 PM AEDT 21 Nov, not built | Owner chose Constellation as in the mock (artifact "Trail as a Constellation"): each topic a small constellation, each rung a star, lit by progress, lines join what is done. Build the visual in the trail screen (star art drawn in code, no people, no AI images; keyboard and screen-reader labels kept). Open: apply it to the three Craft apps that already have the trail, or only to new apps (owner said not to change current apps for the web layout; not answered for this). |
| Pin and push helper scripts | DONE by the owner 3:59 pm (0fa6740) | `scripts/pull-all.sh`, `push-all.sh`, `bump.sh`, `push.sh`: pull everything, push every submodule main, move and push the pins (never forced; a pin must be on the submodule's origin/main). |
| Done earlier | C1 to C5, C7, C8, M1 to M5, X2a, X2b, icons (#167), workflow streamlining, privacy pages | Detail in `docs/QUEUE-LOG.md`, older in `docs/queue-log-archive.md`. |

## Active (running now)
- No issue runs, no deploys. (#175 was cancelled and closed; T1 is done in the IDE session.)

## Next (post in this order, as dependencies finish)
- Nothing is left to post without the owner. Held for the owner: #148 curriculum (paused), the topic list and order review (deferred, backlog), X2 AdSense (accounts). Not picked: C6 read-aloud, C9 content editor, X3 accessibility pass, X4 localisation (see `docs/FEATURE-SPECS.md`).
- Issue 10 (purchase check on the VPS): only after the owner has set up the VPS and Cloudflare.
- Screenshots: once, at the very end (see `docs/SCREENSHOTS.md`).

## Waiting on the owner
- Decide whether `/appgames` should get version info too.
- Decide which is right for Scout: the docs (Door runner and Balloon pop coin-locked) or the code (free; only Tug of war is locked).
- (Deferred by the owner, 1:04 PM AEDT 21 Nov: topic order kept as it is for now; the topic list and order get a full review later, see the backlog row "Topic list and order review".)
- Review the how-to-play text (`games-web/overlay/common/lib/web_product/web_rules_data.dart` is generated from the apps), the content packs and each app's `docs/SPEC.md`.
- Listen to the M4 sound packs.
- Decide what replaces coins, and whether coins should survive a reinstall at all.
- Turn off the `noindex` header on the games server when the site is public.
- Accounts and setup: AdSense account, ids and privacy pages; Play Console, AdMob and prices; Play Games setup for the Mind hubs (before M7 goes live; steps in `game-factory/docs/PLAY_GAMES_SETUP.md`); name and trademark checks; Cloudflare and VPS; copy the game-content workflows and add secrets; rotate the token from #154; set `CI_ENABLED` when CI should run.
- Say when to resume #148 (owner, 6:05 pm 16 Nov: stays paused).
- Block Puzzle: what replaces the paid coin packs (in discussion 6:20 pm 16 Nov: permanent, Play-restored items against keeping coins with a backup).
