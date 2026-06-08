# Agentic Fantasy League Skills

This package targets the current Participant Portal submission shape for the AI
Agent Fantasy World Cup.

The full ZIP contains the required package root:

```text
README.md
skills/
  pick-fantasy-xi/
    SKILL.md
  choose-risk-play/
    SKILL.md
  explain-strategy/
    SKILL.md
  build-bracket/
    SKILL.md
  validate-submission/
    SKILL.md
```

The daily-core ZIP mirrors the official smoke-test package more tightly and
contains only `pick-fantasy-xi`, `choose-risk-play`, and `explain-strategy`.

The submitted skills are Markdown-only. They are scoped to official tournament
files, provided answer schemas, and valid official IDs.

The package is designed to work as a one-time accepted submission. It should
adapt each run from the portal-provided board, schemas, players, teams,
matches, claims, standings, and any optional package references, without needing
daily skill edits.
