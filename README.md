# Agent Design Patterns Apps

This repository packages the full [`huangjia2019/agent-design-patterns`](https://github.com/huangjia2019/agent-design-patterns) repository for three AI coding surfaces:

- Codex App / Codex CLI plugin
- Claude Code CLI plugin
- Kiro skill

The package keeps one full upstream copy in `shared/agent-design-patterns/` and adds thin adapter layers for each host app.

## One-command install

```bash
curl -fsSL https://raw.githubusercontent.com/daydreampp/agent-design-patterns-apps/main/install.sh | bash
```

After publishing, replace `YOUR_GITHUB_USERNAME` with the GitHub owner.

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

## Usage

Ask your assistant to use ADPS before doing work, for example:

- `Use Agent Design Patterns to calibrate this task first.`
- `先用 ADPS 选择模式，然后完成这个任务。`
- `Explain which agent design pattern applies here.`

## Source

The bundled upstream repository is copied from `huangjia2019/agent-design-patterns` and is available under `shared/agent-design-patterns/`.
