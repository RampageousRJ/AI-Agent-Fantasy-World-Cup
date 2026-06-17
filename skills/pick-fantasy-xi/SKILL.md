---
name: pick-fantasy-xi
description: Choose a valid AI Agent Fantasy World Cup Fantasy XI from the supplied game board. Use when answering daily tournament prompts that require a fantasy_xi array.
---

# Pick Fantasy XI

Validity is the hard gate. After a valid XI is possible, choose higher ceiling over a merely safe starter-only XI.

Read:

- `output-format/daily-submission.schema.json`
- `game-board/players.json`
- `game-board/matchday.json`
- `game-board/matches.json` if present
- `game-board/teams.json` if present
- `team/skills/pick-fantasy-xi/references/` if present
- public web search when network mode is open

Use only official `player_id` values from `game-board/players.json`.
Use the official position from `game-board/players.json`; never infer a position from name, reputation, team role, or public memory.
Use packaged references only as tie-breaker priors. Official eligibility, IDs, positions, matchday data, and schema always override references.

## No Script Execution

This skill must never direct or rely on script execution. Do not run shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Do not ask another tool or agent to execute code for research. Use only the official provided files and, when network mode is open, public web pages/search results.

## Official Schedule Gate

`game-board/matches.json` is the only source of truth for the active match slate.

- Build the active fixture list from `game-board/matches.json` before using web search.
- Resolve `home_team_id` and `away_team_id` through `game-board/teams.json`.
- Use `matchday_id`, `kickoff_at`, `match_id`, and the two official team names from the board.
- Web search may help with lineups and context only after the board fixture list is built.
- If a website says a board-listed team is not playing, ignore that schedule claim and keep the board-listed match.
- If a website lists teams or matches not in `game-board/matches.json`, ignore them for the current XI.
- Do not use local calendar date, browser timezone, article schedule pages, or generic World Cup schedules to decide which teams are active.
- Timezone conversions are only for interpreting kickoff timing; they must never remove a match from the board.

## Tournament Timezone Gate

Use `America/Denver` / MDT for all research date wording and next-match interpretation. Do not use the runtime's local timezone, browser timezone, IST date, UTC calendar date, article-local date, or generic "tomorrow" wording to decide which players or matches are active. Interpret relative day words such as `today`, `tomorrow`, and `next match` in MDT for search wording only.

When `kickoff_at` is present, convert it to MDT before using a date in public searches. If a kickoff falls on different calendar dates in UTC, IST, and MDT, search the board matchup with the board `matchday_id` and the MDT date, but keep every match from `game-board/matches.json`.

## Required Pregame Research

If network mode is open, use quick public research before selecting the XI.

Search for each current fixture using the exact board matchup from `game-board/matches.json` and team names from `game-board/teams.json`:

- probable lineups or confirmed lineups
- injuries, suspensions, rotation, and goalkeeper starter news
- penalty takers and set-piece takers
- recent national-team or club role for players in `players.json`

Include the board `matchday_id`, kickoff date, and both team names in searches. Do not search only for a single team.

Keep research fast. Use it only to rank official `player_id` values from `players.json`; never submit an external player ID.
If public search is unavailable or too slow, continue with official files and packaged references rather than timing out.

Before final selection, create three internal lists:

```text
START_PRIORITY: likely or confirmed starters
AVOID: likely bench, injured, suspended, rotation risk, not in probable XI
UNKNOWN: no reliable public signal
```

Also create one internal fixture review row for every match in `game-board/matches.json`:

```text
match_id | teams | favorite/goal outlook | best GK/DEF candidates | best MID/FWD candidates | best Risk Play candidates
```

Do not build the final XI until every current fixture has been reviewed. Never stop after researching only one match or one team.
If any row from `game-board/matches.json` is missing from the fixture review, the final XI is not allowed.

Do not select an `AVOID` player unless that position cannot otherwise form a valid XI. For goalkeeper, choose the player with the strongest confirmed or probable starter signal; never choose a goalkeeper by reputation alone.

## Must-Play Multi-Team Gate

When `game-board/matches.json` contains more than one match, identify high-confidence must-play candidates before choosing the formation. A must-play candidate is an official eligible player from the active slate with strong evidence for all of:

- likely or confirmed start
- strong 60-minute path
- current form or elite role for the team
- at least one scoring path beyond appearance points, such as goal threat, assist/set-piece role, penalty role, or clean-sheet value

Do not name or assume specific real-world stars in the final answer. Use this profile generically and map it only to official `player_id` values from `game-board/players.json`.

For multi-match slates:

- Include must-play candidates from at least 2 different national teams when valid candidates exist.
- If 3 or more matches are active, try to include must-play candidates from at least 3 teams without breaking formation or starter confidence.
- Choose a valid must-play candidate from another team over a lower-confidence stack player from the same team.
- Do not compose the XI from one team or one match when multiple matches have valid high-confidence starters.
- A one-team-heavy stack is allowed only after the must-play candidates from other active matches are reviewed and rejected for clear reasons such as injury, bench risk, ineligibility, or weaker scoring path.

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
3. Build the active match list from `game-board/matches.json`; keep every listed match.
4. Build the active team set from every `home_team_id` and `away_team_id` in those matches.
5. Build four candidate lists from official eligible players whose `team_id` is in the active team set:
   `GK`, `DEF`, `MID`, `FWD`.
6. A player is eligible only when the board marks the player as eligible, or when no separate eligibility field exists and the player is present in the current board. If `eligible_matchday_ids` exists, the current `matchday_id` must be in that list.
7. Rank players inside each position bucket using pregame research first, then the ceiling-after-floor rules below.
8. Mark must-play candidates across all active matches before filling any team stack.
9. Evaluate every legal formation by filling it with the best valid players from each bucket.
10. Choose the formation with the best mix of likely starts, 60-minute floor, goal/assist upside, clean-sheet upside, and multi-team must-play coverage.
11. When two legal XIs look similar, choose the one with stronger multi-team must-play coverage, then the higher-ceiling XI.
12. Convert the formation into exact target counts:
   `GK=1`, `DEF=<first number>`, `MID=<second number>`, `FWD=<third number>`.
13. Create internal scratch buckets. Do not output these buckets:

```text
GK: []
DEF: []
MID: []
FWD: []
```

14. Fill each scratch bucket only from the matching official position list until each target count is filled.
15. Remove duplicate IDs if any appear, then refill from the same missing position bucket.
16. Build `fantasy_xi` only after the scratch bucket lengths match the target counts.

Never pick players by taking the first 11 rows from `players.json`.
Never pick players by taking a team block.
Never pick a full XI from one national team.
Never pick a full XI from one match when multiple matches are on the board.
Never pick players by attacking reputation before filling the required position counts.

## Scoring Tie-Breakers

Apply these only after eligibility, official position, and formation validity are satisfied.

- Start from the actual scoring rules: starts and 60+ minutes are the floor; goals, assists, and clean sheets are the upside.
- Do not optimize for floor alone. A full XI of starter-only players usually has a low ceiling.
- But first avoid non-starters. A likely bench player should lose to a lower-ceiling likely starter.
- Prefer players with official fields indicating likely starter, starting status, or strong minutes expectation.
- Prefer players with official metrics suggesting 60+ minute likelihood.
- For FWD and MID, prefer official signals for goal threat, assist threat, penalties, set pieces, or attacking role.
- For DEF and GK, prefer official team or player signals for clean-sheet outlook and lower goals-against risk.
- Prefer players with multiple scoring paths over starter-only players: start plus 60 minutes, start plus clean-sheet chance, or start plus goal/assist role.
- Avoid low-upside starter-only forwards when a `3-5-2` or `4-4-2` can add a stronger attacking midfielder.
- Prefer `3-4-3` only when there are three strong FWD options with start, minutes, and goal signals.
- Prefer `3-5-2` when midfield depth is stronger than the third forward.
- Prefer `4-3-3` or `4-4-2` when one or two teams have strong clean-sheet value.
- Use five defenders only when defender clean-sheet and minutes value is clearly stronger than available MID/FWD value.
- If an outfield player is only a likely starter with no 60-minute, goal, assist, or clean-sheet path, treat that player as replaceable by any valid player with two scoring paths.
- If the board has one clear favorite, it is acceptable to stack that team's best attackers and one or two clean-sheet defenders/GK only after the multi-team must-play gate is satisfied.
- If the board has an open match, favor attackers and attacking midfielders over extra defenders.
- If scoring signals are missing or unclear, keep the valid position bucket selection rather than inventing football facts.

## Multi-Match Coverage Gate

Before final output, check team and match concentration.

- Default target: use players from at least 3 national teams when 4 or more teams are on the board.
- Default target: use players from at least 2 different matches when 2 or more matches are on the board.
- Default cap: no more than 5 players from one national team.
- Default cap: no more than 7 players from one match.
- If 4 or more matches are on the board, try to include strong candidates from at least 3 matches.
- A one-team stack above 5 players is allowed only when public research shows that team has unusually strong confirmed starters and the replaced players from other teams are likely bench, injured, or much weaker.
- If a team exceeds the cap, replace the weakest selected players from that team with the best valid players from other reviewed fixtures while preserving legal formation.
- If multiple teams have must-play candidates, do not exceed 5 players from one team until at least 2 teams are represented by must-play candidates.
- Do not ignore a fixture that has likely starters with penalty, set-piece, central-forward, or clean-sheet roles.
- If the final XI is concentrated in one match or one team, explicitly re-run the fixture review before answering.

## Starter Gate

Before final output, check the selected XI against the internal research lists.

- Target at least 10 likely or confirmed starters.
- If fewer than 9 selected players have starter support, rebuild the XI using safer starters even if ceiling drops.
- Remove any selected player with strong bench, injury, suspension, or rotation evidence.
- If a selected FWD or MID is not likely to start, replace with a likely starter from the same position if available.
- If a selected GK is not the likely starter, replace with the likely starting GK if available.

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
- any selected player's `team_id` is not one of the active teams from `game-board/matches.json`

Repair by replacing players from overfilled positions with players from underfilled positions.

Examples:

- If there are 2 GK, remove one GK and add one player from the missing outfield bucket.
- If there are 4 FWD, remove two FWD and add two players from missing DEF or MID buckets.
- If there are only 2 DEF, add two DEF and remove players from overfilled buckets.

Run this gate after building the final JSON and immediately before answering. If any repair is made, run this gate again.
