# What we are doing with each app (as of 1:40 AM AEDT Mon 23 Nov 2026)

Reference for a new session. Read `CLAUDE.md`, `docs/QUEUE.md` (index) and `docs/DECISIONS.md` first. Owner rules: web work only; **all app games are PAUSED** (owner, 2026-11-22). No change to `apps/*` until the owner lifts it. No releases, tags, version bumps, store uploads, AdMob, secrets or production promotion.

## The big picture
- Two kinds of things share the same games: the **web sites** (iteration 3, active, deployed to the VPS by pin push) and the **Android apps** (iteration 4, parked, "dumped once the web is complete").
- Each game is one package in `game-factory/games/<id>/`, on the shared engine `game_core`. Apps and the web only list games, bring content, theme and a shell (SH1: one copy of every game).
- Web: `games-web` builds one site per app (`https://activemindcraft.com/<slug>/`). Live check: `/<slug>/build-info.json` (`gamesCommit`, `gamesWebCommit`).
- Live now (23 Nov): all five sites on games `d422d24`, web `b139dc7`. Master `main` 7d475ca or later.

## The five learning apps (web live; apps paused)
| App (repo, `apps/…`) | Web slug | Audience | Web status | App status |
|---|---|---|---|---|
| Craft Scout (`game-craft-preteen`) | `scout` | Years 0 to 6 | Live. Gets every shared game and fix below | Paused |
| Craft Ranger (`game-craft-lowteen`) | `ranger` | Years 7 to 10 | Live, same | Paused |
| Craft Champion (`game-craft_highteen`) | `champion` | Years 11 to 12 | Live, same | Paused |
| Mind Ember (`game-mind-1`) | `ember` | Mind app, younger | Live, same | Paused |
| Mind Presto (`game-mind-9`) | `presto` | Mind app, older | Live, same | Paused |

What the web has had in this iteration (all five sites):
- Rewritten and renamed games: Bridge builder, Domino chain (was Series builder), Parcel train (was Snake), Wind-up dash (was Runner), Judge bot (was True or false). Old ids, best scores and links migrate.
- Shared key kit on every game (B-09): every button has a shortcut key and prints it; Space/Enter forward, Esc leave, 1 to 4 choices.
- Fixes: empty games (B-13), `/trail.html` My stars 404 (B-14), unsupported-topic screen (B-04), clipped letters (B-17).
- Owner checks pending: play Wind-up dash and Judge bot live (Judge bot live round not browser-tested by me; the agent tested a local build).

Next for the five apps (web side), all waiting for the owner to say start:
- W7 side panels (overall course scores first, then game score; game score highlighted in play): 4 owner questions.
- W5 browser notifications; M8 rung opening by coins or ad: 4 owner questions; W3 web ads and saved progress (needs AdSense ids); W8 no app names on the web; B-20 journey proposals.
- Game rewrites G-01..G-26 (one game at a time; Crane tower G-18 spec drafted, 5 questions). See `docs/queue/GAMES-REWRITE.md`.
- Content gaps: Word grid, Memory match, Sort bins, Word builder, Fill the gap; G-13c, G-26.

Next for the five apps (app side, iteration 4, not started): R2 rewrite of earlier Craft apps, K1 keys for apps, app screens, Constellation trail in apps, Issue 10 purchase check, Play Console, AdMob, screenshots.

## The three older apps (paused, code not touched)
| App (repo) | What it is | Status |
|---|---|---|
| Block Fall (`apps/game-block-fall`) | Blockfall game | Paused. Its workflows call the shared ones. Rewrite item G-04 not started |
| Block Puzzle (`apps/game-block-puzzle`) | Block puzzle with coin packs | Paused. Owner must decide what replaces paid coin packs. G-03 not started |
| Wingy (`apps/game-wingy`) | Flapping game; hero is a moth (B-19) | Paused. Replaced in rewrite G-22, not started |

Rule: do not touch the three old games' code.

## Other repos
- `game-factory`: shared games, `game_core`, pipelines. `games-web`: web builds and site (public, no secrets). `game-content`: topics, packs. `public`: privacy pages.

## Owner-only (never done by Claude)
AdSense account and approval, Play Console, AdMob, prices, Cloudflare, VPS accounts, trademark checks, tokens, `noindex` header removal, `CI_ENABLED`, turning on app work.

## State of the loop
`/run-queue` loop is STOPPED (owner, 1:30 AM AEDT 23 Nov); the hourly trigger is disabled. Nothing in the backlog starts until the owner says start. Detail: `docs/queue/LOOP.md`, `docs/queue/BACKLOG.md`, `docs/queue/WAITING-ON-OWNER.md`.
