# Improvements

## Skill Reliability Improvements

| Change | Severity | Impact | Status |
| --- | --- | --- | --- |
| Keep Fantasy XI formation choice flexible, but require one legal formation before selecting IDs. | Critical | Prevents invalid outputs such as 2 GK, too few defenders, or too many forwards while still allowing the agent to optimize formation. | Implemented |
| Compute Fantasy XI counts from `game-board/players.json`, not from strategy text or assumed player roles. | Critical | Ensures validation follows the same source of truth as the portal validator. | Implemented |
| Keep Fantasy XI validation inside `pick-fantasy-xi`, not only in `validate-submission`. | Critical | Reduces risk when the sample runtime invokes only the daily XI skill and skips helper skills. | Implemented |
| Keep the skills compact and remove long competing heuristics. | High | Lowers hallucination risk and keeps the model focused on validity before upside. | Implemented |
| Keep Risk Play aggressive but official-ID bounded. | Medium | Preserves upside while avoiding invalid claim fields, team-match mismatches, and extra metadata. | Implemented |
| Keep strategy text generic and avoid unsupported formation/player claims. | Medium | Prevents misleading explanations such as claiming a legal formation when the actual IDs fail validation. | Implemented |
| Add an internal scratch bucket requirement: `GK`, `DEF`, `MID`, `FWD` lists before final JSON. | High | Makes counting more explicit and may reduce repeated position-count failures. | Implemented |
| Move the final Fantasy XI count gate to the last block of `pick-fantasy-xi`. | Medium | Gives the model a final checklist immediately before output. | Implemented |
| Keep a daily-core ZIP separate from the full package. | Medium | For league daily submissions, this reduces unrelated bracket/validation surface while preserving the fuller package for future modes. | Implemented |
| Add a compact output-shape guard against stale sample formats. | High | Prevents the agent from returning old sample shapes such as nested `answers`, `record_id` objects, or extra top-level fields. | Implemented |

## Sample Repo Review Findings

| Finding | Severity | Impact | Status |
| --- | --- | --- | --- |
| Treat the current workspace prompt, rules, and `output-format/daily-submission.schema.json` as the source of truth. | High | Avoids copying stale sample instructions that conflict with the accepted top-level daily JSON shape. | Accepted |
| Avoid stale output shapes such as `answers.fantasy_xi`, `{ "record_id": "match_id:player_id" }`, `team_name`, or nested `strategy_summary`. | High | Prevents schema failures when older examples conflict with the current portal schema. | Implemented |
| Prefer `dist/agentic-fantasy-league-daily-core.zip` for normal league daily submissions. | Medium | Keeps the submitted package closer to the official sample package and avoids unnecessary bracket instructions during league play. | Accepted |

## Proposed Next Improvements

| Change | Severity | Impact | Status |
| --- | --- | --- | --- |
| Add an explicit matchday eligibility gate: every selected player must include the current `matchday_id` in `eligible_matchday_ids` when that field is present. | Medium | Aligns with `rules/fantasy-xi.md` and protects against future boards where the player pool includes non-current players. | Proposed |
| Add concise examples of valid and invalid count summaries. | Medium | Helps the model distinguish legal formations from invalid lookalikes without adding much complexity. | Proposed |
| Add compact generated references for player priors only after validation stabilizes. | Low | Could improve scoring upside, but should not be added until formation reliability is consistently passing. | Deferred |

## Current Priority

Reliability is more important than scoring optimization. The package should first pass the sample runtime consistently by producing valid Fantasy XI JSON from the sample board. Player-quality heuristics and richer Risk Play logic should remain secondary until validation failures stop recurring.
