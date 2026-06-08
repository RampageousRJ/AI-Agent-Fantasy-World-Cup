# Smoke-Test Comparison

## Source Reviewed

Local official sample:

```text
fifa-skill-smoke-test/
  README.md
  package/
    README.md
    skills/
      pick-fantasy-xi/SKILL.md
      choose-risk-play/SKILL.md
      explain-strategy/SKILL.md
  submissions/
    pass-balanced/
    pass-conservative/
    fail-binary-file/
    fail-hidden-dir/
    fail-missing-skills/
    fail-secret/
    fail-structured-invalid-frontmatter/
    fail-too-many-files/
```

The repository README says Git repo submissions should use `skills_path` set to `package`.

## What The Official Sample Does

- Uses a package root containing `README.md` and `skills/`.
- Includes exactly three daily skills:
  - `pick-fantasy-xi`
  - `choose-risk-play`
  - `explain-strategy`
- Uses YAML front matter with `name` and `description` in every `SKILL.md`.
- Reads official runtime files:
  - `game-board/matchday.json`
  - `game-board/players.json`
  - `game-board/claim-catalog.json`
  - `output-format/daily-submission.schema.json`
- Uses `fantasy_xi` as an array of `player_id` values.
- Treats `risk_play: null` as valid when claims are uncertain.
- Requires a concise `strategy` string.
- Avoids private information, credentials, betting sites, paid APIs, and authenticated browser sessions.

## What The Fail Corpus Implies

Avoid these in the submitted package:

- missing `skills/` directory
- missing YAML front matter in any `SKILL.md`
- hidden directories or hidden files
- binary or non-plain-text files
- secret-looking content such as API keys
- too many files

## Changes Made To Our Package

- Added exact official runtime paths to the daily skills.
- Changed Fantasy XI guidance to default to `fantasy_xi` with `player_id` values.
- Changed Risk Play guidance to default to `risk_play: null` unless a claim is clearly supported.
- Added explicit bans on private/authenticated/paid runtime data sources.
- Tightened strategy text hygiene: no Markdown tables, code blocks, local paths, credentials, or extra JSON fragments.
- Added a `daily-core` ZIP that mirrors the official smoke-test package with only the three daily skills.

## Recommendation

Use `dist/agentic-fantasy-league-daily-core.zip` if the portal behaves exactly like the smoke-test validator and rejects extra skill folders.

Use `dist/agentic-fantasy-league-skills.zip` if the portal accepts additional skills under `skills/`; it includes `build-bracket` and `validate-submission` for future coverage and extra self-checking.

Do not submit the entire workspace as a Git repo while `fifa-skill-smoke-test/` is inside it. That folder intentionally contains failing fixtures, including hidden directories, binary-like files, and secret-looking text. For Git submission, publish only the package root or set `skills_path` to a clean package directory.
