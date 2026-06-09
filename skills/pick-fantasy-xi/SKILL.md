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
Use the official position from `game-board/players.json`; never infer a position from name, reputation, team role, or public memory.

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
2. Read the current `matchday_id` from `game-board/matchday.json`.
3. Build four candidate lists from official eligible players:
   `GK`, `DEF`, `MID`, `FWD`.
4. A player is eligible only when the board marks the player as eligible, or when no separate eligibility field exists and the player is present in the current board. If `eligible_matchday_ids` exists, the current `matchday_id` must be in that list.
5. Choose one legal formation from the list above.
6. Convert the formation into exact target counts:
   `GK=1`, `DEF=<first number>`, `MID=<second number>`, `FWD=<third number>`.
7. Create internal scratch buckets. Do not output these buckets:

```text
GK: []
DEF: []
MID: []
FWD: []
```

8. Fill each scratch bucket only from the matching official position list until each target count is filled.
9. Remove duplicate IDs if any appear, then refill from the same missing position bucket.
10. Build `fantasy_xi` only after the scratch bucket lengths match the target counts.

Never pick players by taking the first 11 rows from `players.json`.
Never pick players by taking a team block.
Never pick players by attacking reputation before filling the required position counts.

## Scoring Tie-Breakers

Apply these only after eligibility, official position, and formation validity are satisfied.

- Prefer players with official fields indicating likely starter, starting status, or strong minutes expectation.
- Prefer players with official metrics suggesting 60+ minute likelihood.
- For FWD and MID, prefer official signals for goal threat, assist threat, penalties, set pieces, or attacking role.
- For DEF and GK, prefer official team or player signals for clean-sheet outlook and lower goals-against risk.
- If scoring signals are missing or unclear, keep the valid position bucket selection rather than inventing football facts.

## Final Output

Return the final answer as one JSON object matching `output-format/daily-submission.schema.json`.

The `fantasy_xi` field must contain player IDs only. Do not include player names, positions, labels, or validation notes inside `fantasy_xi`.

## Output Shape Guard

Use the current schema shape only:

- top-level JSON object
- top-level keys only: `team_id`, `matchday_id`, `fantasy_xi`, `risk_play`, `strategy`
- `fantasy_xi` is an array of 11 `player_id` strings
- include `risk_play` as a valid claim object or `null`
- include `strategy` as short plain text

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
- any selected ID is not eligible for the current board or current `matchday_id`

Repair by replacing players from overfilled positions with players from underfilled positions.

Examples:

- If there are 2 GK, remove one GK and add one player from the missing outfield bucket.
- If there are 4 FWD, remove two FWD and add two players from missing DEF or MID buckets.
- If there are only 2 DEF, add two DEF and remove players from overfilled buckets.

Run this gate after building the final JSON and immediately before answering. If any repair is made, run this gate again.
