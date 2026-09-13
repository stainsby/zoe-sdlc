#!/usr/bin/env bash
# Check that ZOE SDLC is actually installed into this project.
#
# Getting the install wrong fails silently. Claude Code gives no warning when an `@` import
# points at nothing, or when there is no import at all: the session starts, looks entirely
# normal, and runs with no instructions and therefore no gates. The counts below are the
# point, not decoration — a check that only inspects what it finds passes when it finds
# nothing, which is exactly what happens when a merge into an existing CLAUDE.md got missed.
#
# Usage, from your project root — the leading path is wherever you put this tree:
#   zoe-sdlc/hosts/claude-code/check-install.sh [path-to-base]
#
# Run it from the project root, not from the directory it lives in: that is where it looks
# for CLAUDE.md, .claude/CLAUDE.md and .claude/skills/. It also reads ~/.claude/CLAUDE.md,
# because an import written there loads too.
#
# With no argument it checks the base in the tree it sits in, which is right whenever this
# tree is kept whole. Pass the path to base/ only if you keep base/ apart from this folder.
# Either way it checks that your import and your skill links lead into that base, and not
# into some other copy of it.
#
# Prints FAIL lines and reads only. Two different non-zero exits:
#   1 — it ran and found faults in the install.
#   2 — it could not run the check at all: it could not find the base, or was not run from
#       the project root.
set -uo pipefail
# A cd that finds its directory through CDPATH also prints it, which would corrupt every
# $(cd … && pwd) below.
unset CDPATH

# Is this directory actually the ZOE SDLC base, rather than some other tree that happens
# to have a skills/ in it? Every skill this base ships is prefixed with the enterprise's
# full name, so that prefix is the test. Without it, a project with its own base/skills/
# gets a confident verdict on entirely the wrong directory.
is_base() {
  [ -d "$1/skills" ] || return 1
  [ -f "$1/instructions/zoe-sdlc.instructions.md" ] && return 0
  for d in "$1"/skills/zoe-sdlc-*/; do [ -d "$d" ] && return 0; done
  return 1
}

# The physical directory a path leads to, with links followed, so two routes to one place
# compare equal.
real_dir() { ( cd -- "$1" 2>/dev/null && pwd -P ); }

base="${1:-}"
if [ -z "$base" ]; then
  # This script sits at hosts/claude-code/ in the tree, so the base is two levels up. The
  # tree has to lie inside the directory the check runs from, because that is where it looks
  # for CLAUDE.md and .claude/; run from anywhere else, it would report faults that are not
  # there. The base is shown relative to that directory, which is how the reader put it.
  tree="$(real_dir "$(dirname -- "$0")/../..")"
  root="$(pwd -P)"
  case "$tree" in
    "$root"/*) base="${tree#"$root"/}/base" ;;
    *) echo "FAIL: the tree this script sits in is not inside the directory you ran it from. Run it from your project root, or pass the path to the base: $0 path/to/base" >&2
       exit 2 ;;
  esac
fi

is_base "$base" || {
  echo "FAIL: $base does not look like the ZOE SDLC base — no instructions/zoe-sdlc.instructions.md and no zoe-sdlc-* skill under $base/skills/. Pass its path: $0 path/to/base" >&2
  exit 2
}
base_real="$(real_dir "$base")"

fault=0

# --- 1. The instructions import resolves --------------------------------------
# A relative `@` import resolves against the directory of the file containing it, so test
# it as written rather than assuming where it was put. An absolute or ~ import does not:
# joining it to a directory turns a valid path into a relative one that cannot exist, and
# the check would then report a working install as broken.
n=0
read_files="CLAUDE.md, .claude/CLAUDE.md or ~/.claude/CLAUDE.md"
for f in CLAUDE.md .claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"; do
  [ -f "$f" ] || continue
  for imp in $(grep -o '@[^[:space:]]*zoe-sdlc\.instructions\.md' "$f"); do
    n=$((n+1)); p="${imp#@}"
    case "$p" in
      /*)  t="$p" ;;
      \~/*) t="$HOME/${p#\~/}" ;;
      \~)  t="$HOME" ;;
      *)   t="$(dirname "$f")/$p" ;;
    esac
    if [ ! -f "$t" ]; then
      echo "FAIL: import does not resolve: $f -> $t" >&2; fault=1
    elif [ "$(real_dir "$(dirname -- "$t")")/$(basename -- "$t")" != "$base_real/instructions/zoe-sdlc.instructions.md" ]; then
      echo "FAIL: import loads a different copy of the base, not $base: $f -> $t" >&2; fault=1
    else
      echo "ok   import  $f -> $t"
    fi
  done
done
[ "$n" -gt 0 ] || {
  echo "FAIL: no ZOE SDLC import line in $read_files — its instructions, and its rules, will not load" >&2
  fault=1
}

# --- 2. Every skill the base ships is linked ----------------------------------
ships=$(find "$base/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)
[ "$ships" -gt 0 ] || { echo "FAIL: the base tree at $base ships no skills" >&2; exit 2; }

linked=0
for d in "$base"/skills/*/; do
  name="$(basename "$d")"
  l=".claude/skills/$name"
  if [ -e "$l" ]; then
    if [ "$(real_dir "$l")" = "$base_real/skills/$name" ]; then
      linked=$((linked+1))
    else
      echo "FAIL: $l is not the skill in $base — it leads to $(real_dir "$l")" >&2
      fault=1
    fi
  elif [ -L "$l" ]; then
    # A link that is there but points at nothing. Counted as a fault here, but reported
    # once only — by the sweep below, which visits every link and would otherwise say it
    # a second time.
    fault=1
  else
    echo "FAIL: skill not linked into .claude/skills/: $name" >&2
    fault=1
  fi
done

# --- 3. And no link in .claude/skills/ dangles, whoever put it there -----------
# Not the same test as above, which only looks at skills the base currently ships. A
# skill removed or renamed by a base upgrade leaves a link behind that the loop above
# never visits, and a dangling link is a skill the host silently does not load.
for l in .claude/skills/*; do
  [ -L "$l" ] || continue
  [ -e "$l" ] || { echo "FAIL: dangling skill link: $l" >&2; fault=1; }
done

if [ "$fault" -eq 0 ]; then
  echo "ok   skills  $linked of $ships linked from $base/skills/"
  echo "ZOE SDLC install check: $n import, $linked skills — OK"
else
  echo "ZOE SDLC install check: FAILED ($linked of $ships skills linked, $n import line(s))" >&2
fi
exit "$fault"
