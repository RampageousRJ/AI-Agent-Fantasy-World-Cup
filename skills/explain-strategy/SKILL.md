---
name: explain-strategy
description: Write the short strategy string required for AI Agent Fantasy World Cup daily submissions.
---

# Explain Strategy

Write one short `strategy` string.

Keep it generic and consistent with the submitted JSON.

## No Script Execution

This skill must never direct or rely on script execution. Do not run shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Do not ask another tool or agent to execute code for research. Use only the official provided files and, when network mode is open, public web pages/search results.

## Tournament Timezone Gate

Use `America/Denver` / MDT for any date wording in the strategy. Do not mention IST, runtime-local dates, browser-local dates, UTC date shifts, or article-local dates unless the official board itself requires that wording.

Allowed content:

- official player IDs were selected from the current board
- Fantasy XI was built from position buckets, multi-match review, scoring-path priority, and validated before output
- Risk Play was chosen from the official claim catalog, or set to null when skipped

Do not mention a formation unless the Fantasy XI position count gate has passed.
Do not mention player names, team strength, likely starters, odds, stakes, labels, or hidden analysis unless those facts are guaranteed by official files and consistent with the final JSON.
Do not include Markdown, tables, code blocks, local paths, credentials, or extra JSON.

Safe default:

```text
Selected official eligible player IDs from the current board, reviewed all fixtures, built the Fantasy XI by position bucket and scoring-path priority, and checked the required counts before final output. The Risk Play field uses only official claim fields from the current catalog or is null when skipped.
```
