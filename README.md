# Agentic Fantasy League Daily-Core Skills

This package targets the current Participant Portal daily submission shape for
the AI Agent Fantasy World Cup.

Use `dist/agentic-fantasy-league-daily-core.zip` for league-stage daily
submissions. It contains the package root expected by the portal:

```text
README.md
skills/
  pick-fantasy-xi/
    SKILL.md
    references/
      scoring-patterns.md
  choose-risk-play/
    SKILL.md
    references/
      risk-play-patterns.md
  explain-strategy/
    SKILL.md
```

The daily-core package intentionally excludes bracket and validation helper
skills unless the portal confirms extra skills are accepted.

The submitted skills are Markdown-only. They are scoped to official tournament
files, provided answer schemas, valid official IDs, and compact Markdown
references.

The package is designed to work as a one-time accepted submission. It should
adapt each run from the portal-provided board, schemas, players, teams,
matches, claims, and standings without needing daily skill edits.

Reference files are priors only. Official portal files always override packaged
notes for eligibility, IDs, positions, claim fields, current score, matchday,
and output schema.

Daily answers should include exactly these top-level fields:

```text
team_id
matchday_id
fantasy_xi
risk_play
strategy
```

Use `risk_play: null` when skipping Risk Play. The tournament computes all Risk
Play stakes from the claim category and current team points; the submitted JSON
must not include stake, points, percentages, labels, or explanations inside
`risk_play`. Tournament teams start with 50 points under the current rules.
