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

## Status board (updated 1:05 PM AEDT 21 Nov 2026)

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
| Education vision and format contract | DONE, pushed (21 Nov) | `docs/VISION-education.md`, `docs/FORMAT-CONSTRAINTS.md`; decisions in `docs/decisions/craft-and-mind-apps.md`. |
| T1 Exact question formats (limits, size class) | DONE, pushed | Built in the IDE session (issue #175 was cancelled and closed). Limits widened to fit real content; `expression` stays optional. |
| T2 to T7 Skills, mastery, game limits, trail, Shooter, Snake, Mind journey | DONE, pushed | game-factory c3466c6, Scout 29e0014, Ranger 4da7248, Champion 8865209, Ember 9914fd7, Presto 366d9f8, `game-content` dcf9fd5. Detail and what is not built: `docs/FEATURE-SPECS.md`. |
| Skill list (152 topics, 3 named rungs each) | APPROVED by the owner, kept | `docs/SKILLS-REVIEW.md`; names in `game-content/skill_names.yaml`. |
| Trail look: Constellation | DECIDED (owner), NOT BUILT | Each topic a constellation, each rung a star (mock: artifact "Trail as a Constellation"). Open: apply to the three Craft apps that already have the trail, or only new apps. |
| Study "Other question types", web how-to text, Mind levels | DONE, pushed | Mind level thresholds are proposals, tuned later with real scores. |
| K1 Keyboard play in every game (app and web) | PARTLY DONE | Shooter and Snake have it (tests); existing games and the shared choice screen still to do. |
| W4 Responsive web layout | RULE DONE for NEW apps and games | Helpers and `docs/WEB_LAYOUT.md` in the template; current apps unchanged by the owner's choice. |
| M8 Rung opening by purchase or ad, coins with sign-in | SPEC NEEDED | Replaces the daily release. Check Families and child-directed ad rules first. See `docs/decisions/web.md`. |
| W3 Web ads and browser-saved progress | SPEC NEEDED | AdSense H5 Games Ads (closed beta; child-directed eligibility unconfirmed). Needs the owner's AdSense account and approval. |
| W5 Browser notifications on the web | SPEC NEEDED | Owner said add it. No backend means no push when the site is closed; the spec settles what a client-only version does. |
| Topic list and order review | BACKLOG (owner deferred) | Order kept for now; review later. Order lives in `game-content/topics.yaml`. Replaces the old C5 review.
| Pin and push helper scripts | DONE by the owner 3:59 pm (0fa6740) | `scripts/pull-all.sh`, `push-all.sh`, `bump.sh`, `push.sh`: pull everything, push every submodule main, move and push the pins (never forced; a pin must be on the submodule's origin/main). |
| Done earlier | C1 to C5, C7, C8, M1 to M5, X2a, X2b, icons (#167), workflow streamlining, privacy pages | Detail in `docs/QUEUE-LOG.md`, older in `docs/queue-log-archive.md`. |

## Active (running now)
- No issue runs, no deploys. The web deploy started by the 12:44 pm AEDT pin push (21 Nov) finished successfully. `games-web` is being changed by the owner; the studio session does not touch it.

## Next (post in this order, as dependencies finish)
- Specs to write, in this order, once the owner has the accounts and checks ready: M8 (rung opening by purchase or ad; Families check first), W3 (web ads and browser-saved progress; AdSense approval), W5 (browser notifications).
- Build next (owner decided, no blocker): the Constellation look for the trail (scope question below); K1 keyboard play in the existing games.
- Held for the owner: #148 curriculum (paused), X2 AdSense (accounts), the topic list and order review (backlog). Not picked: C6 read-aloud, C9 content editor, X3 accessibility pass, X4 localisation (see `docs/FEATURE-SPECS.md`).
- Issue 10 (purchase check on the VPS): only after the owner has set up the VPS and Cloudflare.
- Screenshots: once, at the very end (see `docs/SCREENSHOTS.md`).

## Waiting on the owner
- Decide whether `/appgames` should get version info too.
- Decide which is right for Scout: the docs (Door runner and Balloon pop coin-locked) or the code (free; only Tug of war is locked).
- Say whether the Constellation look goes on the three Craft apps that already have the trail, or only on new apps.
- Web and app money (M8, W3): the AdSense account and approval for web game ads, and the go-ahead after the Families and child-directed ad check; the spec follows.
- Review the how-to-play text (`games-web/overlay/common/lib/web_product/web_rules_data.dart` is generated from the apps), the content packs and each app's `docs/SPEC.md`.
- Listen to the M4 sound packs.
- Decide what replaces coins, and whether coins should survive a reinstall at all.
- Turn off the `noindex` header on the games server when the site is public.
- Accounts and setup: AdSense account, ids and privacy pages; Play Console, AdMob and prices; Play Games setup for the Mind hubs (before M7 goes live; steps in `game-factory/docs/PLAY_GAMES_SETUP.md`); name and trademark checks; Cloudflare and VPS; copy the game-content workflows and add secrets; rotate the token from #154; set `CI_ENABLED` when CI should run.
- Say when to resume #148 (owner, 6:05 pm 16 Nov: stays paused).
- Block Puzzle: what replaces the paid coin packs (in discussion 6:20 pm 16 Nov: permanent, Play-restored items against keeping coins with a backup).
