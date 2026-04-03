---
name: Search then answer
interaction: chat
description: Search (web/MCP) first, then answer
opts:
  alias: search_then_answer
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  rules: task_research
---

## user

Question / task:

> ${meta.user_prompt}

If the question is ambiguous, ask **one** clarifying question first. Otherwise:

1. Gather sources first (tools / docs / codebase search)
2. Synthesize
3. Answer in Markdown with source titles/links
