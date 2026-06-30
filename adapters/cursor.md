# Install craftwright for Cursor

Cursor reads project rules from `.cursorrules` (legacy) or `.cursor/rules/*.md` (current). It also reads `AGENTS.md` in recent versions.

## Option A (recommended) — drop the AGENTS.md, Cursor reads it

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > AGENTS.md
```

Works in Cursor versions that support the AGENTS.md standard.

## Option B — write to `.cursor/rules/` (per-project rules directory)

```bash
mkdir -p .cursor/rules
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > .cursor/rules/craftwright.md
```

## Option C — legacy `.cursorrules` file

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > .cursorrules
```

## Verify

Open the project in Cursor. Start a new chat. Ask: "What design principles do you follow when writing new code?" Expected: SOLID, DRY, composition root, etc.

## What you get / don't get

Same as Codex — full skill content as rules. No commit-attribution hook (Cursor doesn't have an equivalent hook system, but you can install a git `pre-commit` hook locally).
