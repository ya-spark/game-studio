# [new-game] Craft Ranger Games (Years 7-10)

**Repo:** ya-spark/game-craft-preteen   **Package:** com.activemindcraft.craftranger   **Audience:** Years 7-10, includes under-13s; child-directed

## Goal
Generate the app from the template with the shared engine, then build the launch minigames and starter content.

## Scope
- Two interface levels (Years 7-8 and Years 9-10), mature enough for a 15-year-old while keeping the child-safe technical settings.
- Game mode (default) and Study mode with a top-bar toggle and optional parent lock.
- Minigames: door runner, series builder, tug-of-war quiz, word search and crossword, equation builder, sort into bins, true or false.
- Starter content: maths and English for Years 7-10, a few hundred items, original, Australian spelling, the curriculum never mentioned.
- Ads and purchases: child-safe network, **banner only**, shown before and after a game and never during play; no interstitials and no rewarded ads. Remove Ads (one per app) and coin packs behind the parent gate. Rewards: stars for first passes, coins bought plus a capped earned trickle (up to 60 a week per child); learning content is bought with real money. Games are free-with-ads or coin-locked; Quick quiz and Study mode are always free. No Play Games sign-in.
- Never commit secrets. Test ad IDs only until the owner supplies real IDs. Assets listed in `assets/LICENSES.md`.
- `docs/SPEC.md` in the repo is the source of truth for behaviour; write it in the first commit.

## CI
The generated repo skips CI until the owner sets the repository variable `CI_ENABLED=true`. Set it after the first working build so the full checks run on GitHub.

## Needs from the owner
AdMob app and ad unit IDs, Play Console setup, spec approval, official name checks.
