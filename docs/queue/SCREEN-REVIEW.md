# B-12 Journey and screens review: clear, interesting screens from selection to play

- Done 3:40 to 5:00 PM AEDT 22 Nov, read-only, live site `https://activemindcraft.com/` (site 08ce63d). Playwright Chromium, 1280x720, 1440x900, 390x844, 844x390, light and dark, keyboard walk, reduced motion. Companion: `docs/queue/GAME-REVIEW.md`.
- Ratings 1 to 5: clarity (know what to do in 3 s), look, delight (invites play), speed, access (keyboard, labels, contrast, targets).
- Not tested: sound, screen reader, real touch, real phone, slow network, AdSense slots (none showed), Learn mode beyond its first screen, drag and drop.

## Worst 5 screens

1. **"This game has no questions yet" dead end (and the empty rounds behind it).** The home card says "Topic 1 of 10" and opens a game with nothing to play. 8 of 11 Scout games have no content for most topics (Sort into bins: 10 of 12 topics tried empty; Word search and crossword: 18 of 18 empty). Fill the gap shows "0 of 0 right, 0 stars earned".
2. **Home card list**: 39 cards, the same game three times ("Door runner from Craft Scout / Craft Ranger / Craft Champion"), "Craft/Scout/Ranger/Champion/Mind/Ember/Presto" wording on every card, 8 of 12 Puzzles cards are flat colour squares with no art (Ball sort, Mahjong, Merge, Wingy, Snake, Brick breaker, Stack tower, Runner: `art/<id>.png` 404).
3. **Host bar and Game menu**: 7 coloured chips in 7 colours, 28 to 30 px tall; "Game" menu is a long list of 39 entries with "Craft Scout / Craft Ranger" repeated, running past the bottom of a 720 px window; at 390 px the Game button touches Rules; at phone size Year, Topic, I know this and Learn disappear (no way to change topic).
4. **Results screens of the choice games** ("Round finished. Nice work on Times tables." with Play again, I know this, Next topic): no score, no stars, no key hints, no celebration; Mind games show "Remove ads" and rewarded "Continue".
5. **My stars (`/trail.html`)**: the footer link "See my stars" returns 404 Not Found (also an unstyled plain "Not Found" page for any bad address such as `/nogame/`). The progress promise on the page is unreachable.

Also bad: the one-line "question moves on before feedback" bug (see GAME-REVIEW bug 1), page titles "Craft Scout Games", "Mind Ember Games" in the tab, and game pages with no accessible DOM at all.

## Tables per screen

### 1 Home page (first load, shelves, search, filters, year)

| Aspect | Rating | Notes |
|---|---|---|
| clarity | 3 | Search, Year, Learn, theme toggle are clear; but "Games" then 39 cards: what to pick? "Best for Year 3 first" is a small caption |
| look | 4 | Clean navy bar, big coloured icon cards, good in light and dark; flat-colour cards for 8 puzzles look unfinished |
| delight | 3 | Nice icons, no hero, no "play now", no featured game, no stars shown on cards |
| speed | 4 | Loads in about 2 s; skeleton cards (8 empty rounded squares) show while loading, good |
| access | 4 | Skip link, h1, main, header, footer, real labels; Tab order Skip, logo, search, Year, Learn, theme, cards; 3 px focus ring visible; cards are focusable buttons (39 Tab stops to reach footer); only target under 44 px is the "See my stars" text link (88x17) |

Problems: the search field has TWO clear X icons (one inside, one native); searching "maths" or "spelling" finds nothing (search only matches game titles); no filters other than Year (no Learn/Fun filter, no "Puzzles/Arcade/Words" shelves; two shelves only: "Games" and "Puzzles"); the Choose your year dialog is clear and big (Foundation to Year 12, "Not now"), but has no close X and the Year chip shows no meaning ("Year 3" of what?); "Topic 1 of 10" on each card means nothing to a child; first-run: a new visitor gets the year dialog? (Year pre-set in my test, first-run flow NOT tested). Version line in the footer shows internal app hashes ("ember e25df3f"): visible to every visitor.

Proposal: one shelf of games ordered by "fun first", a big "Play" hero card ("Continue: Door runner" or a surprise pick), one card per game (no Scout/Ranger/Champion triplets: pick the right one from the year), a stars count on each card, 3 filter chips (All, Maths, English, Puzzles), search by topic too, and a card art for every game.

### 2 Opening a game (loading, how-to dialog, host bar, Game menu)

| Aspect | Rating | Notes |
|---|---|---|
| clarity | 3 | Loading shows the logo and a thin bar "Getting ready..." (good). Then a modal "How to play" with text and "Got it" |
| look | 3 | Logo screen is good; bar chips are small and loud; version badge bottom left on every game page ("app 4b7e5c4 . games a0d6a52 . site 08ce63d") |
| delight | 2 | Nothing animated while waiting; the wait is long |
| speed | 2 | Game ready took 9 to 14 s in this sandbox (loading bar grows slowly, no percent); a wrong address still showed the loading screen after 10 s |
| access | 2 | Game pages have no semantic DOM (0 semantics nodes, no h1, no landmarks); Esc closes the how-to dialog, Enter does NOT (the one thing the owner asked for: "Enter or Got it"); "Got it" shows no key hint; dialog has no focus trap shown |

Problems: how-to dialog covers the Start/intro screen so the child cannot see the game behind it; dialog on every first open of a game; a different dialog name for Fill the gap ("Cloze and grammar fix") and "Quick quiz" for Learn; host bar chips "All games, Game: <name>, Year 3, <Topic>, I know this, Learn" plus "Rules" far right: 7 targets before the game; chip colours (purple, blue, teal, green, orange, pink) carry no meaning.

Proposal: keep the loading logo but add a real progress and a tip; show the how-to as a one-line banner on the intro ("Press Enter to start") instead of a blocking dialog, with "Rules" always on the bar; reduce the bar to: back arrow, game name, topic, Rules (Year and Learn go into the game menu); Enter or Space always means "go".

### 3 Topic chooser, "I know this", Learn, Rules dialog

| Aspect | Rating | Notes |
|---|---|---|
| clarity | 3 | Topic list: circle, name, status "New/Practising", and a blue "I know this" link per row; confirm dialog "Show you know Times tables: answer 5 questions, 4 or more right" is clear |
| look | 3 | Plain white lists on dimmed page; no art or stars |
| delight | 2 | Reads like a settings page |
| speed | 4 | Instant |
| access | 3 | Keyboard works on dialogs; link text "I know this" repeated 10 times with no topic in the label |

Problems: the topic list offers topics the current game cannot play (the game then shows the dead end); the list is not filtered by game; Learn opens "Quick quiz: study" with its own header strip, a quiz not a lesson; Year dialog in the bar looks different from the home Year dialog (white bar vs card).

Proposal: show only topics the game supports (grey the others with "Not in this game, try Balloon pop"); "I know this" becomes one button "Skip ahead (5 questions)"; one shared dialog style.

### 4 Unsupported-topic screen and empty/error screens

| Aspect | Rating | Notes |
|---|---|---|
| clarity | 4 | "<Game> has no questions for <Topic> yet", then "Try one of these games instead" with icons, then (new) "This game plays these topics" list: clear and helpful |
| look | 3 | Lots of white space; no illustration |
| delight | 2 | It is an apology |
| speed | 4 | Instant |
| access | 4 | Cards keyboard focusable |

Problems: it is reached far too often (see worst 1); "Flash review" appears in the alternative list but not on the home page; bad hash route silently opens Learn; bad URL returns bare "Not Found" in monospace with no way back; an out-of-range year (`maths/99/zzz`) stays on the loading screen.

Proposal: never offer a game with no content; on the home card, hide or badge games that have nothing for the year; a styled 404 with the logo and "All games".

### 5 Intro, in-play and results for 5 games

| Game | Intro | In play | Results | Notes |
|---|---|---|---|---|
| True or false (choice kit) | 3 plain "Start" | 2 two huge buttons, no art | 2 "Round finished" no score | key hints "Enter / Space go, Esc exit" good; question shifts early |
| Blockfall (arcade) | 4 (how-to over the board) | 4 clean | 3 "GAME OVER Score" with share, Remove ads, Play again, Home, Continue | store buttons on the web |
| Bridge builder | 3 text and a robot scene, Start | 4 scene, tray, HUD | not reached | no strip; tile and slot keys unclear |
| Sudoku (Mind) | 3 difficulty list with small "Play" buttons, hidden by dialog | 4 big board, digit bar | not reached | own strip |
| Door runner | 4 "DOOR RUNNER" title, Start, 2 players | 5 3D hall, doors, hearts | 3 "Not quite" card with Next | Enter does not start; start button without hint |

Common: the six Mind games have their own title strip and back arrow under the host bar (rule: title bar inside a game; existing games keep it until rewritten); the Craft ones have a strip too except Bridge builder and Door runner.

### 6 My stars and the footer

| Aspect | Rating | Notes |
|---|---|---|
| clarity | 2 | Footer text "Your progress is saved on this device only... See my stars" is clear |
| look | 3 | Footer logo big, small grey text |
| delight | 1 | The link leads to 404 |
| speed | - | - |
| access | 2 | Link 88x17 px; low contrast grey 11 px version line |

Problem: `/trail.html` is 404. Proposal: ship the page (TRAIL item) or hide the link until it exists; show stars on the home cards instead.

### 7 Sizes, themes, keyboard, accessibility

| Check | Result |
|---|---|
| 1280x720 / 1440x900 | Home fits the width, page scrolls (normal for a list). All games fit the height: scrollHeight = innerHeight on every game page tested (no page scroll). Games use only a narrow middle column on wide windows (Block Puzzle and Blockfall about 320 px of 1280) |
| 390x844 | Home: header stacks, 2 columns of cards, good. Game bar: only All games, Game, Rules fit; Game button touches Rules on Bridge builder ("Game: Bridge builder" reaches the Rules chip, known B-05) |
| 844x390 | Home OK. Door runner intro fits, Start and "2 players" just fit; Snake intro shows only part (Play button under the text, Walls switch at the bottom); bar takes 44 of 390 px |
| Dark / light | Home works in both with a toggle; games follow the system scheme: Craft games light, Mind games dark. No contrast failure seen on the home page; grey 11 px version line is low contrast |
| Keyboard only | Home: yes (Tab, Enter on a card opens it). In a game: a child CAN start and finish a round with keys on choice games (Esc, then Enter, 1 to 4, Enter), but not on Door runner (Enter does not start), and Enter does not close the how-to dialog (Esc does). Enter on a focused card opened Fill the gap, an empty game |
| Reduced motion | Page loads and shows no motion differences I could detect; not verified inside games |
| Landmarks / headings | Home: header, main, footer, h1, one h2 per shelf, plus two hidden h2 ("The game list could not be loaded", "No games found") present in the DOM; game pages: none |
| Tap targets | Home all >= 44 px except the footer link; host bar chips about 30 px tall; Mind games' in-game text buttons small |

### 8 Rule breaks

- Wording visible to visitors (owner rule W8): "from Craft Scout", "from Craft Ranger", "from Craft Champion", "from Mind Ember", "from Mind Presto" on every card; tab titles "Craft Scout Games", "Craft Ranger Games", "Mind Ember Games", "Mind Presto Games"; Game menu entries "Craft Scout/Craft Ranger"; Version line "ember ... presto ... scout ... ranger ... champion"; URLs `/scout/`, `/ember/`.
- Title bar inside a game: Ember and Presto games (all 12) and all Scout games except Bridge builder and Door runner.
- Page scrolling where it should fit: none found (scrollHeight = innerHeight on all game pages tried at 1280x720, 390x844, 844x390). Content cut off inside the page: Word builder letters and Sudoku digit bar under the key hints; Game menu list past the bottom.
- Clipped text / overlaps: Rules touches Game at 390 px on long names.
- Tap targets under 44 px: host bar chips (about 30 px), footer link.
- Long waits: 9 to 14 s game load.
- Not living beings: Wingy is a moth; question texts such as "A spider has 8 legs" (content, not art).

## Proposal: the best journey

Shortest path: landing, one tap, playing. Today: landing, card, 9 to 14 s load, how-to dialog, Got it, intro, Start (5 steps, maybe a dead end).

1. **One tap to play**: a hero "Play" card on the landing (last game or "Today's pick") that opens a game already on a supported topic of the child's year; skip the year dialog until needed, ask it once, as a friendly 2-line chooser after the first round.
2. **Never open an empty game**: show on the landing only games that have content for the year, and in the topic chooser only supported topics; no more "Topic 1 of 10".
3. **No app names**: one card per game, one address per game, tab title "<Game> - Active Mind Craft", no version line for visitors (W8).
4. **Start in one key on every intro**: a big Start button that says "Start (Enter)", the how-to as a banner not a blocking dialog, Enter and Space always go, Esc exits; same on dialogs ("Got it (Enter)"). Fixes B-09.
5. **Results with stars and the next step**: 1 to 3 stars, score, a "streak" line, then one big "Next game" button plus "Play again"; star counts appear on the landing card and in My stars; drop store buttons from the web.
6. **Smaller bar**: back, game name, topic, Rules; others in the Game menu; chips at least 44 px tall; at 390 px two chips only.
7. **Finish the pages**: My stars page (fixes 404), styled 404 and loading error with a way home, a real progress bar and a "tip" while the game loads.
