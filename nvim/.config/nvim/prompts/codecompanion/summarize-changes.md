---
name: Summarize changes
interaction: chat
description: Summarize current changes made by LLM for a human
opts:
  alias: summarize_changes
---

## user

You will get code changes (diffs or edited files).

Summarize them in this format:

- What changed (bullets)
- Why it was changed (guess if needed)
- Risk level (low/med/high)
- Follow-up tasks

You may use @{git} to view diffs.

Keep it short.
