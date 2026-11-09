# [change] factory: reading aloud, ad placements and compliance profiles (issue 1 of 6: 1C2)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** 1C1. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first. Part 2 of 3 of the original 1C.

## Goal
Spoken questions, the ads rules, and settings that make an app child-safe or adult, with CI checks that reject unsafe combinations.

## Decisions already made (owner, 2026-11-09)
- Reading aloud: the prompt and the options with a speaker button, automatic in Scout's younger level, explanations on request; recorded audio first, text-to-speech as the fallback.
- **Ads:** no interstitials anywhere. Craft apps (child and teen profiles): banner only, no rewarded ads. Mind hubs (adult profile): banner plus an optional rewarded ad for Continue. The banner shows only **before and after a game** (menu, start and results screens), never during play.
- Three compliance profiles: child (Scout, Ranger), teen (Champion), adult (Mind).

## Scope
- **Reading aloud:** a `SpeechService` interface (`speak`, `stop`, `isAvailable`) with a text-to-speech implementation (vendor package pinned exactly, imported only in that file; `en-AU` preferred). A recorded `audio` file is used when an item has one. A speaker button reads the prompt and the options; `speech.auto_read` (config, set per level by each app) reads automatically; explanations on request. Add it to the Quick quiz. Test IDs and screen-reader labels.
- **Ads service:** placements `menu`, `pre_game` and `post_game` only; there is no in-play placement. `interstitials_enabled` is false in every profile. Rewarded ads exist only in the adult profile.
- **Compliance profiles** in `app.config.yaml`: `audience: child | teen | adult`. Defaults:
  - `child` (Scout, Ranger) and `teen` (Champion): child-directed ads, banner only, no rewarded ads, parent gate on every real-money purchase and on coin spends for games; `child` has no Play Games sign-in, `teen` allows optional sign-in.
  - `adult` (Mind): banner plus rewarded Continue, optional Play Games sign-in, no parent gate.
  - The ads service applies child-directed treatment and a restrictive content rating when the profile asks for it.
- **Checks:** `scripts/profile_check.sh` (with a self-test, like `ad_safety_check.sh`) and an extended `ad_safety_check.sh` fail on unsafe combinations, for example any interstitial, rewarded ads in a `child` or `teen` app, sign-in in a `child` app, or a missing parent gate. Add both to the template's own CI steps through the instructions below.
- **Docs:** `docs/ENGINE.md` (profiles and ad rules), the template `docs/SPEC.md`.

## Note on workflow files
The `@claude` token cannot push `.github/workflows` files. For the new check steps, put the exact YAML in your final comment and the owner will add it.

## Run discipline (the workflow stops a run after 100 turns, so work in small steps)
Do the work in small steps. After each step whose checks pass, commit and push it to `main` (and move the pin) so nothing is lost. If you are running low on turns, push what passes, then comment exactly what is done and what remains, so the owner can post the rest as a new issue.

## Acceptance
All template checks pass. Tests: reading aloud (recorded audio first, text-to-speech fallback, auto-read flag), ad placements (no in-play placement, no interstitial), profile gating, `profile_check.sh` accepting good and rejecting bad configs, the extended ad check.

## Out of scope
The generator, CI guard and engine sync (1C3); the design system (issue 2); real AdMob IDs.
