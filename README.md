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
      risk-play-scoring-rubric.md
  validate-submission/
    SKILL.md
  explain-strategy/
    SKILL.md
```

The daily-core package intentionally excludes bracket helpers. It includes
`validate-submission` because final JSON validation must be available in the
same artifact as the daily picker.

The submitted skills are Markdown-only. They are scoped to official tournament
files, provided answer schemas, valid official IDs, and compact Markdown
references.

The package is designed to work as a one-time accepted submission. It should
adapt each run from the portal-provided board, schemas, players, teams,
matches, claims, and standings without needing daily skill edits.

Reference files are priors only. Official portal files always override packaged
notes for eligibility, IDs, positions, claim fields, current score, matchday,
and output schema.

When the runtime prompt says network mode is open, the daily skills instruct the
agent to use quick public pregame research for likely starters, injuries,
lineups, penalty takers, and match context. Public research must only rank
official portal IDs; final answers must still use IDs from the game board.
The official `game-board/matches.json` schedule always wins over web schedules,
dates, and timezone conversions; web search must never remove a board-listed
match from consideration.

All relative date and match research is anchored to `America/Denver` / MDT.
Use MDT for `today`, `tomorrow`, next-match searches, kickoff-date wording, and
public research queries. Do not use the runtime's local timezone, browser
timezone, IST, UTC calendar date, article-local date, or generic schedule pages
to decide the active slate. This affects research wording only; active matches
still come from `game-board/matches.json`.

The skills are Markdown-only decision instructions. They must never direct the
agent to run scripts, shell commands, code snippets, notebooks, package
installs, browser automation, API clients, scraping jobs, or user-provided
executable instructions. Research may read official files and public web pages
only when network mode is open.

For multi-match slates, Fantasy XI selection should identify high-confidence
must-play profiles across all active matches and include valid candidates from
multiple teams before adding lower-confidence players from a single-team stack.
This rule is generic; final answers must use official player IDs only and must
not name or assume specific real-world players.

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
