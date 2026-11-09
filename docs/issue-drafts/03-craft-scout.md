# [new-game] Craft Scout Games (Foundation to Year 6)

**Repo:** ya-spark/game-craft-lowteen   **Package:** com.activemindcraft.craftscout   **Id:** craft_lowteen   **Audience:** Foundation to Year 6, about 5-12; child-directed. **Depends on:** 1C, 1D, issue 2, M1 to M3.

## Goal
Generate the app with `--profile craft --audience child`, wire in the engine, theme, minigames and starter content, and make it ready for the owner's first build.

## Scope
- Two interface levels (about 5-8, Foundation to Year 2; and 9-12, Years 3 to 6) set from the child's year level. Younger level: pictures and voice, no timers, reading aloud automatic.
- Game mode (default) and Study mode with the top-bar toggle, the bottom bar for each mode and the optional parent lock.
- Minigames: Quick quiz, door runner, balloon pop, memory match, sort into bins, series builder, word builder. Quick quiz and Study mode are always free. For the others, each is set to `free_with_ads` or `coins`; the owner decides which (default proposal: door runner and memory match free-with-ads, the rest unlockable with coins) and proposes prices during this issue's planning.
- Rewards: stars for first passes, bonus stars for topics and streaks; coins bought by a parent plus the earned trickle (up to 60 a week per child). The shop sells avatars, colours and the coin-locked minigames for coins. Learning content is bought with real money (Full Unlock and extra packs).
- Daily challenges and a weekly goal are learning goals (pass N items, finish a topic, answer in a row) that pay stars and a few coins.
- Ads: child-safe network, **banner only**, shown before and after a game, never during play. No interstitials, no rewarded ads. Remove Ads (one per app) behind the parent gate.
- Starter content comes from the `game-content` repo (issues C1 to C7); the app ships a built-in set and loads updates from the content server.
- Never commit secrets. Test ad IDs only until the owner supplies real IDs. Assets listed in `assets/LICENSES.md`.
- `docs/SPEC.md` in the repo is the source of truth for behaviour; write it in the first commit.

## CI
The generated repo skips CI until the owner sets the repository variable `CI_ENABLED=true`. Set it after the first working build so the full checks run on GitHub.

## Needs from the owner
AdMob app and banner unit ID, Play Console setup and child-directed declarations, spec approval, price decisions for coin-locked games, official name checks.
