# Claude Code host adapter

The base is host-neutral; this folder is what Claude Code, specifically, needs. It lives
**alongside** `base/`, not inside it — host-specific packaging is not part of the base
proper. Adapt it freely. The base's prose rules bind regardless; these files add packaging,
not new behaviour. The same arrangement as the ZOE kernel's `hosts/claude-code/`, which you
will already have installed.

## Contents

- `check-install.sh` — verifies that this base is actually wired into your project.

## Why a check, when the wiring is small

Installing the base is two things: link its skills where your host looks for skills, and add
one import line beside the kernel's, `@<your path>/base/instructions/zoe-sdlc.instructions.md`.
An AI that has just installed the kernel can do both by analogy, and this base deliberately
ships no step-by-step guide for it.

What an AI cannot do is tell you it got it wrong. A broken `@` import produces no warning:
the session starts, looks entirely normal, and runs with no instructions and therefore no
gates. An AI that wired it up wrongly is the one thing that cannot then report the fact. So
the check is not documentation you can skip — it is the only part of the install that does
not rest on the AI's own say-so.

## Running it

From your project root:

```sh
hosts/claude-code/check-install.sh [path-to-the-base-tree]
```

This base contains no path of its own, so where its tree lives is your choice. The script
guesses a few common locations; pass the path if you put it elsewhere:

```sh
hosts/claude-code/check-install.sh .zoe-sdlc/base
```

It must print no `FAIL` and exit zero. The counts in its last line are the point, not
decoration: a check that only inspects what it happens to find will pass when it finds
nothing, which is exactly what happens when an import line was meant to be merged into an
existing `CLAUDE.md` and the merge got missed.

Re-run it after any change to your skill links or your `CLAUDE.md`.
