---
name: agent-design-patterns
description: Trigger whenever the user says ADPS, 使用ADPS, 用ADPS, ADPS校准, Agent Design Patterns, or asks for task preflight/pattern selection before Kiro work. Use the full local huangjia2019/agent-design-patterns repository, select the smallest useful pattern set, then execute the task.
---

# Agent Design Patterns for Kiro

Use this skill as a preflight and pattern lookup layer for Kiro. After installation, the full repository lives at `repository/` inside this skill folder.

## Required Preflight

Before acting on any non-trivial task:

1. Bound the task: success criteria, out-of-scope items, constraints, and risks.
2. Classify the task across the two ADPS axes:
   - Cognitive function: Perception, Memory, Reasoning, Action, Reflection, Collaboration, Governance.
   - Execution topology: Chain, Route, Parallel, Orchestrate, Loop, Hierarchy, or Choreography only when explicitly needed.
3. Select the smallest useful pattern set.
4. Load relevant ADPS repository files before using a pattern in detail.
5. Execute in small checkpoints and report progress, verification, failures, and uncertainty.

## Repository Navigation

Start with:

- `repository/README.zh-CN.md`
- `repository/README.md`
- `repository/REFERENCE_IMPL.md`
- `references/repository-map.md`

Then drill into `repository/perception/`, `repository/memory/`, `repository/reasoning/`, `repository/action/`, `repository/reflection/`, `repository/collaboration/`, `repository/governance/`, and `repository/composition/`.

## Default Pattern Choices

- Context Triage
- Progressive Discovery
- Plan-and-Execute
- Generator-Critic
- Observability Harness

Add specific patterns by situation: Semantic Compaction for long context, Iterative Hypothesis for debugging, Tool Dispatch for tool-heavy work, Approval Gate and Blast Radius for risky side effects, Fan-out/Gather for independent tracks, and Skill Package for reusable workflow creation.

## Output Contract

When this skill guides a task, include selected ADPS patterns, repository sections used, verification performed, and any skipped checks or uncertainty.
