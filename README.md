<p align="center">
  <img src="docs/images/zoe_logo.svg" alt="ZOE — Zero Organisation Enterprises" width="480">
</p>

# ZOE SDLC (Software Development Lifecycle)

An agentic skill set for running a software project. Humans act as 'directors',
while the AI agents manage everything else. It specialises the overarching
[ZOE (Zero Organisation Enterprises)](https://github.com/stainsby/zoe-kernel)
skills for your software project, creating processes that audit and improve
themselves with minimal supervision.

## Contents

One instructions file — [`zoe-sdlc.instructions.md`](base/instructions/zoe-sdlc.instructions.md),
carrying the rules that apply across everything — and ten skills. Five are actions,
run to do a piece of work; five are understanding, read for what they define rather
than run:

| Skill | Kind | What it covers |
|---|---|---|
| [`zoe-sdlc-adopt`](base/skills/zoe-sdlc-adopt/SKILL.md) | action | bringing a project — new or existing — under this process |
| [`zoe-sdlc-components`](base/skills/zoe-sdlc-components/SKILL.md) | understanding | breaking a system into components and capabilities, and naming them |
| [`zoe-sdlc-tasks`](base/skills/zoe-sdlc-tasks/SKILL.md) | understanding | what every task has to record |
| [`zoe-sdlc-sequencing`](base/skills/zoe-sdlc-sequencing/SKILL.md) | understanding | the order every change follows, and what "complete" means |
| [`zoe-sdlc-templates`](base/skills/zoe-sdlc-templates/SKILL.md) | understanding | what a template is here, and how to use one |
| [`zoe-sdlc-stories`](base/skills/zoe-sdlc-stories/SKILL.md) | action | user stories — writing down what someone wants, in their words |
| [`zoe-sdlc-specify`](base/skills/zoe-sdlc-specify/SKILL.md) | action | writing a component's specification |
| [`zoe-sdlc-develop`](base/skills/zoe-sdlc-develop/SKILL.md) | action | running a piece of implementation work |
| [`zoe-sdlc-fix`](base/skills/zoe-sdlc-fix/SKILL.md) | action | fixing a defect |
| [`zoe-sdlc-audits`](base/skills/zoe-sdlc-audits/SKILL.md) | understanding | the four checks that keep intent, documents and software in line |

## Usage

Clone or copy the ZOE kernel repo as well as this one and point your AI at the
instructions files and the skills under `kernel/` in ZOE kernel and `base/`
in ZOE SDLC. Once it can see the instructions and skills, ask it how to
proceed. It will guide you through the first draft of your charter and into
the first cycle.

Alternatively, get your AI to read *this* file and help you wire in the
instructions and skills.

We are also investigating Claude plugins to make setup even smoother — stay
tuned.

## Adaptability

Unlike its precursor, [PAPI](https://github.com/stainsby/papi), ZOE SDLC
is minimally opinionated, and in general does not prescribe files, paths or
formats. The vast majority of how things run, where things are stored, and so
on, is decided during setup and refined as time goes on. Your ZOE should
be able to work with your existing system and tools however you wish.

## Immutability

The instructions and skill files here are intended to be read-only to your
project. Instead, agents specialise your ZOE by adding more skills alongside
these.

## Origin

ZOE SDLC is the successor to the
[PAPI Skills](https://github.com/stainsby/papi) project, whose process ideas
it generalises. The PAPI project suffered from a lack of more general skills,
which led to the ZOE kernel project, the parent of ZOE SDLC.
