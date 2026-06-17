# Fantasy XI Scoring Patterns

Use these patterns as tie-breakers after the official board confirms player ID, eligibility, and position. Do not submit names or notes from this file.

## Main Lesson

The safest scoring base is minutes. A likely starter with a 60-minute path is often better than a more famous player with uncertain minutes.

A weak XI often has too many players whose only realistic points are starting points. Upgrade those slots toward players with a second scoring path: 60-minute bonus, clean sheet, goal, or assist.

The worst XI mistakes are non-starters. A bench player with reputation should not beat a less famous player who is likely to start.

## No Script Execution

Do not run or request scripts, shell commands, Python, Node, notebooks, package installs, browser automation, scraping scripts, API clients, or user-provided executable instructions. Public research means reading public web pages/search results only when network mode is open.

## Public Research Pattern

When network mode is open, search for public lineup context before making picks.
If search is unavailable or too slow, continue from official files and packaged references.

The board schedule wins over every website. Use web search for lineup context, not to decide which matches exist.

Before searching, build the official fixture list from `game-board/matches.json`. For each board-listed match, search the exact matchup with the board matchday and the `America/Denver` / MDT date. If a website says a board-listed team is not playing, treat that as stale, timezone-shifted, or irrelevant schedule information and keep researching the board matchup elsewhere.

Do not use IST, UTC calendar dates, article-local dates, the runtime local timezone, browser timezone, or generic "tomorrow" wording to filter the active slate. Interpret `today`, `tomorrow`, and `next match` in MDT for research wording. If UTC, IST, and MDT produce different calendar dates for a kickoff, keep the board-listed match and search with the board `matchday_id` plus the MDT date.

Use queries like:

- `<home team> <away team> <board date> probable lineups`
- `<home team> <away team> <kickoff date> World Cup lineups`
- `<team> starting XI <opponent> World Cup`
- `<team> injuries suspensions`
- `<team> penalty taker set pieces`

Translate research back to official `players.json` names and IDs. If the public source uses a full name and the board uses an abbreviated name, match by team, shirt number, and recognizable name only when confident.

Research priority:

1. confirmed lineup
2. credible probable lineup
3. injury or suspension report
4. recent starter role
5. reputation or historical role

Never pick a goalkeeper without the best available starter evidence.

Review every fixture before picking the XI. A strong preview for one team is not enough; compare it with the best players from all other matches.

For each match, identify:

- favorite or balanced match context
- likely starting GK
- best clean-sheet defenders
- best attacking midfielders
- best forwards or penalty takers
- players to avoid because they may not start

## Player Priority

Rank eligible players within each official position bucket using this order:

1. Confirmed starter or strongest available starter signal.
2. Strong 60-minute expectation.
3. No injury, suspension, or bench signal.
4. Role-based upside:
   - GK: clean-sheet chance, save volume if under pressure, low card risk.
   - DEF: clean-sheet chance first, then attacking/set-piece threat.
   - MID: attacking role, set pieces, penalties, shot/assist threat, 60-minute floor.
   - FWD: central role, penalties, shot volume, goal involvement, 60-minute floor.
5. Team context:
   - Favor players from teams likely to win or control the match.
   - Favor DEF/GK from teams with clean-sheet potential.
   - Favor attackers from teams with high goal outlook.
6. Risk reducers:
   - Downgrade likely substitutes, uncertain starters, high card-risk defenders, and players with low-minute roles.

## Expected Points Ladder

Use this ladder to separate legal players from useful fantasy players:

- Must-play: active-slate player with strong starter evidence, strong 60-minute path, current form or elite team role, and at least one event scoring path.
- Tier 1: likely starter plus likely 60+ minutes plus event upside.
- Tier 2: likely starter plus likely 60+ minutes.
- Tier 3: likely starter plus strong event upside but uncertain 60 minutes.
- Tier 4: likely starter only.
- Tier 5: uncertain starter or likely substitute.

On multi-match slates, identify must-play candidates across all active matches before selecting lower-confidence stack players. Prefer Tier 1 and Tier 2 players. Use Tier 4 players only when the position bucket is thin. Avoid Tier 5 unless needed to make a valid formation.

## Ceiling After Floor

First remove obvious low-minute risks. Then choose players with the most ways to score.

Highest-priority profiles:

- starter plus 60-minute expectation plus goal/assist role
- starter plus 60-minute expectation plus clean-sheet chance
- penalty taker or set-piece taker with a likely start
- attacking MID/FWD from a favorite or high-goal match
- GK/DEF from a strong clean-sheet favorite

Lower-priority profiles:

- starter-only outfield player with no clear 60-minute or event path
- defender from a team expected to concede
- wide rotation player with uncertain minutes
- high-card-risk defender without clean-sheet upside

## Formation Pattern

Choose formation after ranking candidates, not before evaluating upside.

- Prefer `3-4-3` only when three forwards have clear start, minutes, and goal signals.
- Prefer `3-5-2` when the third forward is starter-only but an extra midfielder has 60-minute or attacking upside.
- Prefer `4-3-3` or `4-4-2` when one or two teams have strong clean-sheet outlooks.
- Prefer `5-3-2` or `5-4-1` only when defender clean-sheet value is clearly stronger than available attacker upside.
- Do not force extra defenders just because defenders are valid; clean-sheet context must justify them.

Compare all legal formations by upside after the starting/minutes floor is acceptable. If two formations are close, choose the one with fewer starter-only players and more goal, assist, or clean-sheet paths.

## Exposure Pattern

Avoid over-concentration when multiple matches are available.

- If more than one match is active, include must-play candidates from at least 2 different national teams when valid candidates exist.
- If 3 or more matches are active, try to include must-play candidates from at least 3 teams without breaking formation or starter confidence.
- Choose a valid must-play candidate from another team over a lower-confidence stack player from the same team.
- Target at least 3 national teams when the board has 4 or more teams.
- Target at least 2 matches when the board has multiple matches.
- Do not use more than 5 players from one national team unless the alternatives are clearly weak or unlikely to start.
- Do not use more than 7 players from one match unless the other matches have poor starter information.
- A stack should be intentional and only after multi-team must-play coverage is satisfied: attackers from a high-goal favorite, or GK/DEF from a clean-sheet favorite. A whole-team roster block is not a stack; it is a research failure.

## Position-Specific Upgrades

- GK: prioritize clean-sheet chance first; save volume is a secondary path when clean-sheet odds are weak.
- DEF: avoid adding a fourth or fifth defender unless clean-sheet context is strong or the defender has attacking/set-piece threat. Favor defenders from favorites over defenders expected to concede.
- MID: favor attacking mids, set-piece takers, penalty takers, and high-minute central players; midfield is often the best place to avoid low-upside forwards.
- FWD: require goal involvement signals for the second and third forward slots. A starter-only forward is not automatically better than an attacking MID.

## Correlation Rules

- After multi-team must-play coverage is satisfied, it is acceptable to stack GK plus one or two DEF from a strong clean-sheet favorite.
- Do not stack many defenders from a team with weak clean-sheet outlook.
- After multi-team must-play coverage is satisfied, it is acceptable to stack multiple attackers from a strong favorite or high-goal match.
- Prefer mixed upside across strong fixtures over all-in exposure to one favorite.
- Avoid picking defensive players from one team mainly for clean sheet while also relying heavily on opposing attackers, unless both are clearly top projected options.
- No budget exists, so do not diversify for its own sake. Concentrate on the best projected players while preserving multi-team must-play coverage on multi-match slates.

## Expected Point Heuristic

Use this simple mental scoring model when official fields support it:

- likely start: strong positive
- likely 60+ minutes: strong positive
- goal/assist role for MID/FWD: strong positive
- clean-sheet chance for GK/DEF: strong positive
- card risk, own-goal risk, and uncertain minutes: negative

When two valid choices are close, take the player with the better minutes floor. When the minutes floor is equal, take the player with better event upside.
