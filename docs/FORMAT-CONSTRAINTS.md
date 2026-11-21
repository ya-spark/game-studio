# Question format constraints (proposal, owner direction 2026-11-21)

Why: a game can only support a format if it can rely on the shape of the items. Today the rules are loose (the validator mostly sets minimums: `mcq` at least 2 options, `pairs` at least 2, and so on) and each game quietly protects itself (`balloon_pop_rules`, `tug_of_war_rules` and `word_grid_rules` return null for items they cannot play). So a game can appear with a pool it cannot actually play. This file sets the limits in one place. The numbers are **proposals**: they are checked against the existing content (section 4) but not yet against each game's layout.

The format list and fields are in `docs/CONTENT_FORMAT.md` (in each app and the template). Formats and the game matrix are in `docs/VISION-education.md`.

## 1. Two tiers

1. **Format envelope** (section 2). Limits that apply to every item of a format. The validator enforces them as **errors**, so every game may rely on them without checking. Both universal games (Quick quiz and Flash review) must handle any item inside the envelope.
2. **Game limits** (section 3). A game may be stricter than the envelope, for layout or rules reasons. It declares them with the game, and the matcher offers it only items that fit. Items outside a game's limits still play in other games and in Study.

Rule of thumb: put a limit in the envelope only if every game can live with it; otherwise it is a game limit.

## 1a. Principle: the two sides must meet (owner, 2026-11-21)
Item limits and game limits are designed together so that **most items play in most games**. A game limit stricter than the envelope is the exception and needs a reason (a layout that cannot adapt). Before narrowing, a game first tries to adapt: wrap or shrink text, scroll, reduce decoys. Authors write to the shared **short band** (below) by default, so what they write plays almost everywhere.

**Size class.** Each item gets a derived class, computed by the tool (authors never set it):
- `short`: prompt at most 150 characters, `mcq` options at most 30, tiles (series steps, pair sides, category items) at most 24. Numbers, single words, short phrases.
- `long`: inside the envelope but beyond `short`: sentences, story steps, reading answers.

Action games (shooter, balloon pop, door runner, memory match) accept `short` only. Card-style games (tug of war, series builder, sort into bins, cloze fix, quick quiz, flash review, true or false) accept both. So a sentence-heavy English topic feeds the card games and a number or vocabulary topic feeds all of them.

**Measures** (shown by `content_cli pool`): per game, the share of items of its formats it accepts; per topic, how many games can play it. A game that rejects more than a quarter of the items of its formats must either adapt or say why.

## 2. The envelope (validator errors)

| Format | Constraint |
|---|---|
| All | `prompt` 1 to 300 characters (over 150 makes the item `long`); `explanation` 1 to 250; plain text only (no markup; emoji allowed as simple pictures, never people); no leading or trailing spaces; `difficulty` 1 to 5; at most one image, with `image_alt` of 1 to 120; text that is read aloud must be speakable (symbols such as ×, ÷ and = are allowed) |
| `mcq` | 2 to 4 options, all different, each 1 to 150 characters; **exactly one correct** (a multiple-answer question is not an `mcq`); true or false is the 2-option case |
| `series` | 3 to 8 steps, all different, each 1 to 80 characters; one unambiguous correct order |
| `pairs` | 3 to 6 pairs; every left different **and every right different**; each side 1 to 60 characters |
| `category` | 2 to 4 categories (each name 1 to 30 characters); 3 to 12 items (each 1 to 80), every item in exactly one category, every category has at least one item |
| `word` | `answer` is one word of letters only, 3 to 14 letters; `hint` 1 to 100; `letters` (if given) at most 20 and contains every letter of the answer |
| `numeric` | answer is an integer or decimal of at most 8 digits and 3 decimal places; `unit` at most 20 characters; an optional `expression` must equal the answer; typeable on a number pad (digits, `.`, `-`); `tolerance` 0 or more |
| `cloze` | 1 to 3 gaps; each gap has 1 to 6 accepted forms, each 1 to 20 characters; whole text at most 200 characters; every gap in the text has an entry and no entry is unused |

## 3. Game limits (proposed; confirm from each game's layout and code when its manifest is written)
Games take the envelope as far as they can. What they add beyond it is below. `short` and `any` are the size classes above.

| Game | Formats and limits beyond the envelope |
|---|---|
| Shooter (built) | `mcq` (single answer, 2 to 4 targets) and `category` (which group is this entry in), `short` only |
| Door runner | `mcq`, `short` only (doors carry the option text) |
| Balloon pop | `mcq` and `numeric`, `short` only (wrong balloons are made by the game) |
| Memory match | `pairs`, `short` only (card faces) |
| Tug of war, True or false, Cloze and grammar fix | `any` size class (cards); True or false: exactly 2 options |
| Series builder | `series`, `any` (draggable tiles that wrap) |
| Sort into bins | `category`, `any` |
| Word builder | `word` and `cloze`, `any` |
| Word search and crossword | `word` of 3 to 10 letters only (as in `word_grid_rules.dart` today); several words per round |
| Equation builder | `numeric` whose answer is a **whole number from 0 to 999** (644 of 778 numeric items today; the game builds its own solution from the target and does not use `expression`) |
| Flash review, Quick quiz | everything inside the envelope, `any` (Quick quiz today plays `mcq` only; see the gaps in the vision document) |

Limits can be a size (options, steps, pairs), a length (characters), a size class, or a required value range (a whole-number answer).

## 4. Existing content against the envelope (content repo, 2026-11-21)

| Format | Items | Observed | Outside the proposed envelope |
|---|---|---|---|
| `mcq` | 1,613 | 4 options in 1,500, 2 in 97, 3 in 16; none multi-correct; 348 have an option over 30 characters; 212 prompts over 100 | none (longest prompt is 262) |
| `series` | 185 | 3 to 7 steps; 97 have a step over 12 characters | none |
| `pairs` | 168 | 3 or 4 pairs | 1 item with a repeated right side |
| `category` | 149 | 2 or 3 categories; 3 to 6 items | 1 item with only 3 items; categories with a single item not yet counted |
| `word` | 97 | 3 to 14 letters, all letters only | 1 item of 14 letters |
| `numeric` | 778 | up to 6 digits, up to 3 decimals | none |
| `cloze` | 50 | 1 or 2 gaps | none |

So the envelope would reject only a handful of items (to fix, not to grandfather). Not yet measured: image counts, speakability, per-category counts, and the game limits in section 3 (for example how many `mcq` options are over 20 characters for the shooter).


### Fit to the `short` band (same data, 2026-11-21)
Share of items in the `short` class (prompt at most 150, options at most 30, tiles at most 24): `mcq` 77%, `series` 66%, `pairs` 68%, `category` 56%, `word` 99% (3 to 12 letters), `cloze` 100%, `numeric` 98% (only long prompts are over the band). A tighter band (options 20, tiles 8 to 14) would have cut `series` to 36% and `pairs` to 42%, so those numbers are too strict. The long items are mostly sentences in English topics (story steps, reading answers), which is why the two size classes exist. Action games therefore see roughly two thirds of the items of their formats, and the card games see all.

Authoring guidance that follows: write `short` items by default, and use `long` only where the topic is sentence-based.

## 5. How it is enforced

1. **One constants file** in the shared engine (`lib/engine/content/format_limits.dart`) holds the envelope. The validator, the CSV tool messages, the pool report and the game tests all read it. Changing a limit is a visible, reviewed change in one place.
2. **Validator:** envelope violations are errors, with a message that names the item, the field and the limit.
3. **Game limits in the manifest:** each `MiniGame` declares what it accepts (formats, size class, required fields; a predicate for the rare special case). The matcher, `minPool` and the pool report count only accepted items, so a game never appears with a pool it cannot play. The silent `return null` paths in the rules files become a safety net, not the filter.
4. **Contract test per game:** build items at the **minimum and maximum** of the game's accepted limits for each supported format (generated from the constants), and the game must build and finish a round. A game that cannot handle a limit it declares fails CI.
5. **Authoring feedback:** `content_cli pool` reports, per topic and skill, how many items each game accepts, so an author can see which games a topic can feed.
6. **Changes:** widening a limit is safe. Narrowing one needs a content fix first. A new format or a changed field shape is an engine version bump that the three Craft apps and the Mind hubs take together through `sync_engine.py`.

## 6a. Decided (owner delegated, recommendation adopted, 2026-11-21)
- **No `expression` rule (corrected 2026-11-21).** The first version required every maths `numeric` item to carry an `expression`, on the belief that Equation builder needs it. The code shows no game reads `expression` (it is only a validator cross-check) and Equation builder needs a whole-number answer from 0 to 999. 265 items lack an `expression` and almost none have a natural one, so the rule was dropped (owner, 2026-11-21): `expression` stays optional and is checked when present; Equation builder's limit is the whole-number answer.
- **One set of `short` thresholds for all apps** (prompt 150, options 30, tiles 24). Measured by school stage: Scout content (Years 0 to 6) is 89% `short`, Ranger (7 to 10) 72%, Champion (11 to 12) 64%, so Scout does not need a tighter band; the pool report shows each app's rate, and the thresholds can be revisited if a game rejects too much.
- **Envelope `mcq` stays at 2 to 4 options and exactly one correct answer.** A fifth option or a multiple-answer question would be a deliberate engine change (a new format for multiple answers).

## 6. Open points
- Confirm the section 3 numbers from the real layouts (phone and tablet, large text sizes) when each manifest is written.

## 7. Corrections after running the validator over all content (2026-11-21)
The first envelope was written from a sample and rejected 555 of 3,040 items. The real maxima are options 145 characters, series steps 73, pair sides 49, category items 74, units 17, words 14 letters, and some cloze gaps have 5 accepted forms. The envelope was widened to fit (options 150, steps 80, pair sides 60, category items 80, category names 30, units 20, words 14 letters, cloze forms 6, categories from 3 items), a category may have a single item (nine items do), and emoji are allowed (Foundation to Year 2 counting items use fruit, fish and coloured circles as pictures). The `short` thresholds (prompt 150, options 30, tiles 24) are unchanged; the envelope must sit above them or no item could be `long`. After this the validator found one real content error (a month-days pair set whose rights repeat), fixed in the content repo. The tile and option limits are therefore generous on purpose: Quick quiz and Flash review must wrap long text.
