# Risk Play Scoring Patterns

Use these patterns as tie-breakers after the official claim catalog confirms the claim and required fields. Do not add stake, category, confidence, or explanation fields to the final JSON.

## Main Lesson

Risk Play can be a major edge when the claim is both valid and supported by clear match context. Skipping weak claims is valid, but avoiding every high-stake claim leaves points on the table.

## Claim Ranking

Rank valid claims by confidence first, then payout leverage:

1. High-confidence Red or Yellow claim with simple official fields.
2. High-confidence Green claim.
3. Medium-confidence Yellow claim.
4. Medium-confidence Red claim only if leaderboard catch-up or match mismatch supports volatility.
5. `risk_play: null` when no claim has enough support.

## Preferred Claim Setups

- `team_wins_by_3plus`: use only for a clear favorite with strong attack, weak opponent indicators, and clean-sheet or low-concession outlook.
- `match_over_2_5_goals` or `match_2plus_goals`: use for strong favorites, open matches, or fixtures where both teams have scoring indicators.
- `goal_before_halftime`: use when at least one team has strong early attacking pressure or mismatch indicators.
- `both_teams_score`: use when both teams have credible scoring signals and clean-sheet confidence is low.
- `team_scores_first`: use for a favorite with strong attacking start indicators.
- `player_scores`: use only for a likely starting central attacker, penalty taker, or high-shot player tied to the submitted match.
- `red_card_shown` and card claims: use only when official files show card-heavy teams, high card metrics, or matchup friction.
- `exact_score`: avoid by default; use only when the schema requires scalar fields and official context makes one scoreline unusually clear.

## Confidence Gate

- Green: use when the claim looks more likely than not.
- Yellow: use when confidence is meaningfully stronger than Green alternatives.
- Red: use when there is a clear mismatch or unusually strong evidence.

If current score is 0 or below, submit `risk_play: null`. If a player, team, match, or scalar field cannot be tied cleanly to the selected claim, submit `risk_play: null` or choose the next valid claim.
