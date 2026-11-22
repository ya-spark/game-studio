# G-26 Judge bot content (native true/false statements)

- Status: NEW 8:35 PM AEDT 22 Nov 2026 (owner answer 5 to the G-20 questions: queue it, write nothing now). Not started.
- Next step: author about 2 native True/False statements per topic (`mcq` items with options `True` and `False`, one right), so Judge bot claims read naturally instead of "The answer is: x". Content work in `game-content`, validated by the content tooling; no code change (Judge bot already keeps the authored truth of native items and balances only derived claims).
- Links: `docs/queue/G-20-true-false.md`; spec `games/judge_bot/docs/SPEC.md` (Claim model); format `template/flutter-game-template/docs/CONTENT_FORMAT.md` (True or false is an `mcq`).
- Size estimate: about 2 per topic across the free packs; the number of topics is in `game-content` (count before starting). Keep statements short (a ticket fits about 80 characters at 360 dp) and balance true and false authors-side (about half each).
