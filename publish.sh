#!/usr/bin/env bash
set -euo pipefail

OWNER="${1:-}"
REPO="${2:-agent-design-patterns-apps}"
VISIBILITY="${3:-public}"

if [ -z "$OWNER" ]; then
  printf 'Usage: ./publish.sh <github-owner> [repo-name] [public|private]\n' >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  printf 'GitHub CLI (gh) is required. Install it, then run: gh auth login\n' >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  printf 'Please run: gh auth login\n' >&2
  exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  gh repo create "$OWNER/$REPO" --"$VISIBILITY" --source . --remote origin --push
else
  git push -u origin main
fi

RAW="https://raw.githubusercontent.com/$OWNER/$REPO/main/install.sh"
GIT="https://github.com/$OWNER/$REPO.git"
python3 - <<PY
from pathlib import Path
p=Path('README.md')
s=p.read_text()
s=s.replace('https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/agent-design-patterns-apps/main/install.sh', '$RAW')
s=s.replace('https://github.com/YOUR_GITHUB_USERNAME/agent-design-patterns-apps.git', '$GIT')
s=s.replace('YOUR_GITHUB_USERNAME/agent-design-patterns-apps', '$OWNER/$REPO')
p.write_text(s)
PY
if ! git diff --quiet -- README.md; then
  git add README.md
  git commit -m "Update install URLs"
  git push
fi
printf '\nPublished. Install with:\n'
printf 'curl -fsSL %s | bash\n' "$RAW"
