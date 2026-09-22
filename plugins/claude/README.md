# The ZOE SDLC plugin for Claude

This folder packages ZOE SDLC as a plugin for Anthropic's Claude products, so that it installs
the way the ZOE kernel's plugin does, instead of by linking skills by hand as
[`hosts/claude-code/README.md`](../../hosts/claude-code/README.md) describes. It sits beside
`base/`, not inside it: packaging is not part of the base, and the base's rules bind whichever
way it arrives.

Everything here is specific to one provider. `plugin.json` and `.claude-plugin/` are
Anthropic's formats. Another provider's plugin would get its own `plugins/<provider>/` beside
this one.

## Installing

The plugin is listed in the ZOE catalogue, beside the kernel's own:

```sh
claude plugin marketplace add stainsby/zoe-plugins
claude plugin install zoe-sdlc@zoe
claude plugin enable zoe-sdlc@zoe
```

It depends on the kernel's plugin, `zoe-kernel`, so installing and enabling this one installs
and enables that one too, even though the kernel's plugin arrives switched off on its own. Then,
in the project that is to become the enterprise:

1. ask Claude to set ZOE up, which runs the kernel's `zoe-claude-init`;
2. ask Claude to set up ZOE SDLC, which runs this plugin's `zoe-sdlc-claude-init`.

Where a Claude product offers no command line, the same steps are in its own interface. A
package at `dist/claude/plugin.zip` can also be uploaded directly to the Claude products that
take a plugin as a file.
Claude's documentation does not say whether an uploaded plugin's dependency is installed for
it, so upload the kernel's package first.

## What arrives

- the base's ten skills;
- `zoe-sdlc-claude-init`, the one skill added;
- `VERSION` and `CHANGELOG.md`, so a project can tell which release it has and what changed.

The base ships no agents, so the plugin has none.

## The instructions

The base's instructions hold the points where a person approves before work goes on, so they
have to be in front of the model before it decides anything. A plugin cannot make that happen
by itself: a `CLAUDE.md` at a plugin's root is not read as project context. The setup skill
closes that gap, as the kernel's does. It copies the instructions file and `VERSION` into the
project's `.zoe-sdlc/` folder, then:

- **in Claude Code**, adds one import line to the project's `CLAUDE.md`;
- **in Cowork**, gives the person one sentence to add to the project's **Instructions**
  field, since nothing else can set it;
- **anywhere with neither**, records in the enterprise's index that the file is read at the
  start of every session, and that nothing enforces it.

The copy is pinned. A plugin update replaces the skills for every project on the machine at
once, but never the copied instructions, so the rules a project runs under change only when
its director approves a newer release and the setup skill runs again. It is kept apart from the
kernel's `.zoe/`, so neither setup skill touches the other's files.

## Checking the install

On this route nothing is linked by hand, so `hosts/claude-code/check-install.sh` does not
apply. The setup skill ends with the check instead: exactly one import line for the base's
instructions resolves, the project's copy of the instructions is byte-identical to the released
text in the plugin, and the project's `.zoe-sdlc/VERSION` matches the plugin's. In Cowork,
the instruction the person pasted cannot be read back, so the check there rests on their
confirmation, and the skill says so.

## Upgrades

A plugin update brings new skills straight away, while the pinned instructions stay at the
older release until the director approves the change. **Nothing notices this on its own.**
After updating the plugin, ask Claude to run `zoe-sdlc-claude-init` again. It finds that the
project's `.zoe-sdlc/VERSION` and the plugin's differ, reads out what the changelog says changed
between them, and copies nothing until the director approves.

The dependency on the kernel allows any 1.x release from 1.4.1, the oldest this base is known
to work with; it was last checked against 1.5.0. If the kernel's plugin is outside that range, Claude Code reports a dependency
error and disables this plugin until it is resolved, which here means a release of the base
that accepts the newer kernel.

## Building

`build.sh` is the release step. From the repository root:

```sh
plugins/claude/build.sh
```

It reads the version from `base/VERSION` and writes it into `plugin.json`, copies in the base's
skills, leaving out any file git ignores, generates `zoe-sdlc-claude-init` from
`zoe-sdlc-claude-init.template.md`, the base's instructions file and `base/VERSION`, adds the
licence, `VERSION` and `CHANGELOG.md`, checks the counts and versions agree, and validates the
plugin with `claude plugin validate --strict`. It writes the package only if every check
passed, so a failed build leaves the committed package as it was.

The package always lands at `dist/claude/plugin.zip`, with no version in the path, so anything
pointing at it keeps pointing at it. It is built with a sorted file list and fixed timestamps,
so rebuilding unchanged content gives a byte-identical file.

**Release order.** The package embeds the version from `base/VERSION`, so it is rebuilt after
the version is raised and committed with the release. Listing it in the catalogue happens in
the catalogue's own repository, `stainsby/zoe-plugins`, as its `registering-a-plugin.md` sets
out: `scripts/update-plugin.py` on this zip, a `category` added to the entry, and
`scripts/validate.py` run, all in a pull request there.

Things worth knowing if you change it:

- **The setup skill and the package are generated.** Edit the template, or the base's
  instructions, and build again.
- **Do not declare component paths in `plugin.json`.** Claude Code, Cowork and the validator
  read them differently.
- **Keep catalogue fields out of `plugin.json`.** `category`, `tags`, `source` and `strict`
  belong to the catalogue entry, and the catalogue's validator refuses a plugin that carries
  them. The build checks this too.
