# Codex Marketplace

This directory is a Codex plugin marketplace root. Its manifest lives at:

```text
.agents/plugins/marketplace.json
```

Install with:

```bash
codex plugin marketplace add ./apps/codex
codex plugin add agent-design-patterns@agent-design-patterns
```

If you use Codex Desktop without a `codex` CLI in `PATH`, run the repository root `install.sh`. It copies the plugin into the Codex Desktop cache as a fallback and prints the installed path. Restart Codex App afterwards.
