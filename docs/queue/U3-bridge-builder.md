# U3 Bridge builder (Equation builder rewrite)

- Status: FIXED 2 bugs, pushed 3:05 PM AEDT 22 Nov (game-factory de4d7ca, games-web da8f7b3)
- Owner decisions: Owner 22 Nov 1:35 PM asked for the rewrite as a bridge game.
- Next step: Owner looks live again after deploy, sends changes
- 3:05 PM AEDT 22 Nov bug fixes (owner, live web test): (1) title strip removed (exit, read aloud, pause are 44 dp overlays, HUD in the play area); (2) game ran below the window: tiles were stretched one per row by `Container(alignment)` and the layout was fixed-height; now height-aware (scene shrinks, tray scrolls only when it must, landscape side by side). Shell not at fault. Real Chromium at 1280x720, 390x844, 844x390: scrollHeight = innerHeight.
- Links: Spec: `game-factory/games/equation_builder/docs/SPEC.md`. Figma prompt: `docs/art-prompts/bridge-builder-figma-prompt.md`.

## Detail (verbatim from the old queue row, 22 Nov 2026)
- Item: U3 Equation builder rewrite as a bridge game (owner, 22 Nov 1:35 PM AEDT)
- Status: BUILT and pushed 1:50 PM AEDT 22 Nov (game-factory 0dd2fec, games-web da67764, pins moved; deploy-games-web runs)
- Detail / next: Bridge builder: toy wind-up robot at a gap, sign with the target, tiles dragged or tapped into slots, right sum lays a plank and the robot crosses, wrong sum wobbles and resets; river, canyon, sky stages end at a flag with stars; younger 3 slots no timer, older 5 slots and a gentle timer; keyboard incl. Space = Next. Id `equation_builder` kept. Art drawn in code (Figma limit blocked writes); Figma prompt for the owner: `docs/art-prompts/bridge-builder-figma-prompt.md`. Spec: `game-factory/games/equation_builder/docs/SPEC.md`. Look at it live after the deploy; send changes.
