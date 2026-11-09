# [change] factory: content model, validator and authoring tool (issue 1 of 3: 1A)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** nothing. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
Define how learning content is written down, and give the owner a way to write it once in a spreadsheet and have it checked.

## Decisions already made (owner, 2026-11-09)
Seven item types; CSV authoring; recorded audio with Android text-to-speech as the fallback; a fixed topic list per subject and year; an explanation on every item; typed answers are numbers only (no fractions); the Australian-spelling check is a warning only; packs of 20 to 50 items; item ids made by the tool.

## Scope
- **Vendored engine:** all new code goes in a self-contained `lib/engine/` (imports only the `lib/core/` interfaces) so it can be copied into each game (issue 1C).
- **Pack manifest** (one JSON file per pack): `id`, `version`, `lang` (`en-AU`), `subject` (`maths` or `english`), `year` (0 = Foundation, 1 to 12), `topic` (from the topics file), `title`, `product_id` (`null` for built-in content, a Play product id for an extra pack), `licence` (`original`), `preview` and `items`.
- **Items** have a stable `id`, `seq` (release order inside the pack, easiest and earliest topics first), `difficulty` 1 to 5, a required `explanation`, optional `image` (with required `image_alt` text) and optional `audio` (a recorded file; when absent the app reads the text aloud with Android text-to-speech, wired in issue 1B or 1C), and one of these seven types:
  - `mcq` (also true or false): `prompt`, `options`, `correct` (index or indices).
  - `series`: `prompt`, ordered `steps` (the app shuffles them).
  - `pairs`: list of `left` and `right`.
  - `word`: `answer`, `hint`, optional `letters`.
  - `category`: category names and items with their category.
  - `numeric`: `prompt`, `answer`, optional `tolerance`, optional `unit`. Numbers only, no fractions: integers and decimals, and equivalent forms (0.5 and .5, thousands separators, spaces) count as the same answer. Fraction answers use `mcq`.
  - `cloze`: a sentence with one or more gaps (`{{1}}`, `{{2}}`), and the accepted words for each gap.
- **Extra packs have two parts:** a free `preview` (description, outline of the full pack with topic names and item counts, and a list of preview item ids that may be empty; the author decides what it holds, there is no fixed size) and the `full` part (all items, including the preview items).
- **Topics file** `content/topics.yaml`: the allowed subjects, years and topics (maths and English, Foundation to Year 12). This issue drafts a first version with original topic names and no mention of any curriculum; the owner reviews it before real content is written. The validator rejects a topic that is not in the file.
- **Validator** (Dart CLI in `tool/`):
  - Errors: schema; unknown topic; missing `explanation`; missing `image_alt`; unique ids; the declared correct answers; maths items that declare an expression must evaluate to the stated answer; `numeric` answers that are not numbers; empty text; every asset file exists and is listed in `assets/LICENSES.md`; preview ids belong to the full part; outline counts match the full part; `seq` unique per pack.
  - Warnings (do not fail): a pack of fewer than 20 or more than 50 items; US spellings found by a word list (colour, organise, maths and similar).
- **Pool report:** counts items per type, subject, year and topic, so a minigame's minimum playable pool (declared in issue 1C) can be checked.
- **Authoring tool** `tool/content_cli.dart`:
  - `from-csv`: one CSV file per pack (exported from Excel or Google Sheets), with documented columns per item type. The tool assigns item ids and keeps a small `ids` file next to the pack so editing a row keeps its id; authors never type ids.
  - `validate`, `build-index` (index for one app with sha256 hashes and sizes of every pack file), `sign` (signs the index with a private key read from a path in `CONTENT_SIGNING_KEY_FILE`; the key is never committed, and tests use a clearly labelled test-only key).
- **Sample pack and sample CSV** with a few items of each of the seven types in `test/fixtures/`.
- **Docs:** `docs/CONTENT_FORMAT.md`, with an example CSV and the matching JSON for each type, and a note on how fractions are handled.

## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`, `bash scripts/ad_safety_check.sh`, `bash scripts/check_asset_licenses.sh`, `bash scripts/no_secrets_check.sh` pass. Unit tests cover good and bad packs for every rule above (including numeric equivalence, cloze gaps, unknown topics, missing explanations), the warnings, CSV conversion with stable ids across an edit, index building and signing with the test key.

## Out of scope
Downloading, caching, verification in the app, unlock rules (issue 1B); minigames and text-to-speech playback (1C); writing the real content; any AI feature.
