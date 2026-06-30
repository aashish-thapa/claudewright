# claudewright

> Senior-engineer discipline for AI coding. SOLID, DRY, separation of concerns, and a strict PR reviewer in your terminal.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-8A2BE2)](https://code.claude.com/docs/en/plugins)
[![2 skills](https://img.shields.io/badge/skills-2-2ea44f)](#whats-inside)

---

Modern AI coding agents produce code that compiles, passes tests, and ships. A senior engineer reading the diff sees five principles violated, a `switch` statement that should be polymorphism, and a class doing four things wearing one name.

**claudewright** is the opposite of "vibe coding." It's a single Claude Code plugin that ships two skills:

- A **discipline skill** that teaches Claude 16 system design principles (SOLID, DRY, separation of concerns, composition root, illegal-states-unrepresentable, ...) plus a code-discipline rulebook for commits, comments, scope, and verification.
- A **senior-review skill** that channels the strict, abstraction-loving reviewer who used to send your PRs back four times — the one who reduced your 100-line function to a 10-line one and wrote the rewrite inline. Now you get him on demand.

A "wright" is a craftsperson: millwright, playwright, shipwright. **claudewright** is what your Claude becomes when you install this.

## Install

Inside Claude Code:

```
/plugin marketplace add aashish-thapa/claudewright
/plugin install claudewright@claudewright
```

That's it. Both skills auto-load. No `settings.json` surgery required.

To pick up future updates: `/plugin marketplace update claudewright`.

## What changes about your AI's code

**Before** — Claude writes the obvious thing:

```python
def area(shape):
    if shape.kind == "circle":   return 3.14 * shape.r ** 2
    elif shape.kind == "square": return shape.side ** 2
    elif shape.kind == "tri":    return 0.5 * shape.base * shape.height
```

**After** — Claude reaches for the seam first:

```python
class Shape(Protocol):
    def area(self) -> float: ...

class Circle:
    def __init__(self, r): self.r = r
    def area(self): return 3.14 * self.r ** 2

class Square:
    def __init__(self, side): self.side = side
    def area(self): return self.side ** 2
```

Same behavior. The first edits its own dispatching switch every time a shape is added; the second satisfies §Open/Closed and never touches existing code again. claudewright teaches the difference — and tells Claude *which principle* applies — in language the model actually internalizes.

Same shift happens in:

| Anti-pattern | claudewright pushes toward |
|---|---|
| `OrderService` calling `PostgresClient(host=...)` directly | A `Protocol` for the store, concrete wired in a composition root |
| `_gst_audio.py`, `_pil_color.py`, `_image_ops.py` piled in `pipeline/` | Domain-grouped packages: `gst/`, `image/`, `video/` |
| `account.balance = -50_000` mutable from outside | Encapsulated `withdraw()` that enforces the invariant |
| `if order is None or not hasattr(order, "items") or ...` | Validate once at the boundary, then trust the type inside |
| Five commits referencing PR #123, "per review feedback", "addressed comments" | `fix(user): reject empty email at registration boundary` |

## What's inside

Two skills, both auto-loaded by the plugin:

### 1. The discipline skill (`skills/claudewright/SKILL.md`)

~800 lines of opinionated principles. Auto-loads on every coding task. Each principle gets a definition, a *why*, concrete heuristics, a tiny anti-example, a corrected example, and cross-links to related principles.

**Part I — 16 system design principles:**

| | Principle |
|---|---|
| §SRP | Single Responsibility |
| §OCP | Open/Closed |
| §LSP | Liskov Substitution |
| §ISP | Interface Segregation |
| §DIP | Dependency Inversion |
| §DRY | Don't Repeat Yourself (knowledge, not text) |
| §SoC | Separation of Concerns |
| §CoI | Composition over Inheritance |
| §HCLC | High Cohesion, Low Coupling |
| §Enc | Encapsulation / Information Hiding |
| §TDA | Tell, Don't Ask / Law of Demeter |
| §CR | Composition Root pattern |
| §DDO | Domain-Driven Module Organization |
| §MISU | Make Illegal States Unrepresentable |
| §VAB | Validate at boundaries, trust inside |
| §SDP | Stable Dependencies Principle |

**Part II — code-discipline practices:**

- **Commits** — one concern per commit, `type(scope): subject`, no AI-attribution footers, no PR-number references
- **Comments and docstrings** — default to none; only the *why* gets a comment, never the history
- **Naming as documentation** — full words, booleans read as questions, verbs for actions
- **Verify external-tool config from source** — no knobs from memory; check the pinned version
- **Research prior art before designing** — search the engineering community first; don't reinvent named patterns
- **Stay within scope** — refactors require explicit user buy-in
- **Read before writing** — read the file, run the test, check the version
- **Risky actions require confirmation** — force-push, hard reset, dropping tables, sending external messages

### 2. The senior-review skill (`skills/review/SKILL.md`)

Model-invoked when you ask for a code review, PR review, or "what would a senior engineer say about this." Channels a specific reviewer profile — strict, abstraction-loving, terse, allergic to reinvention.

**What it does:**

- Reads the full diff before commenting. Identifies the 1–3 *architectural* issues. Leads with those.
- Writes the rewrite inline as a code block when a 100-line function should be 10 lines.
- Names the stdlib helper or package the code is reinventing — `functools.partialmethod`, `anyio.create_memory_object_stream`, `pydantic_settings.BaseSettings`, `enum.StrEnum`, `__init_subclass__` registries, `pytest-freezegun`, `uvloop`.
- Flags missing jitter/backoff anywhere there's a retry loop — *thundering herd*.
- Calls out concrete dependencies in abstract classes, Protocols with private methods, ABCs that don't inherit `abc.ABC`.
- Distinguishes throttle vs debounce vs rate-limit precisely. Names them correctly.
- Delegates trivial nits to coderabbit and tests. Approves with caveats: `lgtm, fix coderabbit and tests`. Doesn't waste round trips.

**Sample interaction:**

> **You:** Review this PR for me — branch `feat/systemd-watcher`, 600 lines added.
>
> **claudewright:review:**
>
> Substantive issues:
>
> 1. `SystemdWatcher` is managing N units. Should manage one. Instantiate many at the call site.
> 2. Health check pulls state from `SystemdWatcher` — invert it. The check should source its own state. Watcher stays generic.
> 3. `_health_check_dispatcher` defined as a private method on `HealthCheckProtocol` — protocols define public contracts only.
>
> Inline:
>
> - `service.py:117` — `is_active()` + `is_running()` are 2 dbus round-trips per call. Short-lived cache.
> - `service.py:165` — three methods (`start`, `stop`, `reload`) collapse to `functools.partialmethod` over one parameterized `transition_unit(action, name)`.
> - `service.py:79` — strict on `*.service`. Not all units are. State this is intentional or accept the suffix.
> - `bus.py:23` — shadowing builtin `id`.
> - `checks/systemd.py:97` — multiple check instances, separate inflight events that don't cross. Failures not handled.
>
> CHANGES_REQUESTED. Address watcher single-responsibility first, then the dbus caching, then coderabbit.

The skill includes a cross-reference table — when the review surfaces a violation, it names the principle from the discipline skill so the author can study it. `Concrete in field declaration → §DIP`. `Class doing four things → §SRP`. `Switch on type → §OCP`.

**Invoke explicitly** when you want it without the model having to infer:

```
/claudewright:review
```

## Bonus: `Co-Authored-By: Claude` is not a thing

You wrote the prompt. You reviewed the diff. You're the one who'll be on call when it breaks at 2am. Claude isn't your co-author and your `git log` doesn't need a sponsor.

Quietly bundled with the plugin: a `PreToolUse` hook on `Bash` that denies any `git commit` whose message contains `Co-Authored-By: Claude`, `Generated with Claude Code`, or `🤖 Generated with`. Caught before the commit runs, including inside compound commands like `git add . && git commit -m "..."`. Claude gets the rejection reason back and retries with a clean message. You never see the footer.

For belt-and-suspenders prevention, drop these into `~/.claude/settings.json` so Claude Code's built-in commit/PR flow stops adding the footer in the first place:

```json
{
  "attribution": { "commit": "", "pr": "" },
  "includeCoAuthoredBy": false
}
```

Settings stop it at the source. The hook is the fallback if any future feature tries to add it back.

## Why this and not one of the 425 other Claude plugins

claudewright is **a stance, not a library**.

The trending Claude Code repos in 2026 are curated collections — 1000+ skills, 425 plugins, 135 agents bundled into "ultimate toolkits". They're encyclopedias. You install them to *have options*.

claudewright is the opposite: two skills with a single editorial point of view about what good code looks like. If you disagree with the take — composition over inheritance, Protocol-first DI, async-context-managers over `set_x()` + `set_y()`, no defensive null-checks inside the system — you won't enjoy it. If you agree, installing it is faster than convincing Claude of any one of these principles from scratch in every new session.

## Manual install (no plugin system)

```bash
git clone https://github.com/aashish-thapa/claudewright.git
mkdir -p ~/.claude/skills ~/.claude/hooks

cp -r claudewright/plugins/claudewright/skills/claudewright ~/.claude/skills/
cp -r claudewright/plugins/claudewright/skills/review ~/.claude/skills/
cp claudewright/plugins/claudewright/hooks/block-ai-attribution-commits.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/block-ai-attribution-commits.sh
```

Then add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME/.claude/hooks/block-ai-attribution-commits.sh"
          }
        ]
      }
    ]
  }
}
```

## Contributing

PRs and issues welcome. The skill stays **tight and scannable** — additions should:

- Be language-agnostic (Python or pseudo-code that reads to TS, Go, Rust readers).
- Include a concrete anti-example AND a corrected version (5–15 lines each).
- Cross-link related principles inline (`see also: §...`).
- Avoid project-specific references, framework lock-in, and meta-skill content.

If proposing a new principle, check whether it's already covered under a different name — there's real overlap between Single Responsibility, Separation of Concerns, and Cohesion/Coupling, and the skill resolves the overlap through cross-links rather than restating the same idea three times.

## License

MIT. See [LICENSE](LICENSE).
