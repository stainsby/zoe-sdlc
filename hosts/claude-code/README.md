# Claude Code host adapter

The base is host-neutral; this folder is what Claude Code, specifically, needs. It lives
**alongside** `base/`, not inside it — host-specific packaging is not part of the base
proper. Adapt it freely. The base's prose rules bind regardless; these files add packaging,
not new behaviour. The same arrangement as the ZOE kernel's `hosts/claude-code/`, which you
will already have installed.

## Contents

- `check-install.sh` — verifies that this base is actually installed into your project.

## Why a check, when the install is small

Installing the base is three things: put this tree somewhere in your project, link its skills
where your host looks for skills, and add one import line beside the kernel's, pointing at
`base/instructions/zoe-sdlc.instructions.md` inside that tree. An AI that has just
installed the kernel can do all three by analogy, and this base deliberately ships no
step-by-step guide for it.

**Where you write that import line decides what it resolves against.** A relative `@` import
resolves against the directory of the file containing it. So
`@zoe-sdlc/base/instructions/zoe-sdlc.instructions.md` is right in a `CLAUDE.md` at your
project root, and wrong in `.claude/CLAUDE.md`, where it would look for
`.claude/zoe-sdlc/…` and quietly find nothing — write `@../zoe-sdlc/base/…` there instead.
An absolute path works from either. This is the same trap the kernel's adapter describes,
and the check below tests the import as you actually wrote it rather than assuming where you
put it.

What an AI cannot do is tell you it got it wrong. A broken `@` import produces no warning:
the session starts, looks entirely normal, and runs with no instructions and therefore no
gates. An AI that installed it wrongly is the one thing that cannot then report the fact. So
the check is the only part of the install that does not rest on the AI's own say-so.

## Running it

From your project root:

```sh
zoe-sdlc/hosts/claude-code/check-install.sh
```

The leading path is wherever you put this tree — `zoe-sdlc/` above, to match the import
example earlier. Run it from the project root rather than from the directory it lives in:
every path it tests is relative to the root, because that is where your `CLAUDE.md` and
`.claude/` are.

This base contains no path of its own, so where its tree lives is your choice. With no
argument the script guesses a few common locations for the base; pass the path if you put it
elsewhere:

```sh
zoe-sdlc/hosts/claude-code/check-install.sh .zoe-sdlc/base
```

A good install prints no `FAIL` and exits zero. The counts in its last line are the point,
not decoration: a check that only inspects what it happens to find will pass when it finds
nothing, which is exactly what happens when an import line was meant to be merged into an
existing `CLAUDE.md` and the merge got missed.

The two non-zero exits mean different things: **1** is the check running and finding faults
in your install; **2** is the check unable to run at all, because it could not find the base
tree — pass the path and run it again.

It is worth running again after any change to your skill links or your `CLAUDE.md`, and it
is cheap to add to whatever already runs your project's checks.
