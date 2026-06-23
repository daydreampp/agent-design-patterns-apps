#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${ADPS_APPS_REPO_URL:-https://github.com/YOUR_GITHUB_USERNAME/agent-design-patterns-apps.git}"
REF="${ADPS_APPS_REF:-main}"
INSTALL_ROOT="${ADPS_APPS_INSTALL_ROOT:-$HOME/.agent-design-patterns-apps}"
REPO_DIR="$INSTALL_ROOT/repo"

log() { printf '[agent-design-patterns] %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

if ! have git; then
  log "git is required for installation."
  exit 1
fi

mkdir -p "$INSTALL_ROOT"
if [ -d "$REPO_DIR/.git" ]; then
  log "Updating existing checkout at $REPO_DIR"
  git -C "$REPO_DIR" fetch --depth 1 origin "$REF"
  git -C "$REPO_DIR" checkout -q FETCH_HEAD
else
  rm -rf "$REPO_DIR"
  log "Cloning $REPO_URL#$REF into $REPO_DIR"
  git clone --depth 1 --branch "$REF" "$REPO_URL" "$REPO_DIR" 2>/dev/null || {
    log "Branch clone failed; trying default branch."
    git clone --depth 1 "$REPO_URL" "$REPO_DIR"
  }
fi

CODEX_MARKETPLACE="$REPO_DIR/apps/codex"
CLAUDE_MARKETPLACE="$REPO_DIR/apps/claude"
KIRO_SKILL_SRC="$REPO_DIR/apps/kiro/skills/agent-design-patterns"

if have codex; then
  if codex plugin marketplace add "$CODEX_MARKETPLACE" >/dev/null 2>&1; then
    log "Registered Codex marketplace."
  else
    log "Codex marketplace may already be registered; continuing."
  fi
  if codex plugin add agent-design-patterns@agent-design-patterns >/dev/null 2>&1; then
    log "Installed Codex plugin agent-design-patterns."
  else
    log "Codex plugin install may already be present; continuing."
  fi
else
  log "Codex CLI not found; skipped Codex App plugin registration."
fi

if have claude; then
  if claude plugin marketplace add "$CLAUDE_MARKETPLACE" >/dev/null 2>&1; then
    log "Registered Claude Code marketplace."
  else
    log "Claude marketplace may already be registered; continuing."
  fi
  if claude plugin install agent-design-patterns@agent-design-patterns --scope user >/dev/null 2>&1; then
    log "Installed Claude Code plugin agent-design-patterns."
  else
    log "Claude plugin install may already be present; continuing."
  fi
else
  log "Claude Code CLI not found; skipped Claude plugin registration."
fi

if [ -d "$KIRO_SKILL_SRC" ]; then
  mkdir -p "$HOME/.kiro/skills"
  rm -rf "$HOME/.kiro/skills/agent-design-patterns"
  cp -R "$KIRO_SKILL_SRC" "$HOME/.kiro/skills/agent-design-patterns"
  log "Installed Kiro skill at $HOME/.kiro/skills/agent-design-patterns."
else
  log "Kiro skill source not found; skipped Kiro."
fi

log "Done. Restart Codex App, Claude Code, or Kiro if they were already open."
log "Try: Use Agent Design Patterns to calibrate this task first."
