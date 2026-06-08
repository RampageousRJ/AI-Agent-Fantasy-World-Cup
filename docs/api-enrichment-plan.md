# API Enrichment Plan

## Goal

Create a one-time enriched skill package before final submission. The submitted tournament package should still be Markdown-only and able to run from portal-injected official files, but it can include compact reference notes generated from external football data.

## Architecture

```text
football API
  -> local fetch script
  -> normalized local JSON cache outside submitted package
  -> portal ID mapper
  -> compact Markdown reference generator
  -> skills/*/references/*.md
  -> package-skills.sh
  -> dist/agentic-fantasy-league-skills.zip
```

Only the generated Markdown references go into the submitted package. API keys, raw JSON, scripts, node modules, and caches stay outside the ZIP.

## Data To Fetch

One-time enrichment can improve priors, but it cannot know future confirmed lineups, late injuries, suspensions, tactical changes, or knockout matchups that are not known yet. The package must remain able to adapt from portal-injected matchday data.

Team-level priors:

- team strength tier
- recent form where available
- goals for/against trend
- clean-sheet likelihood
- card-risk profile
- group and bracket path difficulty

Player-level priors:

- likely starter status
- expected minutes
- fantasy position mapping
- penalty taker status
- set-piece role
- goal/assist threat
- card risk
- injury or suspension concern

Match-level priors:

- favorite/underdog strength
- projected goal environment
- clean-sheet outlook
- likely card environment
- Risk Play claim notes

## Portal ID Mapping

The portal's official IDs are the only IDs that can be submitted. External API IDs must never appear in final answers.

Mapping should use:

1. exact team name and country
2. normalized team name aliases
3. player name plus national team
4. player birth date if both sources provide it
5. player position as a tie breaker

Any uncertain player mapping should be omitted from generated references rather than guessed.

## Generated Reference Files

Recommended files:

```text
skills/pick-fantasy-xi/references/team-strength-tiers.md
skills/pick-fantasy-xi/references/player-priors.md
skills/pick-fantasy-xi/references/set-piece-and-penalty-takers.md
skills/choose-risk-play/references/risk-play-priors.md
skills/build-bracket/references/bracket-team-ratings.md
```

Keep these files concise and ranked. The agent needs quick priors, not raw data.

## Reference Format

Use portal IDs when known:

```text
## France

Team ID: 123
Strength tier: Elite
Clean-sheet outlook: High
Goal outlook: High
Card risk: Medium

Likely high-value players:
- 456789 | K. Player | FWD | likely starter | penalty taker | high goal threat
- 987654 | M. Player | MID | likely starter | set pieces | high assist threat
```

For uncertain mappings:

```text
- Player name omitted: external identity did not confidently map to a portal player ID.
```

## Validation

Before packaging:

- confirm generated references are Markdown only
- confirm no API key or private token appears in the repo
- confirm no raw JSON dump is included under `skills/`
- confirm total package file count stays under 30
- confirm ZIP size stays under 5 MB
- rebuild with `./package-skills.sh`

## Runtime Rule

The agent should use generated references as priors only. Official portal files always override generated reference notes for IDs, eligibility, positions, matchday data, claims, score, and schema.
