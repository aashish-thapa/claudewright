# claudewright

> Senior-engineer discipline for AI coding. SOLID, DRY, separation of concerns — and a hook that keeps `Co-Authored-By: Claude` out of your git history.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-8A2BE2)](https://code.claude.com/docs/en/plugins)
[![Skill + Hook](https://img.shields.io/badge/skill-+%20hook-2ea44f)](#whats-inside)

---

Modern AI coding agents produce code that compiles, passes tests, and ships. A senior engineer reading the diff sees five principles violated, a switch statement that should be polymorphism, and `Co-Authored-By: Claude <noreply@anthropic.com>` polluting `git log`.

**claudewright** is the opposite of "vibe coding." It's a single Claude Code plugin that teaches your agent 16 system design principles (SOLID, DRY, separation of concerns, composition root, illegal-states-unrepresentable, ...), a code-discipline rulebook for commits, comments, scope, and verification — and installs a hook that **denies any commit containing an AI-attribution footer before it touches your history**.

A "wright" is a craftsperson: millwright, playwright, shipwright. **claudewright** is what your Claude becomes when you install this.

## Install

Inside Claude Code:

```
/plugin marketplace add aashish-thapa/claudewright
/plugin install claudewright@claudewright
```

That's it. The skill auto-loads on every coding task. The hook wires itself. No `settings.json` surgery required.

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
| Five commits referencing PR #123, "per review feedback", `Co-Authored-By: Claude` | `fix(user): reject empty email at registration boundary` |

## What's inside

claudewright ships three layers — installed together, decoupled in spirit:

### 1. The skill (`skills/claudewright/SKILL.md`)

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

### 2. The hook (`hooks/block-ai-attribution-commits.sh`)

A `PreToolUse` hook on `Bash` that silently passes through everything *except* `git commit` commands whose message contains:

- `Co-Authored-By: Claude`
- `Generated with [...] Claude Code`
- `🤖 Generated with`

When matched, the Bash call is denied **before it runs** and Claude receives the rejection reason verbatim. It retries with a clean message on the next turn. Your `git log` stays clean — by your own rule, not Anthropic's default.

Test it standalone:

```bash
echo '{"tool_name":"Bash","tool_input":{"command":"git commit -m \"feat: x\\n\\nCo-Authored-By: Claude\""}}' \
  | hooks/block-ai-attribution-commits.sh
# → {"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny", ...}}
```

The hook catches `git commit` inside compound commands too — `git add . && git commit -m "..."` is matched, not let through.

### 3. Recommended companion settings

The hook is *enforcement*. For *prevention*, also add these to `~/.claude/settings.json` so Claude Code's built-in commit/PR flow stops appending attribution footers in the first place:

```json
{
  "attribution": {
    "commit": "",
    "pr": ""
  },
  "includeCoAuthoredBy": false
}
```

Belt and suspenders: the built-in flow won't add the footer, and the hook denies any manual attempt to add one.

## Why this and not one of the 425 other Claude plugins

claudewright is **a stance, not a library**.

The trending Claude Code repos in 2026 are curated collections — 1000+ skills, 425 plugins, 135 agents bundled into "ultimate toolkits". They're encyclopedias. You install them to *have options*.

claudewright is the opposite: one skill, one hook, and a single editorial point of view about what good code looks like. If you disagree with the take — composition over inheritance, Protocol-first DI, no AI-attribution footers, no defensive null-checks inside the system — you won't enjoy it. If you agree, installing it is faster than convincing Claude of any one of these principles from scratch in every new session.

## Manual install (no plugin system)

```bash
git clone https://github.com/aashish-thapa/claudewright.git
mkdir -p ~/.claude/skills ~/.claude/hooks

cp -r claudewright/plugins/claudewright/skills/claudewright ~/.claude/skills/
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
