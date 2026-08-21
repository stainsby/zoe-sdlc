# Changelog

## 0.5.0 — 2026-08-21

The largest change to the base since it was first written, and the first one
driven by checks rather than by new ideas. Three separate reviews ran against
0.4.0 — the two release checks the base requires of itself, and a re-reading of
the project this base was distilled from — and then the whole of it was
rewritten in plain English and stripped of anything the ZOE kernel or another
base skill already said. It is a quarter shorter and says more.

No skill or instructions file is renamed. Two adoption decisions are removed as
the kernel's job, two are added, and one rule about when a project is finished is
genuinely new — see *Upgrading*. One term changed: a component cut off from the
dependency graph is now called **disconnected** rather than orphaned.

### Rules that nothing set up

From the first of the two checks this base runs before a release, which asks of
every rule the base states: what step brings this into being?

- **Nothing established a project's environments.** Two rules rested on them,
  including the acceptance test — the only check that touches running software.
  A project could have run acceptance tests against something resembling
  production in no way at all and broken no stated rule. Now an adoption
  decision.
- **The charter audit's timing** was said to be "set at adoption" by a step
  that did not exist. Three of the four checks start on an event; that one has
  none, so without a time it never runs. Now an adoption decision.
- **The task store was chosen without asking whether it could hold anything.**
  Adoption picked whatever the project already used and never checked it could
  carry what a task must record. Free in plain files; a configuration job in a
  hosted tracker; quietly skipped if nobody asks.
- **A story's status was required, undefined, and depended on by name.**
  `zoe-sdlc-stories` asked for a status, never said what the values were, then
  referred elsewhere to "ready" stories — a value nothing defined. The project
  still names its own; one of them must now mean *finished, and ready to build
  from*.
- **The list of task types named one that does not ship** (audit) and omitted
  two that do (specifying, writing stories). Corrected.
- **The charter audit read as requiring a citation the base forbids.** "Every
  story names the part of the charter it serves" — taken literally, an auditor
  would have marked every story an orphan. The link is made by the audit, never
  carried in the story.

### Where the kernel had moved underneath

From the second of those checks, run because the base had never been re-read
against the kernel version it now sits on.

- **The base still required what the kernel retired.** Kernel 1.2.0 stopped
  demanding that every defect's cause be turned into a planning item — "nothing
  worth fixing" became a complete answer — and said outright that any rule
  built on the old wording could be retired. The base was such a rule, one
  level up, still making the same demand of adopting projects. Its improvement
  rules now match.
- **Audits were not repeatable.** They required fresh eyes and a fresh start,
  neither of which stops two runs over an unchanged project from disagreeing.
  An audit now runs against a written procedure, kept with it.

### Value that never landed

From re-reading the source project this base was distilled from, asking not
"did every item get a label?" but "did the value behind it arrive?"
Three had not, all the same mistake: something concrete in the source became
abstract here, correctly, and nothing replaced the concreteness.

- **"Complete" now means three things at three levels**, and passing the lowest
  does not earn the highest. A task completes on its tests. A specification
  edition completes on a passed compliance audit. A release, or the project
  itself, completes only when all four checks have passed. The source said a
  project could not be called finished until all four verification activities
  passed; the base had kept only the lowest two, so a project could ship on
  green tests with none of the four ever run.
- **What counts as one session** is now an adoption decision. The base sizes
  both tasks and leaf components at "one working session" and never said what
  that was. The source gave a number; dropping it was right, replacing it with
  nothing was not, since an oversized leaf is called a defect and a defect has
  to be identifiable in advance.
- **The project's engineering practices** are now an adoption decision. Step 6
  of the sequence has always required code to respect them, and nothing ever
  said what they were.

### Language and overlap

- **`zoe-sdlc-adopt` is now an extension of the kernel's `zoe-setup`**, which
  it lists as required reading. Two of its decisions turned out to be things
  `zoe-setup` already asks for — where each kind of record is kept, and which
  independent checks the enterprise needs — and are gone, along with two rules
  it also already states.
- **Everything the kernel or a sibling skill already said was cut.** The
  instructions lost an entire section on reporting to the human and both
  root-cause rules, all of which the kernel states. `zoe-sdlc-specify` stopped
  restating three rules from `zoe-sdlc-components`; `zoe-sdlc-tasks` stopped
  restating the kernel on decomposition and completion criteria;
  `zoe-sdlc-audits` stopped repeating its own shared rules inside its
  per-activity sections.
- **Every skill's description now says what it is for and when to reach for
  it**, because that description is all an agent sees before deciding whether
  to open the file. The `When to read` lines inside the files, and every
  `Purpose` line, went with it — they were saying the same thing one level too
  deep to be useful.
- **The writing was taken apart and put back plainly.** Gone: the "audit
  ladder" and its "rungs", "stand up", "the currency of the model", "the
  vehicle that carries a change", "test-gated completion", "story corpus",
  "grooming scope", "decomposing an epic", "happy-path-only", "debug shims and
  back channels", "mechanical rather than archaeological", "invariant",
  "instantiate", "conformance pre-pass", "cadence", "artifact", "cross-cutting
  trait", "the arc". The base tells adopters to write in plain English; it now
  does so itself. This matters more than it looks: the words in a file only an
  AI reads still shape the words that AI writes back to a person.
- **Then a second pass over the language, once the rest of the release was
  written.** Every term in the base was checked against one question: would a
  business analyst who has never seen this project follow it? Around sixty terms
  were listed, each with the decision made about it. No rule changed, nothing was
  renamed, and nothing was added to or removed from the process. Metaphors were
  replaced with what they meant — "the wiring of the system" is now "how the
  system connects together", a story no longer "hangs off" its index, and a step
  is not skipped "by momentum". Terms of art are now explained where they are
  first used: "graph", "specification edition", "external component". The arrows
  in the audits table are written out as words.
- **"Orphan" meant two different things, and now means one.**
  `zoe-sdlc-components` used "orphaned" for a component cut off from the
  dependency graph; `zoe-sdlc-audits` uses "orphan" for work that serves nothing
  anyone asked for, which is a finding a person has to settle. Two unrelated
  problems sharing one word, in two files that are read together. The graph one
  is now **disconnected** — in the skill, in the example script's printed
  report, and in the script's own results key. The example script therefore
  changed in code as well as in comments; what it does is unchanged.
- **`README.md` and `zoe-sdlc-adopt` are unchanged.** Both were proposed for
  rewording in that second pass and the changes were not taken.

### Two steps that were missing altogether

- **Reproduce the defect.** `zoe-sdlc-fix` went straight from capturing what
  happened to writing a failing test, with nothing in between. Until it can be
  made to happen on demand, any fix is a guess.
- **Write or update the story**, where the change is something outside the
  system will notice. It is now step 1 of the sequence. The charter audit, the
  fulfilment audit and the whole acceptance test depend on stories existing,
  and the order of work never once mentioned them.

### Upgrading from 0.4.0

No skill, instructions file or rule is renamed, so no reference breaks.

- **If you copied the example capability-graph script**, note that the base's
  copy now prints "DISCONNECTED NODES" where it used to print "ORPHANED NODES",
  and the same key in its results is now `disconnected` rather than `orphans`.
  Your copy is yours to change or leave; what the check does is unchanged either
  way.
- **Record two more decisions**: the project's environments, and how often the
  charter audit runs. Then check the task store really holds what a task must
  record, rather than being assumed to.
- **Two decisions are no longer this base's to ask for** — where records are
  kept, and who provides independent audit eyes. `zoe-setup` covers both.
- **A release is no longer complete on passing tests alone.** If your project
  has been calling releases done that way, all four checks now have to pass for
  the work in question. This is the one change that can make a currently
  "finished" release not finished.
- If you built anything on the old "every improvement signal is routed" rule,
  it can be relaxed to the kernel's three answers.

Declined, with the reason recorded: the base adds process to every project that
adopts it and contains nothing asking whether that process costs more than it
returns. The kernel asks this of any enterprise already, and a rule in the base
complaining about rules in the base would be the thing it complains about.

## 0.4.0 — 2026-08-09

All of it from one sweep of the base, which asked of every rule it states: what
step brings this into being? Three obligations turned out to
have no answer — the same defect class as 0.3.0's mechanical checks.

- `zoe-sdlc-adopt` 3 → 4: two more adoption decisions. **The verification
  setup** — how the project's tests are run, what "all relevant tests" resolves
  to, where the evidence is kept — because every completion claim the process
  makes rests on tests passing, and adoption never asked. A project with no way
  to run tests records standing one up as its first piece of work. **The
  audit-independence arrangement** — who or what inspects work it did not
  produce.
- `zoe-sdlc-audits` 1 → 2: a "When each is due" paragraph. Only the compliance
  audit had a trigger, so three quarters of the ladder was optional by
  omission. Also states that independence must be arranged somehow — an audit
  run by the author of the work produces a passing record with nothing behind
  it, which looks like coverage and is worse than no audit.
- `zoe-sdlc-templates` 1 → 3: the template lineage now falls back to the most
  generic template the project holds, rather than to a base form this base does
  not ship and never intended to. Also dropped a parenthesis naming the
  predecessor project the base was distilled from, and the inline-guidance
  format it used — adopters have not heard of either.
- `zoe-sdlc-specify` 1 → 2: the graph-validation paragraph listed three of the
  four ways `zoe-sdlc-components` says a graph can be invalid. The fourth — a
  capability depending on another capability of its own component — is now
  listed with the rest.

Upgrading from 0.3.0: two adoption decisions are new. An adopter already running
should record how its tests are run and how its audits get independent eyes, and
set a cadence for the charter audit. Nothing is renamed or removed.

Declined, with the reason recorded: nothing creates the story parent index that
`zoe-sdlc-stories` produces stories into. The first story task creates it, and
the artifact is described where it is produced.

## 0.3.0 — 2026-08-09

Nothing is renamed or removed, so no reference breaks on upgrade. The release
does add two obligations an existing adopter has to act on — see Upgrading.

Fix: the base required mechanical checks that nothing told an adopter to build.
`zoe-sdlc-components` makes graph validity and the two-direction traceability
sweep mechanical invariants, and `zoe-sdlc-specify` says to run the graph
check — but adoption never stood either one up.

- `zoe-sdlc-adopt` 1 → 3: new step 3, "Stand up the mechanical checks" — decide
  the declared form, put a check in place that reports the failures the model
  names, run it where the project runs its tests. Recorded as an adoption
  decision like the store and the identifier convention. A third check joins
  the two: that references between the project's own documents resolve.
  References break silently, and a rename upstream is enough to cause it.
- `zoe-sdlc-components` 1 → 3: names a script as the usual way to hold the four
  validity rules (the rules stay the invariant), and says the traceability
  sweep is a check the project runs, not a reading it performs. Also separates
  the two senses of "user-facing": for a component it says where the component
  sits, for a capability it says whose intent it serves, and a component away
  from the boundary may own story-fulfilling capabilities without
  contradiction.
- `zoe-sdlc.instructions.md`: new section, "Reporting to the human". The base
  made human review mandatory at five points and then said nothing about what
  reaches the human there, which left the shape of every such artifact to
  whichever skill produced it — and those are organised around process. The
  rule: lead with the product, process last and only where it changes a
  decision, say what was found wrong including in your own work, no padding. A
  default order is offered as an example, not a required form.
- New asset `zoe-sdlc-components/assets/validate_capability_graph.py`: a
  working example of the graph check. It reads dependency blocks from
  specification files and reports all four ways the model says a graph can be
  invalid — loops, references to capabilities nothing defines, disconnected
  nodes, and a capability depending on another capability of its own component
  — plus unrecognised fields, exiting non-zero so it can fail a build. Every
  condition it assumes — declaration format, identifier convention, repository
  layout, the libraries it uses — is stated at the top of the file, so it reads
  as a starting point to adapt rather than a format the base prescribes.

Upgrading from 0.2.0:

- Stand up the three mechanical checks. Adoption previously named none, so an
  adopter already running will have none of them.
- Apply the reporting rule to anything already going in front of a human. It
  changes the shape of existing artifacts, not just new ones.

Provenance: the "user-facing" ambiguity and the reporting gap were both raised
by an adopting project against 0.2.0, as was the missing reference check —
found when a 0.2.0 rename left an instruction import pointing at a file that no
longer existed, which failed silently.

## 0.2.0 — 2026-08-08

Breaking: every skill and the instructions file are renamed to carry the full
`zoe-sdlc-` prefix (director decision 2026-08-08). The old bare `sdlc-` prefix
claimed a generic name that any other base could also want, and would clash
once sub-enterprises ship bases of their own. A base's skills now carry the
full name of the enterprise that ships them.

- Skills renamed: `sdlc-tasks` → `zoe-sdlc-tasks`, and the same for
  `-components`, `-sequencing`, `-templates`, `-audits`, `-adopt`, `-specify`,
  `-stories`, `-develop`, `-fix`. Content unchanged.
- Instructions renamed: `sdlc.instructions.md` → `zoe-sdlc.instructions.md`.
- Upgrading from 0.1.0: an adopter must update any reference to the old names.
  No adopters existed at the time of this release.

## 0.1.0 — 2026-07-20

First release of the SDLC base (director-approved 2026-07-20):

- Skills: `sdlc-tasks`, `sdlc-components`, `sdlc-sequencing`, `sdlc-templates`,
  `sdlc-audits` (understanding); `sdlc-adopt`, `sdlc-specify`, `sdlc-stories`,
  `sdlc-develop`, `sdlc-fix` (action). Renamed in 0.2.0.
- Instructions: `sdlc.instructions.md` (oversight, artifacts, style,
  continuous process improvement). Renamed in 0.2.0.
- Language: all base content follows the plain-language rule (plain,
  business-analyst-level English; technical terms only where genuinely
  needed, explained at first use), enshrined in the enterprise charter
  2026-07-19 and carried to adopters as their default.
- Provenance: distilled from the PAPI Skills project under a full disposition
  audit — every PAPI skill, instruction, and concept explicitly generalised or
  dropped with reasons (register maintained by the ZOE SDLC enterprise).
