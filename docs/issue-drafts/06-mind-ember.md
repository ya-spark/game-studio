# [new-game] Mind Ember Games (calm puzzle and block hub)

**Repo:** ya-spark/game-mind-1   **Package:** com.activemindcraft.mindember   **Audience:** Adults

## Goal
Generate the app from the template with the shared engine, then build the launch minigames and starter content.

## Scope
- Calm, warm look. A hub with one shared coin balance; each minigame defines its own coin sinks (Continue, hints, power-ups).
- Launch minigames: Sudoku, Solitaire, ball sort, mahjong tile match, merge. Block Puzzle and Blockfall join later through the module conversion (issue 08).
- No study content; no brain-health or medical claims in store text.
- Ads and purchases: same ads as the existing games (banner on menu, paced interstitials, optional rewarded); one Remove Ads for the hub; coin packs; optional Play Games sign-in
- Never commit secrets. Test ad IDs only until the owner supplies real IDs. Assets listed in `assets/LICENSES.md`.
- `docs/SPEC.md` in the repo is the source of truth for behaviour; write it in the first commit.

## Needs from the owner
AdMob app and ad unit IDs, Play Console setup, spec approval, official name checks.
