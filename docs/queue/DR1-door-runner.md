# DR1 Door runner rewrite

- Status: DONE, live at /games/scout/ 4:39 PM 21 Nov
- Owner decisions: See Detail below (verbatim from the old queue row).
- Next step: Owner tries it live and on a device; Ranger and Champion copy later
- Links: Spec in Scout `docs/SPEC.md` ("Door runner rewrite"). Iteration 4 follow-ups.

## Detail (verbatim from the old queue row, 22 Nov 2026)
- Item: DR1 Door runner rewrite (Scout first; owner, 2026-11-21)
- Status: DONE and LIVE at /games/scout/ (deployed 4:39 PM AEDT 21 Nov; Scout 941dad2, pin 373de33, run 44871722740 green)
- Detail / next: Real runner: perspective lanes, steer, zap, slow, pause, hearts (older), question dialog, ad placeholder (rail or strip), glowing Wingy-style look. Spec in Scout `docs/SPEC.md` ("Door runner rewrite"); rules `lib/game/door_runner/`, UI `lib/ui/minigames/door_runner/`, screen `door_runner_screen.dart`. Scout: 745 tests, analyze, format, engine lock, ad-safety green. Next: owner tries it live and on a device (feel, swipe, read aloud) and reports; Ranger and Champion get a copy when the owner says. Someone else has uncommitted Balloon pop work in the Scout checkout (not part of this). The how-to-play text (engine file, synced to every app) still describes the old game and needs a synced change.
