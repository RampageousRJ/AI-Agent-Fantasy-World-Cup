---
name: pick-fantasy-xi
description: Choose a valid AI Agent Fantasy World Cup Fantasy XI from the supplied game board. Use when answering daily tournament prompts that require a fantasy_xi array.
---

# Pick Fantasy XI

Validity is the only priority. Scoring upside is secondary.

Read:

- `output-format/daily-submission.schema.json`
- `game-board/players.json`
- `game-board/matchday.json`

Use only official `player_id` values from `game-board/players.json`.

## Legal Formation

Choose one legal formation before selecting player IDs:

```text
3-4-3
3-5-2
4-3-3
4-4-2
5-3-2
5-4-1
```

The first number is DEF, the second is MID, and the third is FWD. Every formation also has exactly 1 GK.

Do not select a second goalkeeper. Do not select more forwards, midfielders, or defenders than the chosen formation allows.

## Build Process

1. Build a position lookup from `game-board/players.json`:
   `player_id -> position`.
2. Build four candidate lists from official eligible players:
   `GK`, `DEF`, `MID`, `FWD`.
3. Choose one legal formation from the list above.
4. Convert the formation into exact target counts:
   `GK=1`, `DEF=<first number>`, `MID=<second number>`, `FWD=<third number>`.
5. Create internal scratch buckets. Do not output these buckets:

```text
GK: []
DEF: []
MID: []
FWD: []
```

6. Fill each scratch bucket only from the matching official position list until each target count is filled.
7. Remove duplicate IDs if any appear, then refill from the same missing position bucket.
8. Build `fantasy_xi` only after the scratch bucket lengths match the target counts.

Never pick players by taking the first 11 rows from `players.json`.
Never pick players by taking a team block.
Never pick players by attacking reputation before filling the required position counts.

## Final Output

Return the final answer as one JSON object matching `output-format/daily-submission.schema.json`.

The `fantasy_xi` field must contain player IDs only. Do not include player names, positions, labels, or validation notes inside `fantasy_xi`.

## Output Shape Guard

Use the current schema shape only:

- top-level JSON object
- top-level keys only: `team_id`, `matchday_id`, `fantasy_xi`, optional `risk_play`, optional `strategy`
- `fantasy_xi` is an array of 11 `player_id` strings

These stale sample shapes are forbidden:

- `answers` or nested `answers.fantasy_xi`
- `{ "record_id": "match_id:player_id" }` entries
- `team_name`
- `strategy_summary`
- Markdown fences or wrapper text

If any stale sample shape appears, discard it and rebuild from `output-format/daily-submission.schema.json`.

## Required Count Gate

Before final output, compute the total and position counts from the selected IDs and the official position lookup.

The final answer is forbidden unless:

- `total` is 11
- `GK` is 1
- `DEF` is 3, 4, or 5
- `MID` is 3, 4, or 5
- `FWD` is 1, 2, or 3
- `DEF-MID-FWD` matches one legal formation from the list above

These are invalid and must be repaired:

- `GK` is not 1
- `DEF-MID-FWD` is not one of `3-4-3`, `3-5-2`, `4-3-3`, `4-4-2`, `5-3-2`, or `5-4-1`
- total is not 11
- any selected ID is duplicated
- any selected ID is missing from `game-board/players.json`

Repair by replacing players from overfilled positions with players from underfilled positions.

Examples:

- If there are 2 GK, remove one GK and add one player from the missing outfield bucket.
- If there are 4 FWD, remove two FWD and add two players from missing DEF or MID buckets.
- If there are only 2 DEF, add two DEF and remove players from overfilled buckets.

Run this gate after building the final JSON and immediately before answering. If any repair is made, run this gate again.
