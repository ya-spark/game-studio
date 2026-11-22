# Done items

One line each; the verbatim old queue text follows below. Dated detail: `docs/QUEUE-LOG.md`, older `docs/queue-log-archive.md`.

- Web hosting at `/games/` (own container, port 7080): DONE 2:41 am
- Version info (`build-info.json`, page labels): DONE 3:22 am; extended 10:15 am 22 Nov
- Deploy on pin push (`deploy-games-web`): DONE, runs 6 to 14
- Repo names follow the audience: DONE 3:15 am
- `games-web` public: DONE
- W1a landing page, filters, deep links, how-to dialog: DONE, live 3:34 am
- W1b Presto, Ranger, Champion on the web: DONE, live 3:53 am
- W1c Craft minigames as catalog cards: DONE, live 9:03 am
- #171 M6 Achievements (Ember, Presto): DONE 9:05 am
- R1b Rules dialog in the Mind hubs (#172): DONE
- R1a Rules dialog in Craft apps and template (#173): DONE 9:50 am
- #174 M7 Play Games leaderboards: DONE 4:14 pm; owner creates Play Console leaderboards
- Web how-to-play text synced with the apps: DONE, live 4:15 pm
- Preview copies `/appgames/web-ember/`, `/web-scout/` removed: DONE 6:15 pm
- W2 Landing page redesign: BUILT 21 Nov; superseded by W2.1
- Local dev watch mode, footer device note removed: DONE 1:08 PM 21 Nov
- T1 Exact question formats: DONE
- T2 to T7 Skills, mastery, limits, trail, Shooter, Mind journey: DONE; Snake for series dropped
- Skill list (152 topics, 3 rungs): APPROVED, kept
- Study "Other question types", web how-to text, Mind levels: DONE
- W4 Responsive web layout: RULE DONE for new apps and games
- Pin and push helper scripts: DONE by owner 3:59 pm
- Done earlier (C1-C5, C7, C8, M1-M5, X2a, X2b, icons, workflow, privacy pages): DONE

## Verbatim detail (from the old queue, 22 Nov 2026)

### Web hosting at `/games/` (own container, port 7080)
- Item: Web hosting at `/games/` (own container, port 7080)
- Status: DONE 2:41 am
- Detail: `/appgames` untouched (401).

### Version info (`build-info.json`, page labels)
- Item: Version info (`build-info.json`, label on every game page, `/games/` footer)
- Status: DONE 3:22 am; extended 10:15 am 22 Nov
- Detail: Every game on `/games` and `/appgames` shows `app <commit> · games <commit> · site/studio <commit>` bottom-left; `build-info.json` has appCommit, gamesCommit (game-factory), gamesWebCommit/studioCommit. `/appgames/*/build-info.json` is open (no login) through a cloud-deploy Caddy route; the pages stay behind login. Checked live 10:13 am: all as pinned.

### Deploy on pin push (`deploy-games-web`)
- Item: Deploy on pin push (`deploy-games-web`)
- Status: DONE, proven by runs 6 to 14
- Detail: A Claude run's own pin push DOES start it (runs 12, 13, 14 at 9:05 to 9:46 am); all five games live at the pinned app commits (checked 4:03 pm).

### Repo names follow the audience
- Item: Repo names follow the audience (Scout = `game-craft-preteen`, Ranger = `game-craft-lowteen`)
- Status: DONE 3:15 am
- Detail: Internal ids `craft_lowteen` (Scout) and `craft_preteen` (Ranger) stay (historical).

### `games-web` public
- Item: `games-web` public
- Status: DONE
- Detail: No secrets or private code in it.

### W1a landing page, filters, deep links, how-to dialog
- Item: W1a landing page, filters, deep links, how-to-play dialog
- Status: DONE, live 3:34 am
- Detail: Start-up fix (parallel pack prefetch) live 3:42 am.

### W1b Presto, Ranger, Champion on the web
- Item: W1b Presto, Ranger, Champion on the web
- Status: DONE, live 3:53 am
- Detail: Catalog then had 164 cards.

### W1c Craft minigames as catalog cards
- Item: W1c Craft minigames as catalog cards
- Status: DONE, live 9:03 am
- Detail: 775 cards (12 Fun, 152 Quick quiz, 611 minigame cards).

### #171 M6 Achievements (Ember, Presto)
- Item: #171 M6 Achievements (Ember, Presto)
- Status: DONE 9:05 am
- Detail: Ember 8520637, Presto 535276c, pins moved; 969 and 669 tests; summary posted on the issue.

### R1b Rules dialog in the Mind hubs (#172)
- Item: R1b Rules dialog in the Mind hubs (#172)
- Status: DONE (Ember 1e886a9, Presto be98899)
- Detail: Texts changed from the web copy are listed in the issue comment and QUEUE-LOG.

### R1a Rules dialog in Craft apps and template (#173)
- Item: R1a Rules dialog in the Craft apps and template (#173)
- Status: DONE 9:50 am (template 44424ff, Scout f228373, Ranger ea89ae4, Champion fe5774f)
- Detail: Template 843, Scout 592, Ranger 615, Champion 623 tests green; Mind engine synced. Changed texts are in the issue comment; the web copy needs the same words.

### #174 M7 Play Games leaderboards
- Item: #174 M7 Play Games leaderboards (Ember, Presto)
- Status: DONE 4:14 pm
- Detail: Pushed to both Mind hubs and `public/`; off in the repo (`play_games.enabled: false`). Next: owner creates the Play Console leaderboards and puts the ids in `play_games.leaderboards`.

### Web how-to-play text synced with the apps
- Item: Web how-to-play text synced with the apps
- Status: DONE, live (checked 4:15 pm)
- Detail: Run 15 (started 4:07 pm) rebuilt all five games at games-web a7412f1; the live Blockfall dialog shows the apps' new wording; 775 cards; `/appgames` 401. `games-web/scripts/sync_rules.py` generates the text from the apps' catalogues (25 games): re-run it after an app's text changes.

### Preview copies `/appgames/web-ember/`, `/web-scout/` removed
- Item: Preview copies `/appgames/web-ember/` and `/web-scout/` removed
- Status: DONE 6:15 pm
- Detail: Owner said remove (6:05 pm). Full `/appgames` rebuild, `deploy-to-vps-as-web` run 13: the image now holds only the eight apps at their `main`. `/games/` untouched. Not checked in a browser (`/appgames` is behind the login).

### W2 Landing page redesign
- Item: W2 Landing page redesign (games-web)
- Status: BUILT, pushed 2:50 AM AEDT 21 Nov (games-web 746e946)
- Detail: Superseded by W2.1 (same page). Not checked in a real browser (no browser in the session).

### Local dev watch mode, footer device note removed
- Item: Local dev: watch mode by default, footer device note removed (games-web)
- Status: DONE, pushed 1:08 PM AEDT 21 Nov (games-web 9a0d8a2, pin 7b0bb58)
- Detail: `scripts/run.sh` rebuilds and reloads on change; start builds only games missing from `dist/` (`FULL=1` for all, `WATCH=0` to opt out). Not run end to end.

### T1 Exact question formats
- Item: T1 Exact question formats (limits, size class)
- Status: DONE, pushed
- Detail: Built in the IDE session (issue #175 was cancelled and closed). Limits widened to fit real content; `expression` stays optional.

### T2 to T7 Skills, mastery, limits, trail, Shooter, Mind journey
- Item: T2 to T7 Skills, mastery, game limits, trail, Shooter, Mind journey
- Status: DONE, pushed
- Detail: game-factory fb2823d, Scout 9bc4cce, Ranger a7421a3, Champion 7ed1ac1, Ember 7587c7e, Presto 11d1e87, `game-content` dcf9fd5. Snake for series was built and then DROPPED (owner, 3:10 PM AEDT: Snake is for Presto only; questions in it are not a good experience). Detail and what is not built: `docs/FEATURE-SPECS.md`.

### Skill list (152 topics, 3 rungs)
- Item: Skill list (152 topics, 3 named rungs each)
- Status: APPROVED by the owner, kept
- Detail: `docs/SKILLS-REVIEW.md`; names in `game-content/skill_names.yaml`.

### Study "Other question types", web how-to text, Mind levels
- Item: Study "Other question types", web how-to text, Mind levels
- Status: DONE, pushed
- Detail: Mind level thresholds are proposals, tuned later with real scores.

### W4 Responsive web layout
- Item: W4 Responsive web layout
- Status: RULE DONE for NEW apps and games
- Detail: Helpers and `docs/WEB_LAYOUT.md` in the template; current apps unchanged by the owner's choice.

### Pin and push helper scripts
- Item: Pin and push helper scripts
- Status: DONE by the owner 3:59 pm (0fa6740)
- Detail: `scripts/pull-all.sh`, `push-all.sh`, `bump.sh`, `push.sh`: pull everything, push every submodule main, move and push the pins (never forced; a pin must be on the submodule's origin/main).

### Done earlier (C1-C5, C7, C8, M1-M5, X2a, X2b, icons, workflow, privacy pages)
- Item: Done earlier
- Status: C1 to C5, C7, C8, M1 to M5, X2a, X2b, icons (#167), workflow streamlining, privacy pages
- Detail: Detail in `docs/QUEUE-LOG.md`, older in `docs/queue-log-archive.md`.
