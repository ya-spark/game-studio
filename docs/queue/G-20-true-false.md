# G-20 Judge bot (rewrite of True or false, `true_false`)

- Status: SPEC DRAFTED 3:59 PM AEDT 22 Nov 2026 (docs only); owner answers 5 questions, then "start".
- Owner decisions: none yet on this spec; rules fixed by the owner: no living beings, no title bar, folder/package/id = title, Space does not pause a game with choices (B-01), every button has a key.
- Next step: owner answers the questions in `docs/FEATURE-SPECS.md` (section "G-20 Judge bot"); build only when the owner says start.
- Links: spec in `docs/FEATURE-SPECS.md`; rules in `docs/queue/GAMES-REWRITE.md`; review in `docs/queue/GAME-REVIEW.md`; bugs B-15, B-08, B-16 (queue).

## Summary of the spec
- Title Judge bot, id `judge_bot`, package `game_judge_bot` (rename with `renamedGameIds`, web `amc.state` migration, `web_link.dart` alias, `patch_renamed_games.py`; paused apps stay on `true_false`).
- Choice kit: `ChoiceGameScreen` stays in `game_core` for Balloon pop, Shooter, Tug of war, Cloze fix. Judge bot gets its own screen (hold-statement phase, verdict beat, streak bulbs, review list) and reuses the kit's frame, chrome, keyboard, palette, session, score. B-15 is fixed in the kit separately.
- Idea: toy judge robot, statement on a ticket in its chest, two lamp buttons TRUE (T) and FALSE (F), gavel tap, stamp, 5 streak bulbs on its hat. Gate idea dropped.
- Claim model: ticket shows question plus claim for derived items ("The answer is: 70"), feedback names the same question and the right answer; 40 to 60 percent true, no run over 3.
- Levels: younger no timer and no retry (shows the right verdict); older 10 s ring on the eye; hard 6 s (internal).
- Keys: T/F/1/2 answer, Left/Right move cursor, Enter/Space confirm and Next (Space never pauses), P and Esc pause, Q read, H how to play; key chips on every button.
- Pacing: correct without explanation auto-moves after 1.2 s (older only); otherwise waits for Next. Results show score, stars, best streak and up to 3 review cards.
- Layout: no title bar, whole box, exact height, short landscape variant, lamps at least 72 dp tall; code art first, Figma prompt in `docs/art-prompts/judge-bot-figma-prompt.md` at build time.
- Steps: 1 rename, rules, claim model, screen skeleton; 2 art and animation; 3 keys, a11y, layout tests, docs; 4 web catalogue, alias, browser check, pin.

## Findings from the code (22 Nov)
- `games/true_false/lib/src/true_false_screen.dart` is a wrapper of `ChoiceGameScreen` (`game_core/lib/kit/choice_game.dart`, 658 lines); buttons are `Key('true_false.choice.0/1')`, minHeight 88, no art. Spec text in `games/true_false/docs/SPEC.md` is only the how-to (3 lines).
- B-15 likely cause: `QuizSession.answer()` advances the index at once, and the play view reads the prompt from the session's current item while options and feedback are held, so the headline shows the next question. Kit fix: hold the answered item until Next.
- Derived statements read "<prompt> Answer: <option>" (one run-on line); replaced by the two-line claim.
- Other users of the kit (keep): `balloon_pop`, `cloze_fix`, `shooter`, `tug_of_war`.
- Rename touches: `game_core/.../how_to_play_catalogue.dart` and its test, `template/.../game_art_data.dart`, `games-web/overlay/common/lib/web_product/web_rules_data.dart`, `docs/KEYBOARD.md`.

## Owner questions (open)
1. Name "Judge bot" (id `judge_bot`) ok, or "Green or red" / "Gate keeper"?
2. Younger level: wrong answer shows the right verdict and moves on (no retry)?
3. Older level: correct answers without an explanation auto-move after 1.2 s?
4. Count this game as light skill evidence (for example 2 correct in a row = one pass)?
5. Queue a content item of native True/False statements (about 2 per topic)?
