# Design: the web catalog (W1) and rules dialog (R1) — DRAFT for the owner to approve

Status: draft by the studio session, 2026-11-15, not approved, nothing built. Source: the owner's description of the web version
(see `docs/decisions/web.md`, "Web product shape" and "Web catalog answers") and `docs/FEATURE-SPECS.md` items W1 and R1.

## What the visitor sees

1. **Landing page** at `https://activemindcraft.com/games/`. A short header, then a filter bar, then the games that fit.
   - **Type**: All / Learn / Fun.
   - **Year**: Foundation, Year 1 to Year 12 (Learn only).
   - **Topic**: the topics of the chosen year (Learn only; subject Maths or English shown as a group).
   - **Game**: a search-and-pick list of game names (Fun games such as Sudoku, Snake, Block Puzzle; Learn games such as Quick quiz).
   - Cards below, one per playable thing: a Learn card is "Maths, Year 3, Money, Quick quiz"; a Fun card is "Sudoku" (icon, one line, "Fun"). Empty result: a calm "Nothing here yet" with a Clear filters button.
2. **Pick a card** → the game opens (Learn: with that topic already chosen; Fun: straight into the game, like the Mind games).
3. **Rules dialog** on the first play of that game in this browser: how to play, 2 to 3 tips, a "Got it" button. Afterwards a **Rules** button on the game screen opens it again at any time, and a "Hide" button closes it. Never blocks play after the first time.
4. Play. Nothing is saved except one small "rules seen" flag per game in the browser (no account, no progress; owner: web and app are separate).

```
+--------------------------------------------------+
|  Active Mind Craft  - games to learn and play    |
|  [All|Learn|Fun]  Year [v]  Topic [v]  Game [v]  |
+--------------------------------------------------+
|  [Sudoku  Fun] [Snake  Fun] [Wingy  Fun] ...     |
|  [Maths Y3 Money - Quick quiz] [English Y3 ...]  |
+--------------------------------------------------+
```

## How it is built (the choice that matters)

- **The landing page is plain static HTML and a little JavaScript** (`games-web/site/`), not Flutter. Reason: AdSense and search need real text on a page that loads fast; a Flutter canvas gives neither. The filters run in the browser over one generated file, `catalog.json`.
- **`catalog.json` is generated at build time**, never typed by hand: Learn cards from each Craft app's `assets/content/topics.yaml` (subject, year, topic id, display name, in teaching order) and Fun cards from the Mind apps' `lib/ui/game_registry.dart` (id, title, icon). Each Fun game is listed once (Block Puzzle and Blockfall from Mind Ember; Wingy from Mind Presto; none duplicated). Cards carry the app slug that serves them.
- **The games stay the existing Flutter web builds** at `/games/<slug>/` (ember, presto, scout, ranger, champion), built by `games-web/scripts/build_game.sh` as today. Each build learns to open straight into one thing from the link: `/games/ember/#/game/sudoku`, `/games/scout/#/quiz/maths/3/money`. The overlay (`overlay/mind`, `overlay/craft`) reads the link and skips its own list or picker.
- **The rules dialog** is one shared widget used by the overlays on the web and by the apps (R1). The text is short and kept with each game (rules and 2 to 3 tips, in that game's `docs/SPEC.md`); the first-time flag is a browser-local key per game on the web.
- **Hosting**: the `games-web` container already serves `/games/`; the landing page replaces the plain index there. `build-info.json` stays. The AdSense slot (later, owner) sits on the landing page only.

## Behaviour decisions to confirm

1. Year and Topic apply to Learn cards. If a visitor picks a Year or Topic, Fun cards are hidden (they have no year); with Type = Fun, Year and Topic are disabled. Say if Fun cards should stay visible instead.
2. Ranger (Years 7 to 10) and Champion (Years 11 to 12) appear in the same catalog as Scout (Foundation to Year 6); the Year filter simply shows the years that exist. Visitors never see an "app" name unless the owner wants one on the card.
3. Learn games on the web today: Quick quiz only (built-in starter packs). Scout's minigames (Equation builder, Word search and crossword, Tug of war) come later as separate cards; anything purchasable is not on the web (owner).
4. I draft the rules and tips text for every game (about 12 Fun games and the Learn games) and the owner reviews it; a run does not invent it.

## Steps (each one a small piece, posted only when the owner says)

- **W1a** Build `catalog.json` + the static landing page (filters and cards) + deep links and first-play rules dialog in the overlays for Ember, Presto and Scout. Deploy `presto`.
- **W1b** Ranger and Champion builds and cards.
- **W1c** Craft minigames as cards (free ones only).
- **R1** The rules dialog and "rules seen" flag in the apps (save version bump) and the template, in the three older games only if the owner says.
