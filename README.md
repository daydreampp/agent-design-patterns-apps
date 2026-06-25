# Agent Design Patterns Apps

This repository packages the full [`huangjia2019/agent-design-patterns`](https://github.com/huangjia2019/agent-design-patterns) repository for three AI coding surfaces:

- Codex App / Codex CLI plugin
- Claude Code CLI plugin
- Kiro skill

The package keeps one full upstream copy in `shared/agent-design-patterns/` and adds thin adapter layers for each host app.

<!-- upstream-status -->

Upstream `huangjia2019/agent-design-patterns` commit: `a53f3983effbc059a48577ee0da0fb7aa811190d`.

## One-command install

```bash
curl -fsSL https://raw.githubusercontent.com/daydreampp/agent-design-patterns-apps/main/install.sh | bash
```

## Local install from a clone

```bash
git clone https://github.com/daydreampp/agent-design-patterns-apps.git
cd agent-design-patterns-apps
./install.sh
```

## What gets installed

- Codex: registers this repo as a plugin marketplace and installs `agent-design-patterns`.
- Claude Code: registers this repo as a plugin marketplace and installs `agent-design-patterns`.
- Kiro: copies `apps/kiro/skills/agent-design-patterns` into `~/.kiro/skills/agent-design-patterns`.


## Updating bundled upstream

The original `huangjia2019/agent-design-patterns` repository can change over time. This package includes an update mechanism:

```bash
python3 scripts/sync_upstream.py
```

What it does:

- Clones the latest upstream `main` branch.
- Refreshes all bundled copies used by Codex, Claude Code, and Kiro.
- Rebuilds each `repository-map.md` navigation file.
- Writes the exact upstream commit to `upstream-lock.json`.

GitHub Actions also runs `.github/workflows/sync-upstream.yml` daily and opens a pull request when upstream changes are detected.

## Usage

Ask your assistant to use ADPS before doing work, for example:

- `Use Agent Design Patterns to calibrate this task first.`
- `先用 ADPS 选择模式，然后完成这个任务。`
- `Explain which agent design pattern applies here.`

## Source

The bundled upstream repository is copied from `huangjia2019/agent-design-patterns` and is available under `shared/agent-design-patterns/`.
