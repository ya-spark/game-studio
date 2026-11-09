# [new-game] Mind Presto Games (fast casual hub)

**Repo:** ya-spark/game-mind-9   **Package:** com.activemindcraft.mindpresto   **Audience:** Adults

## Goal
Generate the app from the template with the shared engine, then build the launch minigames and starter content.

## Scope
- Fast, energetic look. A hub with one shared coin balance; each minigame defines its own coin sinks.
- Launch minigames: snake, brick breaker, stack tower, runner, balloon pop. Wingy joins later through the module conversion (issue 08).
- No study content; no brain-health or medical claims in store text.
- Ads and purchases: **banner plus an optional rewarded ad for Continue; no interstitials**; the banner shows only before and after a game, never during play. One Remove Ads for the hub; coin packs; coins earned in play and bought. Games are free-with-ads or coin-locked. Optional Play Games sign-in.
- Never commit secrets. Test ad IDs only until the owner supplies real IDs. Assets listed in `assets/LICENSES.md`.
- `docs/SPEC.md` in the repo is the source of truth for behaviour; write it in the first commit.

## CI
The generated repo skips CI until the owner sets the repository variable `CI_ENABLED=true`. Set it after the first working build so the full checks run on GitHub.

## Needs from the owner
AdMob app and ad unit IDs, Play Console setup, spec approval, official name checks.
