---
name: adps-task-calibration
description: Use the full local huangjia2019/agent-design-patterns repository before starting non-trivial Claude Code work. Trigger when the user asks to use ADPS, Agent Design Patterns, agent-design-patterns, task preflight, pattern selection, workflow calibration, or when a task benefits from choosing agent patterns before execution. Reads the packaged repository and selects the smallest useful pattern set before acting.
---

# ADPS Task Calibration

Use this skill as a task preflight and pattern lookup layer for Claude Code work. The plugin includes a full local copy of `huangjia2019/agent-design-patterns` at `../../repository/` relative to this file.

## Required Preflight

Before acting on any non-trivial task:

1. Bound the task: success criteria, out-of-scope items, constraints, and risks.
2. Classify the task across the repository's two axes:
   - Cognitive function: Perception, Memory, Reasoning, Action, Reflection, Collaboration, Governance.
   - Execution topology: Chain, Route, Parallel, Orchestrate, Loop, Hierarchy, or Choreography only when explicitly needed.
3. Select the smallest useful pattern set. Prefer 2-5 patterns for normal tasks and more only when risk or scope demands it.
4. Load the relevant packaged repository files before using a pattern in detail.
5. Execute in small checkpoints and report what changed, what was verified, and what remains uncertain.

## Repository Navigation

Start with:

- `../../repository/README.zh-CN.md`
- `../../repository/README.md`
- `../../repository/REFERENCE_IMPL.md`
- `references/repository-map.md`

Then drill into `perception/`, `memory/`, `reasoning/`, `action/`, `reflection/`, `collaboration/`, `governance/`, and `composition/` under the shared repository.

## Default Pattern Choices

- Context Triage
- Progressive Discovery
- Plan-and-Execute
- Generator-Critic
- Observability Harness

Add more specific patterns only when they reduce concrete risk: Semantic Compaction for long context, Iterative Hypothesis for debugging, Tool Dispatch for tool-heavy work, Approval Gate and Blast Radius for risky side effects, Fan-out/Gather for independent tracks, and Skill Package for reusable workflow creation.

## Output Contract

When this skill guides a task, include selected ADPS pattern names, repository sections used, verification performed, and any skipped checks or unresolved uncertainty.
