---
name: validate-submission
description: Validate Fantasy XI, Risk Play, and strategy against official files before final submission.
---

# Validate Submission

Use this skill before final output.

Hard output invariant: never emit a final answer unless `fantasy_xi` recomputes to exactly 11 IDs with exactly 1 GK, 3-5 DEF, 3-5 MID, and 1-3 FWD from official `players.json` positions.

Read:

- `output-format/daily-submission.schema.json`
- `game-board/players.json`
- `game-board/claim-catalog.json` if `risk_play` is present
- `game-board/matches.json` if `risk_play` uses `match_id` or `team_id`

## No Script Execution

This skill must never direct or rely on script execution. Do not run shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Do not ask another tool or agent to execute code for validation. Validate by reading official provided files and checking the submitted JSON logically.

## Tournament Timezone Gate

Use `America/Denver` / MDT for any date, next-match, or relative-day reasoning during validation. Do not use the runtime's local timezone, browser timezone, IST date, UTC calendar date, article-local date, or generic `today`/`tomorrow` wording to reject a board-listed match. Active matches still come from `game-board/matches.json`.

## Output Shape Gate

Validate against the current schema shape before checking picks:

- top-level JSON object only
- top-level keys only: `team_id`, `matchday_id`, `fantasy_xi`, optional `risk_play`, optional `strategy`
- no `answers`, `team_name`, `strategy_summary`, or other top-level fields
- `fantasy_xi` is an array of 11 strings, not objects
- no `{ "record_id": "match_id:player_id" }` entries
- no Markdown fences or wrapper text

If the output uses a stale sample shape, rebuild it from `output-format/daily-submission.schema.json` before validating player counts.

## Fantasy XI Gate

Build a lookup from `game-board/players.json`:

```text
player_id -> position
```

Then compute counts from the submitted `fantasy_xi` IDs.

The final answer is valid only when counts match one legal formation:

```text
1 GK plus one of:
3 DEF / 4 MID / 3 FWD
3 DEF / 5 MID / 2 FWD
4 DEF / 3 MID / 3 FWD
4 DEF / 4 MID / 2 FWD
5 DEF / 3 MID / 2 FWD
5 DEF / 4 MID / 1 FWD
```

Reject and repair if:

- total is not 11
- `GK` is not 1
- `DEF-MID-FWD` does not match one legal formation above
- any ID is duplicated
- any ID is missing from `game-board/players.json`

Do not trust the strategy text for formation. Only the computed counts from `players.json` matter.

If the counts are wrong, rebuild or refill the Fantasy XI from locked official position buckets. Do not repair from a combined all-player ranking. Validate again after repair.

Goalkeeper repair is mandatory and specific:

- If there are 0 GK, add the best valid goalkeeper from the official `GK` bucket and remove one player from an overfilled outfield position.
- If there are 2 or more GK, keep only the highest-ranked valid likely starting GK in the `GK` bucket and replace every extra GK with valid players from the missing outfield position buckets.
- Do not allow the scoring engine to exclude extra GK. Any over-limit exclusion means the submitted XI was invalid and must be rebuilt.

Final validation must recompute counts from `players.json` after every repair. Strategy text, player reputation, or scoring-preview points never override computed official positions.

## Risk Play Gate

If `risk_play` is null, it is valid when the schema allows null.

If `risk_play` is present:

- `claim_id` must exist in `game-board/claim-catalog.json`
- include only fields required by that claim and the schema
- use official match, team, and player IDs only
- if both `match_id` and `team_id` appear, the team must be in that match
- remove labels, risk type, stake values, predictions, scores, and explanations

If a Risk Play field fails validation, repair it or choose the next valid claim. Use `risk_play: null` only when no valid claim remains or the current score is 0.

## Strategy Gate

The `strategy` field must be short plain text.

Do not claim a formation unless the Fantasy XI count gate passed.
Do not include Markdown, tables, code blocks, local paths, credentials, or extra JSON.

## Final Rule

Never output a final JSON object with known validation errors.
