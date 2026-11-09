# Plan: five new apps (Craft learning apps and Mind casual hubs)

Status: planning document (owner, 2026-11-09). Decisions that are settled also live in `docs/DECISIONS.md`.
Nothing here is implemented. The issue drafts are in `docs/issue-drafts/` and are not posted.

## 1. The five apps

| App (Play Store name) | Audience | Repo | Package | Id |
|---|---|---|---|---|
| Craft Scout Games | Foundation to Year 6, about 5-12 | `ya-spark/game-craft-lowteen` | `com.activemindcraft.craftscout` | `craft_lowteen` |
| Craft Ranger Games | Years 7-10, includes under-13s | `ya-spark/game-craft-preteen` | `com.activemindcraft.craftranger` | `craft_preteen` |
| Craft Champion Games | Years 11-12 (senior secondary), about 16-18 | `ya-spark/game-craft_highteen` | `com.activemindcraft.craftchampion` | `craft_highteen` |
| Mind Ember Games | Adults, calm puzzle and block games | `ya-spark/game-mind-1` | `com.activemindcraft.mindember` | `mind_1` |
| Mind Zip Games | Adults, fast casual games | `ya-spark/game-mind-9` | `com.activemindcraft.mindzip` | `mind_9` |

- The Scout, Ranger, Champion, Ember and Zip names are used only on Google Play. Repos, registry ids and code use the internal names above.
- Names are provisional until the official USPTO, national-register, Play Store and domain checks pass. Known risk: a MindZip flashcard learning app exists
  (fallbacks for the fast hub: Mind Clip, Mind Dart). Package names are permanent once uploaded to Play.
- The studio website is `ya-spark/activemindcraft-website` (private, static, deployed later by the owner on a Hostinger VPS behind Caddy).
- All five apps are built together on one shared engine and design system (same UI principles and styling), with per-app colours and vibe.

## 2. Settings by app

| | Scout | Ranger | Champion | Mind Ember / Mind Zip |
|---|---|---|---|---|
| Play audience | Child-directed (Families policy) | Child-directed (includes under-13s) | Teens, child-safe ads by choice | Adults (18+) |
| Ads | Child-safe network, banner (menu only) and rewarded | Same | Same | Same as the existing games: banner on menu, paced interstitials, optional rewarded |
| Interstitials | None | None | None | Yes, paced as in the existing games |
| Remove Ads | One-time, parent gate | Same | Same | One per hub |
| Coin packs | Yes, parent gate | Yes | Yes | Yes |
| Play Games sign-in | None | None | Optional | Optional |
| Interface levels | Two (about 5-8 and 9-12) | Two (Years 7-8 and 9-10) | One | One |
| Study content | Maths and English | Maths and English | Maths and English | None |

Existing pattern reused (from Block Puzzle, Blockfall, Wingy): banner on Home only; interstitial after game over (every 2nd, at least 90 s apart, max 6 per session,
none in the first 60 s); rewarded ads always optional; `remove_ads_all` removes all ads; coins earned in play, daily reward, streaks and challenges; coin packs 500, 1500
and 4000 as consumables; a parent gate ("Ask a grown-up") before every real-money purchase; spending coins needs no gate.

## 3. Money model

| Item | How it works |
|---|---|
| Built-in content | Partly open. A small part opens each day (10 items per subject at the start, then 2 per subject per day, only when every open item has been passed). |
| Full Unlock | One non-consumable per app, behind the parent gate. Opens all built-in content and its updates at once. |
| Extra packs | Each has a free **preview** (a parent downloads it without charge; what it holds depends on the pack) and a **full** part, bought once per pack behind the parent gate. |
| Game extras (Continue, power-ups, skins) | Coins |
| Coins | Earned in play and study; coin packs for sale behind the parent gate, as in the existing games |
| Remove Ads | One-time purchase |

- Coins never buy learning content, and no real-money purchase is converted into content through coins (avoids hidden pricing in children's apps).
- The year level is chosen at first launch by a parent; the daily release follows it. Items stay open once opened. Wording never pressures children.
- No backend means the server cannot check who paid. Unlocks are decided on the device after Play Billing confirms the purchase. The full part of an extra pack is downloaded only after the purchase.

## 4. Shared engine (vendored, mostly reused from game-factory)

Already in the template: service interfaces, ads pacing, `products.yaml`, coins, daily reward, streaks, challenges, parent gate. New work lives in a self-contained `lib/engine/` that the generator
copies into each game; `scripts/sync_engine.py` and a CI drift check keep the copies identical to the factory (it can be turned into packages later).
- Content model, validator and authoring tool (issue 1A); delivery, daily release, Full Unlock and extra packs (1B); minigame framework, compliance profiles, generator (1C).
- Mode system and design system with per-app theme tokens and two layout levels for Scout and Ranger (issue 2).
Factory rules apply: no backend, vendor SDKs only behind the service interfaces, pure-Dart rules, test IDs on every interactive widget, test ad IDs only until the owner supplies real ones.

## 5. Content

- Subjects: maths and English first, for all three Craft apps. A few hundred items per app, tagged by school year (Scout: Foundation to Year 6; Ranger: Years 7-10; Champion: Years 11-12), topic and difficulty.
- Written to be aligned with the Australian curriculum, but the curriculum is never mentioned in the apps, store listings or policies. Original items only, language `en-AU`, no copied textbook or test content.
- Item types: multiple choice (including true or false), ordered series, pairs, word with hint, category items.
- Built-in starter packs ship inside each app. Extra packs and updates come from `https://content.activemindcraft.com/v1/` (static files, one index per app, versioned immutable pack files, hash checks, offline cache).
- Signing is optional until the owner adds a key: the app accepts an unsigned index while no public key is set; once a key is set a valid Ed25519 signature is required (no downgrade, no rollback). The owner creates a separate
  signing key (not the Android upload keystore) and never shares the private key.
- Maths answers are checked by automated validators. English items need owner review before release.

## 6. Craft apps: Game mode and Study mode

| | Game mode | Study mode |
|---|---|---|
| Purpose | Fun first, learning inside the games | Learning first, practice and revision |
| Home screen | Minigames, daily challenges, coins | Topics by school year, progress, revision list |
| Questions | In minigames, timers on older levels | Untimed practice, explanations |
| Rewards | Coins, streaks, Continue | Progress stars and mastery, small coin bonus |
| Look | Colourful and playful | Calm and clean |

- Default on first launch: Game mode. After that the app remembers the last mode and opens in it; pages, colours and navigation respond to the mode.
- A toggle in the top bar, always visible. An optional parent lock (behind the parent gate) fixes the app to Study or Game mode; a lock icon shows while locked. Both are local settings, no account.
- Study mode contents: progress per topic, a "revise mistakes" list and a simple daily goal.

## 7. Minigames (proposal, to be trimmed for the first release)

- Scout: door runner, balloon pop, memory match, sort into bins, series builder, word builder (younger level uses pictures and voice, no timer; older level uses text and gentle timers).
- Ranger: door runner, series builder, tug-of-war quiz, word search and crossword, equation builder, sort into bins, true or false.
- Champion: door runner, tug-of-war quiz, series builder, equation builder, cloze and grammar fix, flash review, true or false. Mature art and sound.
- Mind Ember: Block Puzzle, Blockfall, Sudoku, Solitaire, ball sort, mahjong, merge.
- Mind Zip: Wingy, snake, brick breaker, stack tower, runner, balloon pop.
- Each minigame defines its own coin sinks (Continue, hints, skips, power-ups); a hub or app shares one coin balance.

## 8. Build order

1. Shared core: content format, loader, modes, theming, ads and coin wiring.
2. Craft apps together, starting with the minigames they share.
3. Mind hubs with the new casual games.
4. Convert Block Puzzle, Blockfall and Wingy into modules and add them to the hubs. The three standalone apps stay.
5. Store listings, privacy policies, content ratings, then the internal testing track. Production always needs the owner.

## 9. Owner tasks

- AdMob: create 5 apps and 12 ad units and send the IDs. Craft apps: banner and rewarded only (set child-directed treatment). Mind apps: banner, interstitial and rewarded.
  Claude has no AdMob access and credentials are never shared; ad unit IDs are not secrets. Test IDs only until then.
- Play Console: create the apps; complete Data safety, content rating and target-audience declarations (Scout and Ranger are child-directed).
- Run the official trademark and Play Store checks on the five final names; check domains.
- Review English content for accuracy.
- Set up the content server on the Hostinger VPS (static files only) and hold the content signing keys.

## 10. Open points

- Which minigames to cut from the first release.
- Final price points for Full Unlock and extra packs, and the exact numbers for the daily release (defaults above).
- Whether Champion later gets more subjects (maths and English only at launch).
- Whether the Mind apps later get paid extras beyond Remove Ads and coin packs.
