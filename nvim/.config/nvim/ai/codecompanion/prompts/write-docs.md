---
name: Write documentation
interaction: chat
description: Draft or update documentation for the selected code or current buffer
opts:
  alias: write_docs
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  modes:
    - n
    - v
  rules: task_write_docs
---

## user

Documentation request:

> ${meta.user_prompt}

If a visual selection is present, it is the primary source:

```{context.filetype}
${context.code}
```
