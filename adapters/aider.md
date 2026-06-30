# Install craftwright for Aider

Aider reads `CONVENTIONS.md` as project-level coding conventions, and also reads `AGENTS.md` in recent versions.

## Option A (recommended) — `CONVENTIONS.md`

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > CONVENTIONS.md
```

Then in your Aider session, load it explicitly:

```bash
aider --read CONVENTIONS.md
```

Or persist it via `.aider.conf.yml`:

```yaml
read:
  - CONVENTIONS.md
```

## Option B — `AGENTS.md` (if your Aider version supports it)

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > AGENTS.md
```

## Verify

Start an Aider session. Ask: "Tell me which design principles you'll apply when adding code to this project." Expected: SOLID, DRY, composition root, etc.

## What you get / don't get

Full discipline + review content. No commit-attribution hook (Aider runs git commits directly; you can install a git `pre-commit` hook locally for the same effect).
