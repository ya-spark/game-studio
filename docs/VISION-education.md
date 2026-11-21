# Vision: an education platform where games are the medium

Owner, 2026-11-21. Supersedes the emphasis (not the facts) of `docs/PLAN-new-apps.md`. Facts about apps, money and ads stay in `docs/DECISIONS.md`.

## 1. Why the studio exists
To teach. Games are the way a learner meets the content: shoot the right answer, eat a series in order, match pairs. Fun is the delivery, learning is the product. Every feature is judged by whether it helps someone learn or keep learning.

- **Craft Scout / Ranger / Champion**: school learning by stage (maths and English first).
- **Mind Ember / Presto**: keeping the mind sharp for adults (memory, attention, logic, mental maths, words). Wording: "exercise", "practise", "challenge". Never claim to prevent decline, treat or cure anything.

## 2. Architecture: content and games are modules joined by a format contract
The content module and the game modules never know each other. They meet only at the **question format**.

- **Formats are a closed, versioned set.** Each has one data schema and one result shape (correct, time, attempts). Adding a format is a deliberate change in the shared engine.
- **A game declares the formats it can play** (`MiniGame.itemTypes`) and the smallest pool it needs (`minPool`). It holds no content.
- **A topic provides the formats it has items for** (not necessarily all).
- **Matching is a lookup:** games offered for a topic = games whose `itemTypes` overlap the topic's open items and whose `minPool` is met. Already implemented in `play_tab.dart`.
- **Fun score and knowledge score stay separate.** A child who loses snake by bad steering is not recorded as having got the series wrong; only the answer counts as evidence.

Already built (checked 2026-11-21, `lib/engine/` is identical in all five apps): the seven formats, the `MiniGame` interface with `itemTypes`, `minPool`, modes, year range and access, per-app `game_registry.dart`, the validator, and standalone (no-item) games for the Mind hubs.

## 3. The formats (as in the code)
| Format (`ItemType`) | Shape |
|---|---|
| `mcq` | prompt and options, one correct (true or false is an `mcq`) |
| `series` | ordered list with the missing or next element |
| `pairs` | matching left and right sets |
| `category` | items and the buckets they belong in |
| `word` | target word, hint, letters |
| `numeric` | typed or built number answer |
| `cloze` | sentence with a blank |

**Constraints on each format** (limits every game can rely on, and per-game limits the matcher checks): `docs/FORMAT-CONSTRAINTS.md`.

## 4. Which game supports which format (from the code, 2026-11-21)
| Game | mcq | series | pairs | category | word | numeric | cloze | Pool | Year gate (Scout) |
|---|---|---|---|---|---|---|---|---|---|
| Quick quiz | x | | | | | | | 4 | all |
| Door runner | x | | | | | | | 4 | all |
| Balloon pop | x | | | | | x | | 4 | all |
| Tug of war | x | | | | | | | 4 | Y3-6 |
| True or false | x | | | | | | | 4 | all |
| Cloze and grammar fix | x | | | | | | x | 4 | all |
| Series builder | | x | | | | | | 3 | all |
| Memory match | | | x | | | | | 3 | all |
| Sort into bins | | | | x | | | | 3 | all |
| Word builder | | | | | x | | x | 3 | all |
| Word search and crossword | | | | | x | | | 4 | Y3-6 |
| Equation builder | | | | | | x | | 4 | Y3-6 |
| Flash review | x | x | x | x | x | x | x | 4 | all |

- Games per format: mcq 7, numeric 3, word 3, cloze 3, series 2, pairs 2, category 2. Series, pairs and category each have one real game plus Flash review.
- Champion has a subset (no Door runner, Balloon pop, Memory match, Sort into bins or Word builder); Ranger has all; see each `game_registry.dart`.
- Mind hubs: Block Puzzle, Blockfall, Sudoku, Solitaire, Ball sort, Mahjong, Merge (Ember) and Wingy, Snake, Brick breaker, Stack tower, Runner (Presto) are standalone: no items, no format, they report only a score.

## 5. Content per format (content repo, 2026-11-21)
mcq 1613, numeric 778, series 185, pairs 168, category 149, word 97, cloze 50.
`word` and `cloze` are thin; `series`, `pairs` and `category` are modest. A topic's usable games follow its formats, so authoring should choose formats on purpose (a patterns topic wants `series`, a vocabulary topic wants `word` and `pairs`).

## 6. Gaps found (the work this vision asks for)
1. **No shooter and no snake-for-series.** Snake exists only as a standalone Mind game with no items. Both are the owner's headline examples: shooter (`mcq`, `category`), snake (`series`, `word`, `numeric`).
2. **Quick quiz and Study mode only play `mcq`.** `study_tab.dart` and `child_report.dart` use `quickQuizGame.itemTypes`, so pairs, series, category, word, numeric and cloze items are not reachable in Study except through Flash review. Study mode should cover every format.
3. **No skill map.** Items carry subject, year, topic and difficulty, but not a skill, so the app cannot say what a child has mastered or what to offer next.
4. **No learning loop beyond the mistakes notebook.** Needed: placement, next-skill choice, spaced revision (1, 3, 7 days), mastery per skill.
5. **Mind hubs have no skill or learning contract.** Standalone games need a second, small contract: a declared skill (memory, attention, logic, spatial, speed, maths, words), a score, a difficulty level. A daily workout and per-skill trend (on the device) sit on top. Where Craft mechanics fit adults (shooter, snake, memory match with maths, series and word items), the hubs reuse them.
6. **Limits are loose and hidden.** The validator mostly sets minimums, and each game quietly skips items it cannot play, so a game can appear with a pool it cannot play. Fix: an envelope the validator enforces plus per-game limits the matcher checks (`docs/FORMAT-CONSTRAINTS.md`).
7. **Thin formats in content:** `word` and `cloze` need more items before more games are built on them.

## 7. Order of work
1. Skill trail in the content model (skills per topic, prerequisites, `skill` on every item), mastery states and the advance rule (section 8).
2. Study mode and reports play every format.
3. Manifest limits (options, series length, words per round) checked by the matcher.
4. New mechanics against the contract: shooter, then snake for series.
5. Revision loop (spaced review of mistakes and weak skills).
6. Mind hubs: skill contract, daily workout, per-skill trend; reuse the Craft mechanics where they fit.
7. More `word`, `cloze`, `series`, `pairs` and `category` content, then resume #148 so content lands on skills.

First release scope: prove the loop in **Scout**, then copy it to Ranger and Champion, then to the Mind hubs (owner to confirm).

## 8. The skill trail (owner direction 2026-11-21; name and numbers are proposals)
Skill progress is the objective; games are the interface to it. The learner sees a **trail** (working name; other options: Path, Ladder, Climb, Journey; each app may theme the word), not a list of games.

- **Structure:** year, topic, skill (a rung). Topics and their order exist in `topics.yaml`; a skill is a finer, ordered step inside a topic with prerequisites (usually the rung before, may cross topics or years). Items carry a `skill`. A rung is playable when its open items cover a format with enough items.
- **Evidence:** a game gets a round of items for one skill (plus a few revision items) and returns per-item results. Only those results move a skill; the game's own score never does.
- **States:** locked, new, practising, secure, mastered. Stars on the trail are progress, never spent.
- **Advance rule (proposal):** 80% or more over the last 10 items on at least 2 different days gives secure; a pass in a second format gives mastered. Mastered skills decay and return in spaced revision (1, 3, 7 days).
- **Choosing the next step:** Auto (default; the first unlocked, not-yet-secure rung plus revision; the engine also picks a fitting, recently unplayed, free or unlocked game); Pick a skill (any unlocked rung); Pick a game (the engine chooses the rung that game serves best; the old behaviour, now secondary); Skip ahead (a short check on a locked rung; passing unlocks it and the rungs below, which also gives placement and catch-up). A parent can lock the app to Auto behind the parent gate.
- **Mind hubs:** the same trail with cognitive skills and difficulty levels instead of years (for example Pattern memory, levels 1 to 8). A standalone game reports skill, level and score; a level passes at a threshold; the daily workout is Auto across several skills.
- **App changes:** home shows the trail first; the Play tab picks a skill, then a game; the C5 Study map and `lib/engine/content/topic_map.dart` are the starting point (not yet checked for how close they are).
- **Decided (owner, 2026-11-21):** a child **may jump into locked rungs** through the skip-ahead check; thresholds are by the recommendation below.
- **Thresholds (owner delegated, recommendation adopted):** "secure" needs, over a window of the latest items, a minimum accuracy on at least 2 different days: Scout last 8 items at 75% or more, Ranger last 10 at 80%, Champion last 10 at 85%. "Mastered" needs a pass in a second format plus one revision pass at least 3 days later (all apps). Anti-luck rules for all apps: a 2-option `mcq` (true or false) counts as half an item; a hint counts as wrong; a timeout counts as wrong except in Scout (never penalised); a window needs at least 6 items; mastered skills not revised for several weeks fall back to secure.
- **Skip-ahead check:** 5 items of the skill (non-guessable where possible: `mcq` with 3 or more options, or other formats), 4 correct to pass. A pass unlocks that rung and marks its prerequisites "secure by check" (shown as such, still revised later). A fail has no penalty beyond a short wait before trying that rung again; normal practice stays open. First launch may run a few checks across the year as placement.
- **Curriculum alignment stays invisible (owner, 2026-11-21):** skills and topics are aligned to the Australian curriculum internally, but nothing public mentions it. The mapping from skill id to curriculum reference lives only in the private content repo and never ships in a pack, catalogue, app, the website, the web catalog, store text or privacy pages. Words to avoid in anything a user can see: Australia or Australian, curriculum, strand, syllabus names, and curriculum codes. Skill and topic names are original wording. Code-level labels users never see (`lang="en-AU"` in the page source, `lang: en-AU` in packs) are fine and stay (owner, 2026-11-21).
- **English content follows Australian English (owner, 2026-11-21), as maths does:** Australian spelling (colour, organise, practise as the verb), Australian vocabulary and usage (rubber not eraser, rubbish not trash, lollies not candy, holidays not vacation, football and soccer both fine), Australian punctuation and date style, and English topics and skills aligned internally to the Australian curriculum for English (same invisibility rule as above). Already in place: `lib/engine/content/spelling.dart` warns on common US spellings (warnings only). Checked 2026-11-21: the packs are almost clean (cancelled, travelling already Australian); one vocabulary item to review (`eraser` in a length-sorting pack). Not yet covered: a US-to-Australian **vocabulary** list beside the spelling list, and the owner's review of English items before release (already required).
- **Name: Constellation** (owner, 2026-11-21, as in the mock; each topic a small constellation, each rung a star). One shared component. It shows skill progress, never game progress: on the web one Constellation for all web games, in the apps one per app (Scout, Ranger, Champion, new apps), not shared between them (owner, 2:56 PM AEDT). Internal name `trail`. Earlier options, kept for the record: Options: Trail, Path, Stepping stones, Journey, Voyage, Expedition, Climb, Summit, Constellation, Garden, Quest line, Roadmap. Recommendation: one shared screen, shown as Scout "Path", Ranger "Trail", Champion "Climb", Mind "Journey"; Constellation if a distinctive look is wanted. No trademark or Play Store check done on these words.

## 8a. Built so far (2026-11-21, IDE session; not pushed)
Skills and the trail (T2, T3, T5), game limits (T4), Shooter and Snake (T6), Mind skills and the workout (T7) exist in the template and the five apps. First skill ladder is mechanical (three rungs per topic by release order), to be reviewed and refined. See `docs/FEATURE-SPECS.md` for what is and is not built.

## 9. On hold until the loop exists
W2 / W2.1 landing page redesign (RELEASED by the owner 2026-11-21: it continues, Learn first), X2 AdSense, and any new standalone Mind game that has no skill. Web catalog and store work continue only where they already run.
