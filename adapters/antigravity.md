# Install craftwright for Google Antigravity

Antigravity reads workspace rules from `.agents/rules/*.md` and also supports the `AGENTS.md` standard at the project root.

## Option A (recommended) — Antigravity's workspace rules directory

```bash
mkdir -p .agents/rules
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > .agents/rules/craftwright.md
```

This is the Antigravity-native location. Rules in `.agents/rules/*.md` are persistent — read before every agent interaction in the workspace.

## Option B — root-level `AGENTS.md` (cross-tool standard)

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > AGENTS.md
```

## Verify

Open the workspace in Antigravity. Start a new agent task. Ask: "Describe the design principles you'll follow." Expected: SOLID, DRY, composition root, etc.

## What you get / don't get

Full discipline + review content. No commit-attribution hook (Antigravity manages git commits through its own UI; you can install a git `pre-commit` hook locally for the same effect).
