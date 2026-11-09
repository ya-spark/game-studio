# [new-game] Craft Champion Games (Years 11-12)

**Repo:** ya-spark/game-craft_highteen   **Package:** com.activemindcraft.craftchampion   **Audience:** Years 11-12 (senior secondary), about 16-18

## Goal
Generate the app from the template with the shared engine, then build the launch minigames and starter content.

## Scope
- One interface level with mature art and sound. Revision tools first.
- Game mode (default) and Study mode with a top-bar toggle and optional parent lock.
- Minigames: door runner, tug-of-war quiz, series builder, equation builder, cloze and grammar fix, flash review, true or false.
- Starter content: senior-secondary maths and English, a few hundred items, original, Australian spelling, the curriculum never mentioned.
- Ads and purchases: child-safe network, **banner only**, shown before and after a game and never during play; no interstitials and no rewarded ads. Remove Ads (one per app) and coin packs behind the parent gate. Rewards: stars for first passes, coins bought plus a capped earned trickle (up to 60 a week per child); learning content is bought with real money. Games are free-with-ads or coin-locked; Quick quiz and Study mode are always free. Optional Play Games sign-in.
- Games and access: **free with ads:** Quick quiz, equation builder, cloze and grammar fix, flash review, true or false. **Coin-locked (200 coins):** door runner, tug-of-war quiz. Shop: avatar 40 coins, colour theme 60, streak freeze 100; coin packs 500, 1500 and 4000.
- Never commit secrets. Test ad IDs only until the owner supplies real IDs. Assets listed in `assets/LICENSES.md`.
- `docs/SPEC.md` in the repo is the source of truth for behaviour; write it in the first commit.

## CI
The generated repo skips CI until the owner sets the repository variable `CI_ENABLED=true`. Set it after the first working build so the full checks run on GitHub.

## Needs from the owner
AdMob app and ad unit IDs, Play Console setup, spec approval, official name checks.
