# [change] factory: design system, per-app themes and Game or Study mode

**Repo:** game-factory.

## Goal
One design system with per-app theme tokens, and the mode system for the Craft apps.

## Scope
- Theme tokens (colours, type, art style, corner radius, motion) per app; two layout levels (younger and older) for Scout and Ranger; mature styling for Champion; adult styling for Mind.
- Mode system: Game mode and Study mode. Default Game mode on first launch; remembered afterwards; pages, colours and navigation respond to the mode.
- Mode toggle in the top bar, always visible. Optional parent lock behind the parent gate that fixes the mode; a lock icon shows while locked. Local settings only.
- Study mode: topics by school year, progress per topic, a "revise mistakes" list, a simple daily goal, untimed practice with explanations.
- Test IDs for the toggle, lock and every new screen in `lib/ui/test_ids.dart`.
- Accessibility in the shared widgets: text follows the phone's size setting plus a large-text option (no layout break at 150 percent); contrast of at least 4.5 to 1; a reduce-motion option that turns off shaking, fast transitions and flashing; a screen-reader label on every shared control.

## Acceptance
Checks pass; widget tests cover mode persistence, lock behaviour and theme switching.
