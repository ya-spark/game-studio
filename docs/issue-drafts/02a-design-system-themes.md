# [change] factory: design system, per-app themes and shared widgets (issue 2A)

**Repo:** game-factory (`template/flutter-game-template`, `scripts/new_game.py`). **Depends on:** 1A to 1D (done) and the design phase (done and approved by the owner, 2026-11-10). Read `docs/PLAN-new-apps.md`, `docs/DECISIONS.md` (the "Design phase done" entry) and `template/flutter-game-template/design/README.md` first. Part 1 of 2 of the design system issue; 2B (modes, navigation and screens) follows.

## Goal
One theme system the five apps share, built from the committed design files, with the shared widgets the screens need, and accessibility built in. No new screens or behaviour yet.

## The design files (already committed, `design/`)
Shared `tokens.json`; `<app_id>/tokens.json` (colours and radii per mode: `game` and `study` for Scout, Ranger and Champion, `default` for Mind Ember and Presto; Scout and Ranger also have `levels`); `<app_id>/art/` (SVG hero scenes and, for Scout and Ranger, a mascot); `icons/*.svg` (24 x 24, `currentColor`); `fonts/` (Nunito variable, Plus Jakarta Sans Regular, Bold, ExtraBold, with their OFL licence texts). Figma: https://www.figma.com/design/ymFJswpzJer3Uicm5VfBKd (you cannot open it; the files are the source). Hero scenes are SVG on purpose.

## Decisions already made (owner)
- **No human figures, faces or silhouettes in any art.** Characters are friendly shapes. Never add a person icon (use a shape for profile avatars).
- Fonts: Nunito for Scout and Ranger, Plus Jakarta Sans for Champion and the Mind apps. Text follows the phone's size setting.
- Prices never appear on children's content cards; the price shows only behind the parent gate. Wording never pressures children.
- Colour pairs must pass 4.5 to 1 (they do in the tokens, lowest 4.87 to 1).

## Scope
- **Generator:** `new_game.py` copies only the game's own `design/<app_id>/` files, the shared `tokens.json`, the icons it uses and its font into `assets/design/` and `assets/fonts/`, writes the `pubspec.yaml` font and asset entries and the `assets/LICENSES.md` rows (source, license: the tokens, icons, mascot and scenes are original, written by the studio; the fonts are SIL OFL 1.1 with their source URLs). New profile flag value: the design `app_id` comes from the existing app id (`craft_lowteen` and so on); the plain `puzzle` profile keeps today's look unless a design id is given. Keep `check_asset_licenses.sh` passing for generated samples.
- **Theme system** (`lib/ui/theme/`, pure Dart where possible): loads `tokens.json` at build time or from the bundled asset (choose and document which; config-driven, no network). One `ThemeData` per mode (`game`, `study`, `default`) with the design colours, the font (Nunito through `FontVariation('wght', ...)`; check that weight 400, 700 and 800 render), the type scale, radii and spacing from the tokens. A `ThemeTokens` object that widgets read (colours by the token names, radius, spacing). Two interface levels for Scout and Ranger (`levels` in the tokens: text scale, minimum touch size, timers, voice first) selected from the child's year level when 2B wires the profile; here, make the level an input to the theme builder.
- **SVG:** one new dependency for rendering SVG (`flutter_svg`, pinned exactly), imported only in one small widget file. Icons recolour with the theme.
- **Shared widgets** (all token-driven, each with test IDs in `lib/ui/test_ids.dart` and a screen-reader label): primary, secondary and ghost buttons (with disabled state); coin chip; stat chip (streak, stars); top bar with a slot for the mode toggle (the toggle itself is 2B); bottom bar with 3 tabs and an active pill; card; progress bar (thick and thin); status and mastery chip (a coloured dot for Learning, Getting there and Mastered); **game tile** (art slot, badge, stars, thin progress bar with a note, or a lock and coin price); **topic card** (badge, items passed of total, progress bar, mastery chip, "to revise" chip, optional accuracy shown only when a flag is set, which is off for Scout); **pack card** ("Preview free", locked "Full pack", no price); **suggested-next card**; **hero header** (the app's scene SVG, optional mascot, title, subtitle, stat chips, overlay slot for the top bar); dialogs. They match the Figma screens in `design/README.md` ("Card content").
- **Existing screens** (home, shop, challenges, settings, parent gate) move onto the theme and shared widgets without changing their behaviour.
- **Theme gallery:** a debug-only screen that shows every shared widget in every mode of the app's theme, for the owner to review on a device.
- **Accessibility in the shared widgets:** text follows the phone's size setting plus a large-text option (no layout break at 150 percent); contrast of at least 4.5 to 1, **enforced by a test over every token pair** of every app and mode; a reduce-motion option (shaking, fast transitions and flashing off; transitions at most the token's fast duration); a screen-reader label on every shared control; touch targets at least the token minimum.
- **Docs:** `docs/DESIGN_SYSTEM.md` (tokens, themes, how an app picks its theme and level, the widget list with when to use each, the art rules), template `docs/SPEC.md` updated, `design/README.md` updated if anything changes.

## Run discipline (the workflow stops a run after 100 turns, so work in small steps)
Commit and push each step that passes `dart format --set-exit-if-changed .`, `flutter analyze`, `flutter test` and the template scripts, and move the pin. Suggested order: (1) tokens loader and theme builder with the contrast test, (2) generator copying the design files and `pubspec`, `LICENSES.md` rows, (3) SVG widget and the shared widgets in small groups with tests, (4) move the existing screens, (5) theme gallery, docs. If low on turns, push what passes and comment exactly what is done and what remains. The `@claude` token cannot push `.github/workflows` files; put any workflow YAML in your final comment.

## Acceptance
All template checks pass. Tests: every theme builds for every app and mode; the contrast test passes for every token pair; Nunito and Plus Jakarta Sans load with the right weights; each shared widget builds in every theme; no layout overflow at 150 percent text on the existing screens and the gallery; screen-reader labels present; reduce motion honoured; the generator test for a Craft, a Mind and the plain profile copies the right design files and passes the licence check; no person-like icon or image in the design files.

## Out of scope
The mode system, the Game and Study tabs and screens, the parent lock, the "try next" logic, mastery calculation (2B); real minigames; real AdMob IDs.
