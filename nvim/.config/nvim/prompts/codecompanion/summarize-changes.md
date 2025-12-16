---
name: Summarize changes
interaction: chat
description: Summarize current git changes for a human
opts:
  alias: sumchanges
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
---

## user

You will get local git information.

Summarize in this format:

- What changed (bullets)
- Why it was changed (best guess)
- Risk level (low/med/high)
- Follow-up tasks

### Status

```text
${git.status}
```

### Staged diff

```diff
${git.diff_staged}
```

### Unstaged diff

```diff
${git.diff_unstaged}
```
