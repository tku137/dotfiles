---
name: Review changes
interaction: chat
description: Review staged/unstaged diffs and suggest improvements
opts:
  alias: review_changes
  is_slash_cmd: true
  auto_submit: true
  stop_context_insertion: true
  rules: task_review_changes
---

## user

Focus (optional):

> ${meta.user_prompt}

You have local git context:

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
