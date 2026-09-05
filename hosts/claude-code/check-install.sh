#!/usr/bin/env bash
# Check that ZOE SDLC is actually installed into this project.
#
# Getting the install wrong fails silently. Claude Code gives no warning when an `@` import
# points at nothing, or when there is no import at all: the session starts, looks entirely
# normal, and runs with no instructions and therefore no gates. The counts below are the
# point, not decoration — a check that only inspects what it finds passes when it finds
# nothing, which is exactly what happens when a merge into an existing CLAUDE.md got missed.
#
# Usage, from your project root:
#   hosts/claude-code/check-install.sh [path-to-the-base-tree]
#
# The base tree is wherever you put it — this base contains no path of its own, so the
# default below is a guess. Pass the path if you put it somewhere else:
#   ./check-install.sh .zoe-sdlc/base
#
# Prints FAIL lines and exits non-zero on any fault. Reads only.
set -uo pipefail

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

base="${1:-}"
if [ -z "$base" ]; then
  for guess in base sdlc zoe-sdlc/base .zoe-sdlc/base .sdlc/base; do
    is_base "$guess" && { base="$guess"; break; }
  done
fi

[ -n "$base" ] || {
  echo "FAIL: cannot find the ZOE SDLC base tree. Pass its path, e.g. $0 zoe-sdlc/base" >&2
  exit 2
}
is_base "$base" || {
  echo "FAIL: $base does not look like the ZOE SDLC base — no instructions/zoe-sdlc.instructions.md and no zoe-sdlc-* skill under $base/skills/" >&2
  exit 2
}

fault=0

# --- 1. The instructions import resolves --------------------------------------
# A relative `@` import resolves against the directory of the file containing it, so test
# it as written rather than assuming where it was put. An absolute or ~ import does not:
# joining it to a directory turns a valid path into a relative one that cannot exist, and
# the check would then report a working install as broken.
n=0
for f in CLAUDE.md .claude/CLAUDE.md; do
  [ -f "$f" ] || continue
  for imp in $(grep -o '@[^[:space:]]*zoe-sdlc\.instructions\.md' "$f"); do
    n=$((n+1)); p="${imp#@}"
    case "$p" in
      /*)  t="$p" ;;
      \~/*) t="$HOME/${p#\~/}" ;;
      \~)  t="$HOME" ;;
      *)   t="$(dirname "$f")/$p" ;;
    esac
    if [ -f "$t" ]; then echo "ok   import  $f -> $t"
    else echo "FAIL: import does not resolve: $f -> $t" >&2; fault=1; fi
  done
done
[ "$n" -gt 0 ] || {
  echo "FAIL: no ZOE SDLC import line anywhere — its instructions, and its rules, will not load" >&2
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
    linked=$((linked+1))
  else
    [ -L "$l" ] && echo "FAIL: dangling skill link: $l" >&2 \
                || echo "FAIL: skill not linked into .claude/skills/: $name" >&2
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
