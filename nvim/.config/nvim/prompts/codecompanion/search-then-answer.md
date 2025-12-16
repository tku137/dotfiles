---
name: Search then answer
interaction: chat
description: Plan → research → answer (tool-first)
opts:
  alias: search_then_answer
  is_slash_cmd: true
  is_workflow: true
  auto_submit: true
  stop_context_insertion: true
---

## system

You are a careful research assistant inside Neovim.
Prefer primary sources (official docs, READMEs, changelogs) when possible.
Be explicit about uncertainty and what you could not verify.

## user

Task: ${context.user_prompt}

Step 1 (plan only):

- Propose a short research plan (3–7 bullets).
- Name the exact tools you intend to use (e.g. @{vectorcode}, @{duckduckgo_search}, @{fetch_webpage}, @{context7}, @{mcp}).
- Do **not** answer yet.

## user

Step 2 (research):
Execute the plan. Use tools to gather information.
Output:

- Bullet list of findings (each bullet should mention the source title/site).
- Keep it factual; no final answer yet.

## user

Step 3 (answer):
Now answer the task in Markdown.

Constraints:

- Keep it concise.
- If you used sources, include their titles and links.
- If something is uncertain, say what you couldn’t verify.
