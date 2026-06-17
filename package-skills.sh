#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$ROOT_DIR/skills"
DIST_DIR="$ROOT_DIR/dist"
FULL_STAGE_DIR="$DIST_DIR/full-package-root"
CORE_STAGE_DIR="$DIST_DIR/daily-core-package-root"
FULL_OUTPUT_ZIP="$DIST_DIR/agentic-fantasy-league-skills.zip"
CORE_OUTPUT_ZIP="$DIST_DIR/agentic-fantasy-league-daily-core.zip"
CORE_SKILLS=(pick-fantasy-xi choose-risk-play validate-submission explain-strategy)

export COPYFILE_DISABLE=1

if [[ ! -d "$SKILLS_DIR" ]]; then
  echo "Missing skills directory: $SKILLS_DIR" >&2
  exit 1
fi

if ! command -v bsdtar >/dev/null 2>&1 && ! command -v zip >/dev/null 2>&1; then
  echo "Need bsdtar or zip to create skill archives." >&2
  exit 1
fi

rm -rf "$DIST_DIR"
mkdir -p "$FULL_STAGE_DIR/skills" "$CORE_STAGE_DIR/skills"
cp "$ROOT_DIR/README.md" "$FULL_STAGE_DIR/README.md"
cp "$ROOT_DIR/README.md" "$CORE_STAGE_DIR/README.md"

count=0
for skill_dir in "$SKILLS_DIR"/*; do
  [[ -d "$skill_dir" ]] || continue

  skill_name="$(basename "$skill_dir")"
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    echo "Skill folder is missing SKILL.md: $skill_dir" >&2
    exit 1
  fi

  mkdir -p "$FULL_STAGE_DIR/skills/$skill_name"
  cp "$skill_dir/SKILL.md" "$FULL_STAGE_DIR/skills/$skill_name/SKILL.md"

  if [[ -d "$skill_dir/references" ]]; then
    cp -R "$skill_dir/references" "$FULL_STAGE_DIR/skills/$skill_name/references"
  fi

  count=$((count + 1))
done

if [[ "$count" -eq 0 ]]; then
  echo "No skill folders found under $SKILLS_DIR" >&2
  exit 1
fi

core_count=0
for skill_name in "${CORE_SKILLS[@]}"; do
  skill_dir="$SKILLS_DIR/$skill_name"
  if [[ ! -f "$skill_dir/SKILL.md" ]]; then
    echo "Core skill is missing SKILL.md: $skill_dir" >&2
    exit 1
  fi

  mkdir -p "$CORE_STAGE_DIR/skills/$skill_name"
  cp "$skill_dir/SKILL.md" "$CORE_STAGE_DIR/skills/$skill_name/SKILL.md"

  if [[ -d "$skill_dir/references" ]]; then
    cp -R "$skill_dir/references" "$CORE_STAGE_DIR/skills/$skill_name/references"
  fi

  core_count=$((core_count + 1))
done

full_file_count="$(find "$FULL_STAGE_DIR" -type f | wc -l | tr -d ' ')"
core_file_count="$(find "$CORE_STAGE_DIR" -type f | wc -l | tr -d ' ')"
if [[ "$full_file_count" -gt 30 ]]; then
  echo "Full package has $full_file_count files, but the portal limit is 30." >&2
  exit 1
fi
if [[ "$core_file_count" -gt 30 ]]; then
  echo "Daily-core package has $core_file_count files, but the portal limit is 30." >&2
  exit 1
fi

if command -v bsdtar >/dev/null 2>&1; then
  bsdtar -a -cf "$FULL_OUTPUT_ZIP" -C "$FULL_STAGE_DIR" README.md skills
  bsdtar -a -cf "$CORE_OUTPUT_ZIP" -C "$CORE_STAGE_DIR" README.md skills
else
  (cd "$FULL_STAGE_DIR" && zip -qr "$FULL_OUTPUT_ZIP" README.md skills)
  (cd "$CORE_STAGE_DIR" && zip -qr "$CORE_OUTPUT_ZIP" README.md skills)
fi

full_package_size="$(wc -c < "$FULL_OUTPUT_ZIP" | tr -d ' ')"
core_package_size="$(wc -c < "$CORE_OUTPUT_ZIP" | tr -d ' ')"
max_size="$((5 * 1024 * 1024))"
if [[ "$full_package_size" -gt "$max_size" ]]; then
  echo "Full package is $full_package_size bytes, but the portal limit is 5242880 bytes." >&2
  exit 1
fi
if [[ "$core_package_size" -gt "$max_size" ]]; then
  echo "Daily-core package is $core_package_size bytes, but the portal limit is 5242880 bytes." >&2
  exit 1
fi

rm -rf "$FULL_STAGE_DIR" "$CORE_STAGE_DIR"

echo "Wrote dist/$(basename "$FULL_OUTPUT_ZIP")"
echo "Packaged full package: $count skills, $full_file_count files, $full_package_size bytes."
echo "Wrote dist/$(basename "$CORE_OUTPUT_ZIP")"
echo "Packaged daily core: $core_count skills, $core_file_count files, $core_package_size bytes."
