---
name: build-bracket
description: Submit knockout bracket picks once using official bracket slots, team IDs, and advancement scoring.
---

# Build Bracket

Use this skill when asked to submit the one-time knockout bracket, or when the provided answer schema includes bracket fields.

## Required Inputs

Read the tournament-provided files first:

- bracket answer schema
- bracket slots or knockout match structure
- teams file
- tournament standings and knockout qualifiers
- rules file
- package reference notes if present

Use only official bracket slot IDs and team IDs. If bracket fields are present in the answer schema and official bracket inputs are available, submit a complete bracket. Do not leave bracket picks empty on an active bracket prompt.

## One-Time Package Behavior

This skill must work without daily edits. Use official bracket slots, qualifiers, teams, and schema from the portal. If packaged reference notes are present, use them as priors for team strength and path difficulty only; official bracket eligibility and IDs always override packaged notes.

If a daily prompt also includes bracket fields, include bracket picks in the same final answer according to the current schema. If the scoring preview reports bracket as not active, do not invent bracket data outside the schema.

## Runtime Budget

Game-day and bracket runs must finish in under 4 minutes. Use the official bracket files first, then packaged reference notes if present. Keep the path consistent and avoid broad external research if it would threaten the time limit.

## Strategy

Bracket scoring rewards later-round accuracy more heavily than early contrarian picks:

- Round of 32 winner: +5
- Round of 16 winner: +8
- Quarterfinal winner: +12
- Semifinal winner: +18
- Champion: +30

Default approach:

1. Use team strength, path difficulty, injuries/suspensions, recent performance, and market consensus when available.
2. Prioritize getting the champion and semifinalists right.
3. Use a high-upside but plausible bracket. Favor strong title contenders, but do not make a fully chalk bracket if there are close matchups with meaningful upset value.
4. Use selective underdogs where the matchup is close, the favorite has a difficult path, or the underdog creates better expected bracket leverage.
5. Maintain internal consistency: a team cannot lose in one round and appear as a winner in a later round.

If current leaderboard position is provided and we are far behind near bracket lock, differentiation is valuable. Prefer one plausible non-favorite finalist or semifinalist rather than random early-round chaos. Still avoid low-probability champion picks unless catching leaders requires a high-variance path.

## Final Validation

Before answering:

- Check every winner team ID exists in the official teams file.
- Check every slot ID exists in the official bracket file.
- Check winners are eligible for each slot.
- Check advancement is internally consistent across rounds.
- Check champion appears as the final winner.
- Check output shape matches the current bracket answer schema exactly.

If bracket is active but required inputs are incomplete, use the official schema as the source of truth and make the most consistent valid bracket from available official teams and slots. If bracket is not active in the schema or scoring component, do not add bracket fields.
