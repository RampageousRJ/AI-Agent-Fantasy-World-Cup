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
- `team/skills/choose-risk-play/references/` if present
- current team score if present

## Policy

Use Risk Play unless:

- current team score is 0 or below
- no available claim can be filled with official IDs
- the claim requires unsupported or uncertain fields
- the schema cannot be satisfied

Prefer higher-upside valid claims over safe null only when the required fields are simple and official. Rank valid claims by confidence first, then payoff leverage. Avoid exact-score claims by default because `home_score` and `away_score` are high-variance scalar fields. Use exact score only when the claim requires those fields and the prompt or official files provide a clear basis.

Use packaged references only as tie-breaker priors. Official claim catalog, schema, current score, match IDs, team IDs, and player IDs always override references.

## Build

Choose one official claim from `game-board/claim-catalog.json`.

Build `risk_play` from the selected claim's required fields in `game-board/claim-catalog.json`.

- Always include `claim_id`.
- Include `match_id`, `team_id`, `player_id`, `home_score`, `away_score`, or other scalar fields only when the selected claim requires them and the schema allows them.
- Do not add fields just because another claim uses them.
- Prefer claims with simple official IDs over claims that require guessing unsupported scalar values.

Do not include labels, category names, risk type, stake percent, stake points, stake values, predictions, evidence, or explanation text. The tournament computes the stake from the claim category and current team points. Teams start with 50 points, but do not output starting points or stake calculations.

## Validation

Before final output:

- `claim_id` must exist in `game-board/claim-catalog.json`
- every submitted field must be required by the claim or schema
- every match, team, and player ID must come from official files
- if both `match_id` and `team_id` appear, the team must be in that match
- if `player_id` appears, the player must exist in `game-board/players.json` and belong to a team in the submitted match
- any required scalar field must be supported by the claim and filled with the correct type

If the chosen aggressive claim fails validation, choose the next aggressive valid claim. Use `risk_play: null` only when no valid claim remains, the current score is 0 or below, or required fields are unsupported or uncertain. Do not skip a clearly supported Red or Yellow claim just because it has higher stake.
