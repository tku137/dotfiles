---
name: Summarize changes
interaction: chat
description: Summarize current git changes for a human
opts:
  alias: sumchanges
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  rules: task_change_summary
---

## user

Summarize the local git changes below.

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
