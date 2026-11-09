# [change] factory: design system, per-app themes, Game and Study mode, navigation and parent lock (issue 2)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 1A, 1B, 1C finished and passing, **and the design phase done** (the exported design files below are committed). Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
One design system that the five apps share, with per-app colours and vibe, plus the Game and Study modes the Craft apps need.

## Design phase (before this issue; a live session with the owner, in Figma, not an automatic run)
Claude designs in Figma and the owner reviews. The result is committed as files, because automatic runs cannot open Figma:
- `design/tokens.json` (shared) and `design/<app_id>/tokens.json` per app: colours, type, spacing, radii, motion, for light and dark.
- `assets/design/` per app: **SVG** for icons, avatars and mascots, **WebP** for illustrated backgrounds. All art is original (made in Figma, no stock illustrations, no AI-generated images) and listed in `assets/LICENSES.md`.
- Open-licensed (OFL) font files, listed in `assets/LICENSES.md`: a rounded friendly font for Scout and Ranger, a cleaner modern one for Champion and the Mind apps.
- A short `design/README.md` with the Figma link, the palette and vibe of each app, and the screens designed.

## Decisions already made (owner, 2026-11-09)
- Claude proposes the palette and style per app and the owner reviews; Claude designs in Figma in a live session; the handoff is exported assets plus a tokens file; SVG for icons, avatars and mascots, WebP for illustrated backgrounds.
- A bottom bar of 3 to 4 tabs that changes with the mode, and a mode toggle in the top bar on every screen. Game mode: Play, Challenges, Shop. Study mode: Learn, Progress, Revise.
- The interface level of Scout and Ranger follows the child's year level: Scout Foundation to Year 2 and Years 3 to 6; Ranger Years 7 to 8 and Years 9 to 10.
- Craft apps open in Game mode on first launch and then remember the last mode, per child. A parent can lock a child to one mode (behind the parent gate, with a lock icon while locked).
- Study mode is light and calm; Game mode follows each app's own style (bright for Scout, dark for the Mind hubs).

## Scope
- **Theme system:** loads the tokens at build time (config-driven, no network). A `ThemeData` per app and mode; two layout levels (younger and older) for Scout and Ranger, chosen from the child's year level; a mature look for Champion; adult look for the Mind hubs. A debug-only theme gallery screen shows every shared widget in every theme for review.
- **Shared widgets:** buttons, cards, top bar, bottom bar, dialogs, progress bars, avatar, coin icon, using the tokens. Existing screens (home, shop, challenges, settings, parent gate) are moved onto the theme without changing their behaviour.
- **Mode system:** Game and Study mode stored per child in the profile from 1B; the mode toggle in the top bar; the parent lock with its icon; the bottom bar and the pages respond to the mode.
- **Game mode tabs:** Play (the minigames registered in 1C, shown only when enough items are open), Challenges, Shop.
- **Study mode tabs:** Learn (topics by year with a start button, extra packs the parent has downloaded), Progress (per topic: items passed, still to pass, next release; fed by the 1B progress data), Revise (the "revise mistakes" list). Untimed practice with explanations, using the Quick quiz from 1C.
- **Accessibility in the shared widgets:** text follows the phone's size setting plus a large-text option (no layout break at 150 percent); contrast of at least 4.5 to 1, enforced by a test over the tokens; a reduce-motion option that turns off shaking, fast transitions and flashing; a screen-reader label on every shared control.
- **SVG support:** one new dependency for rendering SVG, pinned exactly and imported only in a small widget file.
- Test IDs for the toggle, the lock, the tabs and every new screen in `lib/ui/test_ids.dart`.
- **Docs:** `docs/DESIGN_SYSTEM.md` (tokens, themes, how an app picks its theme and level), and the template `docs/SPEC.md` updated.

## Acceptance
All template checks pass. Tests: every theme builds; the contrast test passes for every token pair; mode persistence per child; the lock blocks switching and shows its icon; the tab set changes with the mode; the level follows the year level (including a change of year); no layout overflow at 150 percent text on the main screens; screen-reader labels present; reduce motion honoured.

## Needs from the owner
Review and approval of the Figma designs in the design phase, before this issue is posted.

## Out of scope
The real minigames (the five app issues), real artwork beyond what the design phase produced, real AdMob IDs, any AI feature.
