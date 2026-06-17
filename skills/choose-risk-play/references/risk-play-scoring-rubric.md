# Risk Play Scoring Rubric

Use this rubric to convert official files and pregame public research into deterministic 0-10 scores. These scores are decision aids, not true probabilities. Do not output scores, percentages, weights, or explanations inside `risk_play`.

## Source Rules

- Score only matches from `game-board/matches.json`.
- Use public research only for exact board-listed matchups.
- Ignore final scores, highlights, recaps, post-match reports, event logs, scoring previews, and "key moment" sections.
- If public research conflicts with `game-board/matches.json`, keep the board match and score from official files plus any usable pregame context.
- If a factor has no reliable evidence, score it `5` for neutral instead of inventing facts.

## Base Factors

Score each factor from `0` to `10`.

```text
team_strength_gap        0 even/unknown, 10 extreme favorite gap
attacking_quality        0 weak attack, 10 elite attack
opponent_def_weakness    0 strong defense, 10 weak defense
lineup_certainty         0 major rotation/unknown, 10 confirmed key starters
key_absence_impact       0 absences hurt claim, 5 neutral, 10 absences strongly help claim
match_tempo              0 cautious/slow, 10 open/high-event
motivation_pressure      0 low urgency/control, 10 urgent chase/high pressure
first_goal_edge          0 no first-goal signal, 10 clear early scoring edge
late_goal_risk           0 low late chaos, 10 high late chaos
source_quality           0 weak/stale/result-contaminated, 10 reliable pregame-specific
```

## Claim Weights

Multiply each factor score by the listed weight, add the results, then divide by the total weight. Convert to a strength percentage by multiplying the weighted 0-10 score by `10`.

### Green `no_goal_stoppage_time`

This is the generic fallback when no confident positive-edge claim exists. Lower late-goal risk is better, so use `10 - late_goal_risk`.

```text
(10 - late_goal_risk) * 3
(10 - match_tempo) * 2
(10 - attacking_quality) * 2
(10 - motivation_pressure) * 2
source_quality * 1
```

Reject this fallback for a major mismatch where the trailing team is likely to chase late goals, or for an open match with strong attacking depth.

### Green `match_2plus_goals`

```text
attacking_quality * 3
opponent_def_weakness * 2
match_tempo * 2
lineup_certainty * 1
key_absence_impact * 1
source_quality * 1
```

### Green `goal_before_halftime`

```text
first_goal_edge * 3
attacking_quality * 2
opponent_def_weakness * 2
match_tempo * 1
lineup_certainty * 1
source_quality * 1
```

### Green `no_goal_first_10`

Use low early-event pressure. Lower first-goal and tempo scores are better.

```text
(10 - first_goal_edge) * 3
(10 - match_tempo) * 2
(10 - attacking_quality) * 1
lineup_certainty * 1
source_quality * 1
```

### Green Card Claims

Use only when official files or reliable pregame context support cards. If card context is unavailable, keep this low.

```text
match_tempo * 2
motivation_pressure * 2
source_quality * 2
```

### Yellow `team_scores_first`

General favorite status is not enough. This claim needs first-goal-specific evidence.

```text
first_goal_edge * 4
attacking_quality * 2
opponent_def_weakness * 2
lineup_certainty * 1
source_quality * 1
```

### Yellow `both_teams_score`

```text
attacking_quality * 2
opponent_def_weakness * 2
match_tempo * 2
lineup_certainty * 1
key_absence_impact * 1
source_quality * 1
```

### Yellow `match_over_2_5_goals`

```text
attacking_quality * 3
opponent_def_weakness * 2
match_tempo * 2
lineup_certainty * 1
key_absence_impact * 1
source_quality * 1
```

### Yellow `player_scores`

Use only for a confirmed or very likely starting central scorer, penalty taker, or high-shot player.

```text
lineup_certainty * 3
attacking_quality * 2
opponent_def_weakness * 2
key_absence_impact * 1
source_quality * 1
```

### Red Claims

Red claims need unusually strong evidence. For exact score, do not use this rubric unless official files or prompt context make one scoreline unusually clear.

For `team_wins_by_3plus`:

```text
team_strength_gap * 3
attacking_quality * 2
opponent_def_weakness * 2
lineup_certainty * 1
key_absence_impact * 1
source_quality * 1
```

For `red_card_shown`, `match_goes_to_extra_time`, and `match_goes_to_penalties`, use only when the official board or reliable pregame context gives direct support. Otherwise keep below the Red threshold.

## Strength Bands

```text
0-54    reject
55-64   Green fallback or low-confidence Green only
65-74   Green allowed
75-84   Yellow allowed only with claim-specific evidence
85-100  Red allowed only with claim-specific mismatch evidence
```

When scores are close, prefer:

1. lower stake category
2. stronger source quality
3. simpler official fields
4. Green `no_goal_stoppage_time` fallback over unsupported Yellow/Red claims
