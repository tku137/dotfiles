---
name: Explain architecture
interaction: chat
description: Explain architecture for selection/buffer or for a user-specified area
opts:
  alias: explain_arch
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  modes:
    - n
    - v
  rules: task_explain_arch
---

## user

What to explain (optional):

> ${meta.user_prompt}

If a visual selection is present, treat it as primary context:

```{context.filetype}
${context.code}
```

If there is no selection and the request is vague, ask ONE clarifying question (e.g. "which subsystem / entrypoint / feature?").
Then gather context from the codebase using tools and explain the architecture.
