# Risk Play Claim Notes

Use these notes only after `choose-risk-play/SKILL.md` has built the official match list from `game-board/matches.json` and scored candidates with `risk-play-scoring-rubric.md`.

Do not treat this file as the decision tree. The authoritative order is in `choose-risk-play/SKILL.md`:

```text
strong scored claim -> Green no_goal_stoppage_time fallback -> risk_play: null
```

Do not add stake, category, confidence, scores, weights, or explanation fields to the final JSON.

## No Script Execution

Do not run or request scripts, shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Public research means reading official files and public web pages/search results only when network mode is open.

## Match Source Rule

`game-board/matches.json` is the single source of truth for matches.

- Review every board-listed match.
- Search only exact board-listed matchups.
- Ignore public schedule pages that add, remove, or reschedule matches.
- Ignore final scores, highlights, recaps, post-match reports, event logs, scoring previews, and "key moment" sections.
- If public research conflicts with the board, keep the board match and use official files plus usable pregame context.

## Claim Notes

- `no_goal_stoppage_time`: use as the Green fallback only through the deterministic rubric. Prefer the weakest and lowest late-goal-risk board matchup.
- `team_scores_first`: do not use from favorite status alone. Use only when the rubric score is driven by first-goal-specific evidence.
- `player_scores`: use only for a confirmed or very likely starting central scorer, penalty taker, or high-shot player.
- `player_scores_2plus`: use only for an extreme mismatch with a confirmed elite scorer.
- `team_wins_by_3plus`: use only for a clear mismatch with strong attack and weak opponent indicators.
- `match_over_2_5_goals` or `match_2plus_goals`: use for strong favorites, open matches, or fixtures where both teams have scoring indicators.
- `both_teams_score`: use when both teams have credible scoring signals and clean-sheet confidence is low.
- `goal_before_halftime`: use when early attacking pressure or mismatch indicators are specific and strong.
- `red_card_shown` and card claims: use only when official files or reliable pregame context support card-heavy conditions.
- `exact_score`: avoid by default because exact scalar scores are high variance.

## Field Hygiene

- `team_scores_first`: `claim_id`, `match_id`, `team_id` only.
- `team_wins_by_3plus`: `claim_id`, `match_id`, `team_id` only.
- `match_over_2_5_goals`, `match_2plus_goals`, `no_goal_stoppage_time`, cards, and timing claims: `claim_id`, `match_id` only.
- `player_scores`: `claim_id`, `match_id`, `player_id` only.
- `exact_score`: `claim_id`, `match_id`, `home_score`, `away_score` only.
