# W7 Web game layout: side panels around every game

- Status: SPEC DRAFTED 2:54 PM AEDT 22 Nov (docs only, `docs/FEATURE-SPECS.md` section W7); build only on owner start.
- Owner decisions: on a wide web window every game sits in the middle; the LEFT panel shows stars, achievements and the coin count (NOT year and topic) and a link to My stars; the RIGHT panel is one ad slot (labelled placeholder until the owner sends AdSense slot ids and does the child-directed check C9). Applies to ALL games, including Wingy and Blockfall (they no longer use the whole screen). On narrow windows and phones both panels are hidden: the game is full width with a small strip for stars and coins above it. Built once in the shared web shell in games-web, not in each game.
- Open: 4 owner questions at the end of the W7 spec (hide point 1100 px, derived achievements, empty right column until C9, panels on list pages).
- Links: `docs/queue/M8-rung-opening-coins.md` (coins), `docs/queue/W3-web-ads-progress.md`, `docs/queue/TRAIL-constellation.md`, `docs/FEATURE-SPECS.md`.

## Owner answers 22 Nov ~3:10 PM AEDT
- Questions 1 to 3 (1100 px breakpoint and 1000 px column, the six derived achievements, empty right column with no placeholder until C9): owner said "your choice" = the spec's proposals stand.
- Question 4 (do the list pages get the panels): the web must NOT show the app names (Craft, Scout, Ranger, Champion, Mind, Ember, Presto) in any wording; to a visitor it is all just games under the web. Same layout for every page; see item W8 (web naming, to discuss).

## Known shell bug (found 22 Nov ~3:15 PM AEDT by the Bridge builder fix)
- At 390 px wide the web bar's Rules button overlaps the Game menu button (`games-web/overlay/common/lib/web_product/web_bar.dart`). Not fixed; fold into W7 step 1 (shell work) or fix on the owner's say.
