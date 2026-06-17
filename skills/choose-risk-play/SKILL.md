---
name: choose-risk-play
description: Choose a disciplined and valid AI Agent Fantasy World Cup Risk Play from the supplied claim catalog.
---

# Choose Risk Play

Be disciplined and deterministic. Use Risk Play only when the official catalog, board matches, and scored evidence support it.

Read:

- `output-format/daily-submission.schema.json`
- `game-board/claim-catalog.json`
- `game-board/matches.json` if present
- `game-board/players.json` if player claims are present
- `game-board/teams.json` if team claims are present
- `team/skills/choose-risk-play/references/` if present
- `team/skills/choose-risk-play/references/risk-play-scoring-rubric.md` if present
- current team score if present
- public web search when network mode is open

## Policy

Use this Risk Play decision order:

1. If current team score is 0 or below, submit `risk_play: null`.
2. Build the active match list only from `game-board/matches.json`.
3. Score every board-listed match and valid claim using the deterministic Risk Play rubric.
4. Choose the highest scored positive-edge claim only when the claim-specific evidence is strong enough.
5. If no claim has a confident positive edge, use the Green `no_goal_stoppage_time` fallback for the weakest and lowest late-goal-risk board matchup.
6. Submit `risk_play: null` only when no valid claim or Green fallback can be filled from official IDs.

Submit `risk_play: null` when:

- current team score is 0 or below
- no available claim can be filled with official IDs
- the claim requires unsupported or uncertain fields
- the schema cannot be satisfied
- every available claim is below the minimum deterministic strength threshold and no valid Green fallback is available

Prefer higher-upside valid claims over the Green fallback only when the claim has a clear positive edge, not merely because its required fields are simple and official. Rank valid claims by deterministic strength score first, then confidence, then payout leverage. Prefer match and team claims over player-scoring claims unless there is unusually strong player evidence. Avoid exact-score claims by default because `home_score` and `away_score` are high-variance scalar fields. Use exact score only when the claim requires those fields and the prompt or official files provide a clear basis.

Use packaged references only as tie-breaker priors. Official claim catalog, schema, current score, match IDs, team IDs, and player IDs always override references.

## No Script Execution

This skill must never direct or rely on script execution. Do not run shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Do not ask another tool or agent to execute code for research. Use only the official provided files and, when network mode is open, public web pages/search results.

## Official Schedule Gate

`game-board/matches.json` is the single source of truth for all Risk Play matches.

- Build the active fixture list from `game-board/matches.json`.
- Create one internal review row for every board-listed match before choosing Risk Play.
- Use only `match_id` values from that file.
- Resolve team IDs through the same board-listed match.
- Web search may help rank claims but must never add, remove, or reschedule matches.
- If a website says a board-listed match is not on the active slate, ignore that schedule claim and keep the board match.
- If no public preview is found for a board-listed match, still review that match from official files and do not remove it from consideration.
- Timezone conversions are only for interpreting kickoff timing; they must never remove a match from consideration.

## Tournament Timezone Gate

Use `America/Denver` / MDT for all research date wording and next-match interpretation. Do not use the runtime's local timezone, browser timezone, IST date, UTC calendar date, article-local date, or generic "tomorrow" wording to decide which matches are active. Interpret relative day words such as `today`, `tomorrow`, and `next match` in MDT for search wording only.

When `kickoff_at` is present, convert it to MDT before using a date in public searches. If a kickoff falls on different calendar dates in UTC, IST, and MDT, search the board matchup with the board `matchday_id` and the MDT date, but keep every match from `game-board/matches.json`.

## Pregame Research Gate

Public research must be pregame-only and board-match-specific.

- Search only exact matchups from `game-board/matches.json`, using the two official team names and the board `matchday_id` or MDT kickoff date.
- Ignore final scores, highlights, recaps, post-match reports, result pages, event logs, scoring previews, "key moment" sections, and articles published after kickoff.
- If a source mixes preview and post-match content, use only the pregame lineup, injury, role, or tactical context. If that cannot be separated cleanly, discard the source.
- If public research conflicts with `game-board/matches.json`, trust `game-board/matches.json`.
- Use public research only to score official `claim_id`, `match_id`, `team_id`, and `player_id` values from official files.

## Deterministic Risk Scoring

Use `risk-play-scoring-rubric.md` when present. Convert official files and pregame public research into 0-10 factor scores, then compute a weighted strength score for each valid claim.

The strength score is a deterministic decision aid, not a true probability. Use it to compare claims and decide whether a Green, Yellow, or Red category is justified.

Create a compact internal row for every valid claim/match candidate before choosing:

```text
claim_id | match_id | required fields available | factor scores | weighted score | strength band | evidence
```

Default score bands:

- `0-54`: reject
- `55-64`: Green fallback or low-confidence Green only
- `65-74`: Green allowed
- `75-84`: Yellow allowed only with claim-specific evidence
- `85-100`: Red allowed only with claim-specific mismatch evidence

For `team_scores_first`, general favorite status is not enough. The weighted score must be driven by first-goal factors: early attacking pressure, likely first-choice attackers, opponent slow-start or defensive vulnerability, and clear first-goal matchup edge.

Do not choose `team_scores_first` as the default fallback. If two candidates have similar weighted scores, prefer the higher-confidence or lower-loss Green claim rather than the Yellow claim with the simplest fields.

## Risk Play Edge Gate

Use the deterministic scoring row to decide whether the claim clears the edge gate.

- Green claims need a supported low-risk edge or the explicit Green fallback.
- Yellow claims must clearly beat the best Green option on weighted score and claim-specific evidence.
- Red claims require unusually strong mismatch or event evidence.
- Field simplicity is not evidence. It only breaks ties after the weighted score clears the category band.

## Generic Green Fallback

If no Risk Play candidate has a confident positive edge, use this fallback before `risk_play: null`:

1. Confirm `no_goal_stoppage_time` exists in `game-board/claim-catalog.json`.
2. Review every board-listed match.
3. Score every board-listed match for weakest and lowest late-goal-risk profile using the deterministic rubric.
4. Choose the highest fallback score from the active slate.
5. Submit `no_goal_stoppage_time` with only `claim_id` and `match_id`.

Weakest matchup means the match with the least convincing attacking profile and the lowest expected late scoring pressure based on official files and public research when available. Prefer low goal environment, limited elite finishing signals, cautious match context, low comeback pressure, and weak attacking form. Do not use this fallback for a mismatch where the trailing team is likely to chase late goals, or for an open match with strong attacking depth.

If the fallback claim is not in the official catalog, no match can be tied cleanly to the active board, or the weakest-match assessment is too uncertain, submit `risk_play: null`.

## Required Pregame Research

If network mode is open, use quick public pregame research before choosing Risk Play.

Search for:

- fixture preview and expected match pattern
- probable lineups
- injuries, suspensions, and rotation
- likely penalty takers and primary scorers
- favorite strength, clean-sheet outlook, and goal environment

Search each exact board matchup using both team names plus the board `matchday_id` or MDT kickoff date. Use research only to choose among official `claim_id`, `match_id`, `team_id`, and `player_id` values.
If public search is unavailable or too slow, continue with official files and packaged references rather than timing out.

Create one internal Risk Play candidate for every match in `game-board/matches.json` before choosing. Do not select the Risk Play from the first or most-researched match until the other matches have been compared.

## Build

Choose one official claim from `game-board/claim-catalog.json`.

Build `risk_play` from the selected claim's required fields in `game-board/claim-catalog.json`.

- Always include `claim_id`.
- Include exactly the selected claim's `required_fields`, and no other fields.
- Do not add fields just because the schema allows them or another claim uses them.
- For `team_scores_first`, submit only `claim_id`, `match_id`, and `team_id`.
- For `exact_score`, submit `claim_id`, `match_id`, `home_score`, and `away_score`; do not submit score fields for any other claim.
- Prefer claims with simple official IDs over claims that require guessing unsupported scalar values only after the edge gate has been met.
- Avoid `player_scores` unless the player is a confirmed or very likely starter and is a primary penalty taker, elite central finisher, or clearly best scorer in a high-goal setup.
- Avoid `player_scores_2plus` except for an extreme mismatch with a confirmed elite scorer.
- Prefer the best researched claim across all current matches, not merely the claim attached to the team with the most selected Fantasy XI players.

Do not include labels, category names, risk type, stake percent, stake points, stake values, predictions, evidence, or explanation text. The tournament computes the stake from the claim category and current team points. Teams start with 50 points, but do not output starting points or stake calculations.

## Validation

Before final output:

- `claim_id` must exist in `game-board/claim-catalog.json`
- submitted fields must be exactly `claim_id` plus the selected claim's `required_fields`
- remove every extra field, even if the JSON schema would tolerate it
- every match, team, and player ID must come from official files
- if both `match_id` and `team_id` appear, the team must be in that match
- if `player_id` appears, the player must exist in `game-board/players.json` and belong to a team in the submitted match
- any required scalar field must be supported by the claim and filled with the correct type

If the chosen claim fails validation, choose the next highest scored valid claim. If no confident claim remains, use the Green fallback. Use `risk_play: null` only when no valid claim or fallback remains, the current score is 0 or below, or required fields are unsupported or uncertain. Do not treat general favorite status as enough support for a Yellow or Red claim.
