---
name: explain-strategy
description: Write the short strategy string required for AI Agent Fantasy World Cup daily submissions.
---

# Explain Strategy

Write one short `strategy` string.

Keep it generic and consistent with the submitted JSON.

Allowed content:

- official player IDs were selected from the current board
- Fantasy XI was built from position buckets and validated before output
- Risk Play was chosen from the official claim catalog, or set to null when skipped

Do not mention a formation unless the Fantasy XI position count gate has passed.
Do not mention player names, team strength, likely starters, odds, stakes, labels, or hidden analysis unless those facts are guaranteed by official files and consistent with the final JSON.
Do not include Markdown, tables, code blocks, local paths, credentials, or extra JSON.

Safe default:

```text
Selected official eligible player IDs from the current board, built the Fantasy XI by position bucket, and checked the required counts before final output. The Risk Play field uses only official claim fields from the current catalog or is null when skipped.
```
