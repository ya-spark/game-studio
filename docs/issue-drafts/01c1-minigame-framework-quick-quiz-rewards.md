# [change] factory: minigame framework, Quick quiz, stars and coins, game access (issue 1 of 6: 1C1)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 1A (#90) and 1B (#91), done; factory CI green on `ec8b9f6`. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first (the "later decisions" parts win). Part 1 of 3 of the original 1C (1C2 and 1C3 follow).

## Goal
A standard way to plug minigames into the content, the reward rules, and the free or coin-locked access rule.

## Decisions already made (owner, 2026-11-09)
- **Craft rewards:** a child earns **stars** (1 per item passed the first time, bonus stars for finishing a topic and for a daily streak); stars are progress only and never spent. **Coins** are bought by a parent plus a small earned trickle: finishing a topic, a daily streak milestone, a daily learning goal and a weekly goal, capped at **60 coins a week per child**. Learning content is never bought with coins.
- **Mind hubs:** coins earned in play and bought in packs, as in the existing games. No stars.
- **Game access:** each minigame is `free_with_ads` or `coins` (a permanent unlock). Quick quiz and Study mode are always free. Coin-locked games cost 200 coins in Craft apps and 300 in Mind hubs; avatars 40, colour themes 60, streak freeze 100; coin packs stay 500, 1500 and 4000.
- The reference quiz ships as a plain "Quick quiz" minigame in all three Craft apps.
- An empty `AiTutorService` interface, off by default. No AI feature ships.

## Scope
- **Minigame framework** (`lib/engine/minigames/`):
  - `MiniGame` interface: `id`, `title`, supported item types, `minPool`, supported modes, `access` (`free_with_ads` or `coins`) and `coinPrice`, `build`.
  - `QuizSession`: supplies items from the selector, records each answer and pass per child, awards stars, reports progress, so every minigame scores the same way. Use the `ReleaseEngine` and minimum-pool check from 1B.
  - A per-app registry chooses which minigames appear, in which mode and at which level, and applies the access rule (a locked game shows its coin price; spending coins to unlock is permanent and saved per device).
- **Rewards** (config `rewards`): `stars.per_first_pass: 1`, `stars.topic_bonus`, `stars.streak_bonus`; `coins.weekly_cap_per_child: 60` with the earning events above (each milestone pays once). The template's daily reward and daily challenges give stars and capped coins in the Craft apps and stay coin earners in the Mind hubs.
- **Quick quiz:** a plain multiple-choice (and true or false) minigame that works in Game and Study mode, shows the explanation after each answer, records passes and awards stars. Test IDs, screen-reader labels, no break at 150 percent text, contrast at least 4.5 to 1.
- **AiTutorService:** `lib/engine/ai/` holds an interface (`isAvailable`, `explain`) and a `NoAiTutorService`; `ai.enabled: false`. No vendor code.
- **Docs:** `docs/ENGINE.md` (the framework, rewards and access rules).

## Run discipline (the workflow stops a run after 100 turns, so work in small steps)
Do the work in small steps. After each step whose checks pass, commit and push it to `main` (and move the pin) so nothing is lost. If you are running low on turns, push what passes, then comment exactly what is done and what remains, so the owner can post the rest as a new issue.

## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` and the safety scripts pass. Tests: framework scoring, star rules (first pass only, topic and streak bonuses), the weekly coin cap per child, access rules (free and coin-locked games, permanent unlock), minimum-pool gating, Quick quiz in both modes, `NoAiTutorService`.

## Out of scope
Reading aloud, ads placements and compliance profiles (1C2); the generator, CI guard and engine sync (1C3); the design system (issue 2); the real minigames (M1 to M3).
