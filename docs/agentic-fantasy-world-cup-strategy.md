# Agentic Fantasy World Cup Strategy

## Objective

Build a one-time skill package that reliably submits valid daily answers and uses risk only when the expected value justifies the stake. The core winning edge is not daily edits; it is a repeatable decision process that adapts to the portal's injected board, avoids invalid submissions, maximizes starter minutes, stays inside the 4-minute game-day runtime cap, and sizes risk based on confidence and leaderboard position.

## Current Rules Summary

- Daily answer set: Fantasy XI, optional Risk Play, short strategy summary.
- Fantasy XI must have exactly 11 eligible players from official tournament files.
- Required shape: 1 GK, 3-5 DEF, 3-5 MID, 1-3 FWD.
- No budget, captain, or substitutions.
- Every team starts with 10 points.
- If the team has 0 points before a matchday, skip Risk Play because the stake is computed from current points.
- Current accepted skills remain active until a new submission passes validation, but this package should be strong enough to run without daily edits.
- Player scoring:
  - Start: +2
  - 60+ minutes: +2
  - Goal: +6
  - Assist: +4
  - DEF/GK clean sheet: +4
  - GK 3+ saves: +2
  - Yellow: -1
  - Red: -3
  - Own goal: -3
- Risk Play is optional and can move score up or down:
  - Green: 15% stake
  - Yellow: 25% stake
  - Red: 35% stake
- Bracket locks once before knockouts and adds separate points.

## Winning Principles

1. Validity beats ambition.
   Invalid Fantasy XI can fall back to a previous XI only if still valid. That is fragile. The skills must validate position counts, eligibility, duplicate IDs, and official IDs before final answer.

2. Starters are the base layer.
   A player who starts and reaches 60 minutes earns +4 before events. Non-starters are often near-zero. The first filter should be "likely to start", not reputation.

3. Favor high-minute attackers and attacking midfielders.
   Goals and assists are the largest repeatable upside. Prefer penalty takers, set-piece takers, central forwards, advanced midfielders, and wide attackers expected to start.

4. DEF/GK selections should be correlated with clean-sheet probability.
   Defender and goalkeeper value depends heavily on team defensive strength and opponent attack. Use defenders from favored teams, but do not overfill defense unless clean-sheet odds are clearly strong.

5. Risk Play needs an expected-value gate.
   A risk claim with probability `p` and stake `s` has expected score change `(2p - 1) * s`. Break-even is above 50%, before considering leaderboard strategy. We should skip weak claims.

6. Risk should be aggressive when there is a real edge.
   Do not skip just to avoid a possible loss. Select the best positive-edge claim that clears the threshold, including Yellow or Red when the expected score change beats safer Green options.

## Draft Skill Package

Recommended package shape:

```text
README.md
skills/
  pick-fantasy-xi/
    SKILL.md
  choose-risk-play/
    SKILL.md
  explain-strategy/
    SKILL.md
  build-bracket/
    SKILL.md
  validate-submission/
    SKILL.md
```

Keep the first version mostly Markdown. Scripts may not be guaranteed in V1, so procedural instructions should stand on their own.

## Submission Page Implications

The submit page accepts one source at a time: either a ZIP upload or a public HTTPS Git repo. A newly validated ZIP replaces the current Git source, and a newly validated Git source replaces the current ZIP source. If a new submission fails validation, the previous accepted package remains active.

Best one-time submission approach:

1. Build a durable Markdown-first package that can adapt from official injected files.
2. Optionally enrich it once before submission with compact reference notes generated from external football data.
3. Submit the ZIP or public Git repo only after local structure checks pass.
4. Use the documented package shape:

```text
README.md
skills/
  pick-fantasy-xi/
    SKILL.md
  choose-risk-play/
    SKILL.md
  explain-strategy/
    SKILL.md
  build-bracket/
    SKILL.md
  validate-submission/
    SKILL.md
```

Why this makes sense:

- The portal and Git repo use the same package shape, so test exactly the artifact you intend to submit.
- The validation rules reject secrets, binaries, unsafe paths, hidden folders, and likely executable content, so a small Markdown-first repo has the lowest intake risk.
- `validate-submission` is not explicitly required, but it gives the runner a reusable instruction path for checking official IDs, position counts, duplicates, and required fields before final output.
- If the validator rejects extra skill folders, fold validation behavior into the operational skill instructions and resubmit the core four skills.
- Scripts should be optional until the final sandbox contract confirms they execute.

Current resolved clarification:

- Final expected package shape is one ZIP with top-level `skills/` containing multiple skill folders.
- Final output shape can change. Skills must inspect the injected answer schema each run. The official smoke-test daily contract uses `fantasy_xi` with `player_id` values, optional `risk_play`, and a `strategy` string.
- Game-day skill runs must finish in under 4 minutes.
- The package should not require daily edits; it should use official injected data and optional packaged references.

## Fantasy XI Heuristic

Use this order:

1. Load official matchday, player, team, match, and standings files.
2. Build eligible candidate pool using official IDs only.
3. Exclude injured, suspended, not expected to start, or low-minute-risk players when that information is available.
4. Estimate each player's score using:
   - start probability
   - 60-minute probability
   - goal/assist chance
   - clean-sheet chance for DEF/GK
   - card/own-goal risk
5. Generate valid formations and choose the highest projected XI.
6. Validate exactly 11 players, no duplicates, official IDs, eligible matchday, and position counts.
7. Prefer a conservative valid answer over an aggressive uncertain one.

Keep the process fast. Use official injected data first, then packaged references if present. Use live public context only if the runtime explicitly permits it and it is quick.

Default formation preference:

- 3-4-3 or 3-5-2 when strong attacking options exist.
- 4-4-2 or 4-3-3 when clean-sheet odds are strong.
- Avoid 5 defenders unless multiple favored teams have excellent clean-sheet outlooks.

## Risk Play Policy

Clear-edge thresholds:

- Green: use when confidence is at least 55%.
- Yellow: use when confidence is at least 60%.
- Red: use when confidence is at least 65%.

Rank claims by expected score change:

`expected_change = stake * (2 * probability - 1)`

Use loss exposure only as a tie breaker:

`loss_exposure = stake * (1 - probability)`

If expected changes are within about 10%, choose the lower-loss or higher-confidence claim. If a Yellow or Red claim has materially better expected score change, take it only when the evidence is clear. Do not take claims below 53% unless pure volatility is strategically necessary.

If the official current team score is 0 points, skip Risk Play.

Claim preferences:

- Green claims:
  - Prefer `match_2plus_cards`, `no_goal_first_10`, `goal_before_halftime`, and `match_2plus_goals` when match context supports them.
  - Be careful with `no_goal_stoppage_time`; it is often safe but depends on event notation and late-game dynamics.
- Yellow claims:
  - Prefer `team_scores_first` for heavy favorites and `both_teams_score` in attack-heavy balanced matches.
  - Use `player_scores` only for likely starting penalty takers or elite central attackers.
- Red claims:
  - Do not avoid Red by default if expected score change is clearly best.
  - Consider `red_card_shown` only in historically card-heavy matchups with strict refereeing signals.
  - Consider `team_wins_by_3plus` only for elite favorite vs weak opponent.
  - Avoid exact score unless public data or standings make the probability edge credible.

## Bracket Strategy

Bracket scoring rewards correct advancement, with larger points later:

- Round of 32: +5
- Round of 16: +8
- Quarterfinal: +12
- Semifinal: +18
- Champion: +30

Use market/team-strength consensus for most picks. Do not over-differentiate early. Add selective contrarian choices only where the bracket path is genuinely close or where the leaderboard requires uniqueness.

## Open Decisions

- Are we submitting one team or two teams?
- Will we use ZIP upload only, or maintain a public Git repo as the accepted one-time source?
- Which football API should we use for one-time pre-submit enrichment?
- Will the final contract allow scripts, or should the first competitive version remain Markdown-only?
- How aggressive do we want to be with Risk Play if we fall behind?

## Optional External Data Workflow

Do not make the submitted tournament skills depend on a live football API call during the official run. The portal package should stay text-only, secret-free, and able to work from the injected official files.

A better one-time approach is to build a local companion workflow outside the submitted package:

1. Before final submission, fetch public football data locally from an approved API.
2. Normalize it against portal IDs from the official player, team, and match files.
3. Generate compact Markdown reference notes under each skill's optional `references/` folder.
4. Keep the generated references under the 30-file and 5 MB ZIP limits.
5. Rebuild and submit the package once.

Useful generated references would include likely starters, injury/suspension notes, penalty and set-piece takers, team strength tiers, clean-sheet outlook, goal outlook, card-risk context, and match-specific Risk Play notes.

Never include API keys, credentials, private endpoints, dependency folders, raw dumps, or large generated datasets in the submitted package.

The references must be treated as priors, not hard truth. Official portal IDs, eligibility, positions, matchday data, claims, current score, and answer schemas always override generated reference notes.
