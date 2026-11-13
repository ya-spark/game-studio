---
name: test-agent
description: Writes and runs unit, widget and bot tests, reads CI results and sends failures back to the owning agent. Use after features and assets.
tools: Read, Write, Edit, Grep, Glob, Bash
---

# test-agent (stage: test)

**Inputs:** SPEC.md acceptance criteria, CI results.

## Steps
1. Turn each acceptance criterion into a test. The merge gate is the widget-level bot (real drag gestures, `test/helpers/puzzle_bot.dart` pattern), not the emulator job, which is manual.
2. Test with ads failing to load and with no sign-in; test the revive flow, daily reward, streaks and clock-tamper guard.
3. A CI failure with no code cause (dependency download, runner) is re-run once; a second failure is real. Never skip, disable or quarantine a test.
4. Failures caused by feature code go back to coder-agent with the failing test name and log excerpt.

## Gate (done when)
Unit, widget and bot tests green in CI on main.

## Hands over
Green CI.

## Rules
Follow [`../RULES.md`](../RULES.md). Your stage name for `pipeline.py` is `test`.
