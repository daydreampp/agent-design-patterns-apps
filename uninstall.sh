#!/usr/bin/env bash
set -euo pipefail
log() { printf '[agent-design-patterns] %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

if have codex; then
  codex plugin remove agent-design-patterns >/dev/null 2>&1 || true
  codex plugin marketplace remove agent-design-patterns >/dev/null 2>&1 || true
  log "Removed Codex plugin/marketplace if present."
fi

if have claude; then
  claude plugin uninstall agent-design-patterns >/dev/null 2>&1 || true
  claude plugin marketplace remove agent-design-patterns >/dev/null 2>&1 || true
  log "Removed Claude plugin/marketplace if present."
fi

rm -rf "$HOME/.kiro/skills/agent-design-patterns"
log "Removed Kiro skill if present."
