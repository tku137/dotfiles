---
name: Search then answer
interaction: chat
description: Search (web/MCP) first, then answer
opts:
  alias: search_then_answer
---

## user

First, gather information, then answer.

You may use:

- @{vectorcode} for RAG on the codebase
- @{duckduckgo_search} / @{fetch_webpage} for external sources
- @{context7} for library and dependency documentation
- @{mcp} for other tools

Steps:

1. Collect sources (tools)
2. Synthesize
3. Answer in Markdown with links/titles from sources
