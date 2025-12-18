---
name: Claude GTD
interaction: chat
description: Plan + execute multi-step coding tasks with tools
opts:
  alias: claude_gtd
  is_slash_cmd: true
  modes:
    - n
    - v
  adapter:
    name: copilot
    model: claude-sonnet-4.5
  auto_submit: true
  stop_context_insertion: true
  rules: task_gtd
---

## user

Task:

> ${meta.user_prompt}

Optional current selection context:

```text
filetype: ${context.filetype}
bufnr: ${context.bufnr}
mode: ${context.mode}
```

```{context.filetype}
${context.code}
```
