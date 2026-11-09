# [change] factory: content model, validator and authoring tool (issue 1 of 3: 1A)

**Repo:** game-factory (`template/flutter-game-template`). **Depends on:** nothing. Read `docs/PLAN-new-apps.md` and `docs/DECISIONS.md` first.

## Goal
Define how learning content is written down, and give the owner a way to write it once and have it checked.

## Scope
- **Vendored engine:** all new code goes in a self-contained `lib/engine/` (imports only the `lib/core/` interfaces) so it can be copied into each game (see issue 1C).
- **Pack manifest** (one JSON file per pack): `id`, `version`, `lang` (`en-AU`), `subject` (`maths` or `english`), `year` (school year, 0 = Foundation), `topic`, `title`, `product_id` (`null` for built-in content, a Play product id for an extra pack), `licence` (`original`), `preview` and `items`.
- **Items** have a stable `id`, `seq` (release order inside the pack, easiest and earliest topics first), `difficulty` 1 to 5, optional `image` and `audio`, and one of these types:
  - `mcq` (also true or false): `prompt`, `options`, `correct` (index or indices), `explanation`.
  - `series`: `prompt`, ordered `steps` (the app shuffles them).
  - `pairs`: list of `left` and `right`.
  - `word`: `answer`, `hint`, optional `letters`.
  - `category`: category names and items with their category.
- **Extra packs have two parts:** a free `preview` (description, outline of the full pack with topic names and item counts, and a list of preview item ids that may be empty; the author decides what it holds, there is no fixed size) and the `full` part (all items, including the preview items).
- **Validator** (Dart CLI in `tool/`): schema; unique ids; exactly the declared correct answers; maths items that declare an expression must evaluate to the stated answer; no empty text; Australian-spelling warnings from a word list; every asset file exists and is listed in `assets/LICENSES.md`; preview ids belong to the full part; outline counts match the full part; `seq` unique per pack.
- **Pool report:** counts items per type, subject, year and topic, so a minigame's "minimum playable pool" (declared in issue 1C) can be checked.
- **Authoring tool** `tool/content_cli.dart`: `validate`, `from-csv` (the owner's spreadsheets to pack JSON), `build-index` (index for one app, with sha256 hashes and sizes of every pack file), `sign` (signs the index with a private key read from a path in `CONTENT_SIGNING_KEY_FILE`; the key is never committed, and tests use a clearly labelled test-only key).
- **Sample pack** with a few items of each type in `test/fixtures/`.
- **Docs:** `docs/CONTENT_FORMAT.md`, with examples of each type and the preview and full parts.

## Acceptance
`flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`, `bash scripts/ad_safety_check.sh`, `bash scripts/check_asset_licenses.sh`, `bash scripts/no_secrets_check.sh` pass. Unit tests cover good and bad packs for every rule above, CSV conversion, index building and signing with the test key.

## Out of scope
Downloading, caching, verification in the app, unlock rules (issue 1B); minigames (1C); writing the real content.
