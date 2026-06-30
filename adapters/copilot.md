# Install craftwright for GitHub Copilot

GitHub Copilot reads custom instructions from `.github/copilot-instructions.md` (repo-level) and from `AGENTS.md` (since 2026).

## Option A — Copilot's native location

```bash
mkdir -p .github
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > .github/copilot-instructions.md
```

Commit this file. Copilot will read it for every suggestion in this repo.

## Option B — `AGENTS.md` (cross-tool standard, also read by Copilot)

```bash
curl -sL https://raw.githubusercontent.com/aashish-thapa/craftwright/main/AGENTS.md > AGENTS.md
```

If your repo already has an `AGENTS.md` for other tools (Codex, Cursor, Aider), Copilot will use the same file. One source of truth.

## Verify

Open a file in VS Code (or your Copilot IDE). Start typing a function. Copilot's suggestions should lean toward Protocol-first design, named helpers over reinvention, etc. — the patterns from the discipline skill.

## What you get / don't get

Full skill content. The commit-attribution hook isn't applicable — Copilot doesn't run git commits directly. If you commit through GitHub.com's Copilot Workspace or Copilot CLI, you can install a git `pre-commit` hook locally for the same effect.
