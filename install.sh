#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${ADPS_APPS_REPO_URL:-https://github.com/daydreampp/agent-design-patterns-apps.git}"
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
CODEX_PLUGIN_SRC="$REPO_DIR/apps/codex/plugins/agent-design-patterns"
CLAUDE_MARKETPLACE="$REPO_DIR/apps/claude"
KIRO_SKILL_SRC="$REPO_DIR/apps/kiro/skills/agent-design-patterns"

install_codex_desktop_fallback() {
  local manifest="$CODEX_PLUGIN_SRC/.codex-plugin/plugin.json"
  if [ ! -f "$manifest" ]; then
    log "Codex plugin source not found; skipped Codex Desktop fallback."
    return 1
  fi

  local version
  version="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$manifest" | head -n 1)"
  if [ -z "$version" ]; then
    log "Could not read Codex plugin version; skipped Codex Desktop fallback."
    return 1
  fi

  local codex_home="${CODEX_HOME:-$HOME/.codex}"
  local package_root="$codex_home/plugins/cache/agent-design-patterns/agent-design-patterns"
  local target="$package_root/$version"

  rm -rf "$package_root"
  mkdir -p "$package_root"
  cp -R "$CODEX_PLUGIN_SRC" "$target"
  log "Installed Codex Desktop fallback plugin files at $target."
  log "Restart Codex App to load the plugin if it was already open."
}

if have codex; then
  codex_registered=false
  if codex plugin marketplace add "$CODEX_MARKETPLACE" >/dev/null 2>&1; then
    log "Registered Codex marketplace."
    codex_registered=true
  else
    log "Codex marketplace may already be registered; continuing."
  fi
  if codex plugin add agent-design-patterns@agent-design-patterns >/dev/null 2>&1; then
    log "Installed Codex plugin agent-design-patterns."
    codex_registered=true
  else
    log "Codex plugin install may already be present; continuing."
  fi
  if [ "$codex_registered" = false ]; then
    log "Codex CLI registration did not report success; trying Codex Desktop fallback."
    install_codex_desktop_fallback || true
  fi
else
  log "Codex CLI not found; using Codex Desktop fallback file install."
  install_codex_desktop_fallback || true
fi

if have claude; then
  if claude plugin marketplace add "$CLAUDE_MARKETPLACE" >/dev/null 2>&1; then
    log "Registered Claude Code marketplace."
  else
    log "Claude marketplace may already be registered; continuing."
  fi
  if claude plugin list 2>/dev/null | grep -q "agent-design-patterns@agent-design-patterns"; then
    claude plugin uninstall agent-design-patterns >/dev/null 2>&1 || true
  fi
  if claude plugin install agent-design-patterns@agent-design-patterns --scope user >/dev/null 2>&1; then
    log "Installed or updated Claude Code plugin agent-design-patterns."
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
