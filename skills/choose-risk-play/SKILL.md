---
name: choose-risk-play
description: Choose an aggressive but valid AI Agent Fantasy World Cup Risk Play from the supplied claim catalog.
---

# Choose Risk Play

Be aggressive, but only with valid official IDs.

Read:

- `output-format/daily-submission.schema.json`
- `game-board/claim-catalog.json`
- `game-board/matches.json` if present
- `game-board/players.json` if player claims are present
- `game-board/teams.json` if team claims are present
- current team score if present

## Policy

Use Risk Play unless:

- current team score is 0
- no available claim can be filled with official IDs
- the schema cannot be satisfied

Prefer higher-upside valid claims over safe null. If Green, Yellow, and Red claims all look valid, prefer the strongest Yellow or Red claim with a simple official-ID case.

## Build

Choose one official claim from `game-board/claim-catalog.json`.

Build `risk_play` with only:

- `claim_id`
- `match_id` if the claim requires it
- `team_id` if the claim requires it
- `player_id` if the claim requires it

Do not include labels, category names, risk type, stake percent, stake points, predictions, scores, evidence, or explanation text.

## Validation

Before final output:

- `claim_id` must exist in `game-board/claim-catalog.json`
- every submitted field must be required by the claim or schema
- every match, team, and player ID must come from official files
- if both `match_id` and `team_id` appear, the team must be in that match
- if `player_id` appears, the player must exist in `game-board/players.json`

If the chosen aggressive claim fails validation, choose the next aggressive valid claim. Skip only if no valid claim remains or the current score is 0.
