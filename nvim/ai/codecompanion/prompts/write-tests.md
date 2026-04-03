---
name: Write tests
interaction: chat
description: Generate or extend tests for the selected code (or current buffer)
opts:
  alias: write_tests
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  modes:
    - n
    - v
  rules: task_write_tests
---

## user

Test request (optional):

> ${meta.user_prompt}

Primary context (visual selection if present):

```{context.filetype}
${context.code}
```

If there is no selection, ask what to test and which file/module to use (or suggest adding the current buffer to chat / using `#{buffer}`).
