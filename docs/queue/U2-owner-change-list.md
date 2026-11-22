# U2 Owner change list (22 Nov 1:20 PM)

- Status: Items 1, 2, 3 DONE; item 4 dropped
- Owner decisions: See Detail below (verbatim from the old queue row).
- Next step: None open
- Links: Spec drafted 2:05 PM in `docs/FEATURE-SPECS.md` (U2).

## Detail (verbatim from the old queue row, 22 Nov 2026)
- Item: U2 Owner change list (22 Nov, 1:20 PM AEDT)
- Status: TO DISCUSS, NOT STARTED (owner: do not code until asked)
- Detail / next: (1) Game start screen: show the Active Mind Craft logo, not the "Craft Ranger games" banner/loading page. (2) Space accepts "Next" after an answer in every game (hands stay put; Space still pauses in play). (3) Unsupported skill in a game: besides the games that do support it, also list the other topics this game supports. (4) Rewrite Series builder first (scope to agree). Owner said yes to all three; Series builder dropped (U3 replaces it). SPEC DRAFTED 2:05 PM AEDT in `docs/FEATURE-SPECS.md`. Item 3 (other topics when a game cannot run the topic) is APPROVED TO START (owner, 2:20 PM AEDT): a subagent starts when the Bridge builder subagent finishes. Items 1 and 2 still wait for the owner's start. Item 1 DONE 1:50 PM AEDT 22 Nov (games-web 98210d2: `scripts/loading_logo.py` called from `build_game.sh` puts the Active Mind Craft logo on the `#loading` screen of all five web games; Playwright screenshots at 390 and 1280, light and dark, checked; owner told to look live). Item 2 DONE 1:55 PM AEDT 22 Nov (game-factory 6d110e4, games-web a38b195 factory.ref: Space = Enter on Next, intro and results, pauses in play; changed: choice kit (Tug of war, True or false, Cloze fix, Balloon pop, Shooter shell), ArcadeFrame games, series_builder, sort_bins, word_builder, flash_review, word_grid, memory_match (1 and 2 players), door_runner (race and wrong-answer Next), tug head to head, ball_sort, merge, mahjong, sudoku, solitaire, blockfall (choice and versus); bridge_builder, block_puzzle and wingy already fine). Item 3 DONE 2:05 PM AEDT 22 Nov (games-web 5312763: unsupported screen also lists "This game plays these topics" for the year; 2 widget tests, analyze clean).
