# R2 layout and Controls page: Figma prompt (owner runs it, hands the result back)

The Figma tool limit was reached on 21 Nov 2026 (11:12 PM AEDT). A blank file exists: https://www.figma.com/design/O1hF5d9ZMXKNsmIahhzLd8 ("R2 game frame, ad rail and Controls page"). Paste the prompt below into Figma (AI, Make or First Draft), then send the file link or screenshots back. Flutter code follows the result.

## Prompt

Design one board "R2 layout" for a family of small casual browser and phone games. Dark navy theme: page #12172F, panels #1F264D, game stage #292F66, text #F5F7FF, muted text #A8B5E0, accent amber #FFC740, second-player green #59CC9E, key-cap fill #4D5C9E with a #5966A6 outline. Font Nunito (Bold for labels). Rounded corners 12 to 18. Friendly, big touch targets, high contrast. No title bar inside the game.

Make these frames side by side, each with a one-line caption above it:

1. **Desktop 1280 x 760 (width 1024 and up).** The game stage is centered, max width 780, height about 640, rounded 18. Inside the stage: a small overlay row at the top (left: "Esc Exit" and "Space Pause" as key-cap chips; right: "Score 120" in amber), a large play area (rounded, #1F264D, centered text "Game"), and under it a row of key hints as key-cap chips with a muted label each: "left right  move", "up  select", "1-4  answer". To the right of the stage, 24 px away, a dashed-outline ad placeholder 300 x 600 labelled "Ad 300 x 600 half page (right rail, never in play)".
2. **Tablet 800 x 760 (600 to 1023).** A dashed ad placeholder 728 x 90 labelled "Ad 728 x 90 leaderboard (top strip)" at the top, then the same stage centered below it (width about 680) with side margins.
3. **Phone 390 x 760 (below 600).** The stage fills the width (370), no ad in play, and at the very bottom a dashed ad placeholder 320 x 50 labelled "Ad 320 x 50 adaptive banner (menu and results only)".
4. **Settings > Controls page, 560 x 700.** Title "Controls", a muted line "Pick a row, press the new key. Two players? Player 2 uses the left side." A table with columns Action, Player 1, Player 2 (Player 2 header in green). Rows with key-cap chips: Move left (left arrow / A), Move right (right arrow / D), Select or zap (up arrow / W), Best choice or slow down (down arrow / S), Action (Enter / F), Pause (Space / Space), Question (Q / Q), Answer 1 to 4 (1 2 3 4 / Z X C V). Show ONE row in the "listening" state: amber outline and an amber chip "Press a key...". Bottom: amber button "Reset to defaults" and a secondary button "Done".
5. **Two players on one keyboard, 560 x 300 card.** Text: "Player 1: arrows + right side (Enter, K L ;). Player 2: W A S D + left side (F, Z X C V). Both sets stay inside one hand each: no reaching, no shared keys." plus two chip rows showing W A S D (P2 move) and the four arrows (P1 move).

Keep every element an editable layer (auto layout, text, rectangles), reuse one key-cap chip component everywhere, and name the layers like the captions.

## What the result feeds
- Game frame: `game_core` `GameFrame` (centered, max width, responsive breakpoints 600 / 1024, `rail` ad slot).
- Controls page: `game_core` key map (`GameKeyMap`, remap and save on the device) and a Controls screen used by every container's Settings.
