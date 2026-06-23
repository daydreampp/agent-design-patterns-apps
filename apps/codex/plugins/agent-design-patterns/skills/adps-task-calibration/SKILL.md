---
name: adps-task-calibration
description: Use the full local huangjia2019/agent-design-patterns repository before starting non-trivial Codex work. Trigger when the user asks to use ADPS, Agent Design Patterns, agent-design-patterns, task preflight, pattern selection, workflow calibration, or when a task benefits from choosing agent patterns before execution. Reads the packaged repository and selects the smallest useful pattern set before acting.
---

# ADPS Task Calibration

Use this skill as a task preflight and pattern lookup layer for Codex work. The plugin includes a full local copy of `huangjia2019/agent-design-patterns` at `../../repository/` relative to this file.

## Required Preflight

Before acting on any non-trivial task:

1. **Bound** the task: success criteria, out-of-scope items, constraints, and risks.
2. **Classify** the task across the repository's two axes:
   - Cognitive function: Perception, Memory, Reasoning, Action, Reflection, Collaboration, Governance.
   - Execution topology: Chain, Route, Parallel, Orchestrate, Loop, Hierarchy, or Choreography only when explicitly needed.
3. **Select** the smallest useful pattern set. Prefer 2-5 patterns for normal tasks and more only when risk or scope demands it.
4. **Load** the relevant packaged repository files before using a pattern in detail.
5. **Execute** in small checkpoints and report what changed, what was verified, and what remains uncertain.

Do not expose a long methodology dump unless the user asks. Give a concise note such as: “我会先用 ADPS 做任务校准，然后执行。”

## Repository Navigation

Start with these files when broad orientation is needed:

- `../../repository/README.zh-CN.md` for the Chinese overview.
- `../../repository/README.md` for the English overview.
- `../../repository/REFERENCE_IMPL.md` for runnable implementation notes.
- `references/repository-map.md` for a compact local map generated for this plugin.

Then drill into one or more category folders under `../../repository/`: `perception/`, `memory/`, `reasoning/`, `action/`, `reflection/`, `collaboration/`, `governance/`, and `composition/`.

## Default Pattern Choices

Use this baseline for ordinary coding tasks unless the repository files indicate a better fit:

- **Perception / Context Triage**: decide what to read, defer, compress, or ignore.
- **Perception / Progressive Discovery**: inspect broadly, then drill into relevant files and evidence.
- **Action / Plan-and-Execute**: plan first for multi-step work, then execute in verified units.
- **Reflection / Generator-Critic**: review output before handing it off.
- **Governance / Observability Harness**: surface progress, verification, failures, and uncertainty.

## Routing Hints

- Large context or many files: add Semantic Compaction and Hierarchical Retention.
- Need current or external facts: add RAG and use primary sources.
- Debugging: add Iterative Hypothesis, Failure Journals, and Self-Heal Loop.
- Tool-heavy work: add Tool Dispatch and Guardrail Sandwich.
- Risky side effects: add Approval Gate, Blast Radius, and Progressive Commitment.
- Independent research tracks: add Parallel Exploration or Fan-out/Gather.
- Subagents: add Hierarchical Delegation, Fan-out/Gather, and Handoff Chain.
- Reusable workflow creation: add Skill Package.
- Benchmarking or checklists: use the composition examples.

## Output Contract

When this skill guides a task, include a concise handoff in the final answer: selected ADPS pattern names, files or repository sections used, verification performed, and any skipped checks or unresolved uncertainty.
