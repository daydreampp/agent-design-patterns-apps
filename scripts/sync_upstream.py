#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import tempfile
from datetime import datetime, timezone
from pathlib import Path

UPSTREAM_URL = "https://github.com/huangjia2019/agent-design-patterns.git"
DEFAULT_REF = "main"
REPO_COPIES = [
    Path("shared/agent-design-patterns"),
    Path("apps/codex/plugins/agent-design-patterns/repository"),
    Path("apps/claude/plugins/agent-design-patterns/repository"),
    Path("apps/kiro/skills/agent-design-patterns/repository"),
]
MAP_TARGETS = [
    Path("apps/codex/plugins/agent-design-patterns/skills/adps-task-calibration/references/repository-map.md"),
    Path("apps/claude/plugins/agent-design-patterns/skills/adps-task-calibration/references/repository-map.md"),
    Path("apps/kiro/skills/agent-design-patterns/references/repository-map.md"),
]
SECTIONS = [
    "perception",
    "memory",
    "reasoning",
    "action",
    "reflection",
    "collaboration",
    "governance",
    "composition",
]
MARKERS = [
    "README.zh-CN.md",
    "README.md",
    "pattern.py",
    "example.py",
    "test_pattern.py",
    "hooks.py",
    "checklist_benchmark.ipynb",
]


def run(cmd: list[str], cwd: Path | None = None) -> str:
    return subprocess.check_output(cmd, cwd=cwd, text=True).strip()


def copy_repo(src: Path, dst: Path) -> None:
    if dst.exists():
        shutil.rmtree(dst)
    ignore = shutil.ignore_patterns(".git", "__pycache__", ".pytest_cache", ".venv", "*.pyc", ".DS_Store")
    shutil.copytree(src, dst, ignore=ignore)


def build_repository_map(repo: Path, upstream_commit: str) -> str:
    lines = [
        "# Packaged Repository Map",
        "",
        "Source: https://github.com/huangjia2019/agent-design-patterns",
        f"Upstream commit: `{upstream_commit}`",
        "",
        "## Root Files",
        "",
    ]
    for name in ["README.md", "README.zh-CN.md", "REFERENCE_IMPL.md", "pyproject.toml", "model_config.py", "LICENSE"]:
        if (repo / name).exists():
            lines.append(f"- `{name}`")
    lines.extend(["", "## Pattern Categories", ""])
    for section in SECTIONS:
        path = repo / section
        if not path.exists():
            continue
        lines.append(f"### `{section}/`")
        for child in sorted([p for p in path.iterdir() if p.is_dir()]):
            files = {p.name for p in child.iterdir() if p.is_file()}
            markers = [marker for marker in MARKERS if marker in files]
            lines.append(f"- `{section}/{child.name}/` — {', '.join(markers) if markers else 'README files'}")
        root_readmes = sorted(p.name for p in path.iterdir() if p.is_file() and p.name.startswith("README"))
        if root_readmes:
            lines.append(f"- `{section}/` root docs — {', '.join(root_readmes)}")
        lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def write_metadata(root: Path, upstream_ref: str, upstream_commit: str) -> bool:
    lock_path = root / "upstream-lock.json"
    previous = {}
    if lock_path.exists():
        try:
            previous = json.loads(lock_path.read_text())
        except json.JSONDecodeError:
            previous = {}
    previous_upstream = previous.get("upstream", {})
    upstream_changed = previous_upstream.get("commit") != upstream_commit or previous_upstream.get("ref") != upstream_ref
    if upstream_changed:
        synced_at = datetime.now(timezone.utc).isoformat(timespec="seconds").replace("+00:00", "Z")
    else:
        synced_at = previous_upstream.get("synced_at")
    metadata = {
        "upstream": {
            "url": UPSTREAM_URL,
            "ref": upstream_ref,
            "commit": upstream_commit,
            "synced_at": synced_at,
        },
        "copies": [str(path) for path in REPO_COPIES],
    }
    lock_path.write_text(json.dumps(metadata, indent=2, ensure_ascii=False) + "\n")
    return upstream_changed


def bump_patch_version(version: str) -> str:
    parts = version.split(".")
    if len(parts) != 3 or not all(part.isdigit() for part in parts):
        raise ValueError(f"Unsupported plugin version: {version}")
    major, minor, patch = map(int, parts)
    return f"{major}.{minor}.{patch + 1}"


def update_plugin_versions(root: Path, upstream_changed: bool) -> None:
    if not upstream_changed:
        return
    manifest_paths = [
        root / "apps/codex/plugins/agent-design-patterns/.codex-plugin/plugin.json",
        root / "apps/claude/plugins/agent-design-patterns/.claude-plugin/plugin.json",
    ]
    versions = []
    for path in manifest_paths:
        data = json.loads(path.read_text())
        versions.append(data["version"])
    next_version = bump_patch_version(max(versions, key=lambda item: tuple(map(int, item.split(".")))))
    for path in manifest_paths:
        data = json.loads(path.read_text())
        data["version"] = next_version
        path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n")


def update_readme_badge(root: Path, upstream_commit: str) -> None:
    readme = root / "README.md"
    text = readme.read_text()
    marker = "<!-- upstream-status -->"
    line = f"{marker}\n\nUpstream `huangjia2019/agent-design-patterns` commit: `{upstream_commit}`.\n"
    if marker in text:
        before = text.split(marker, 1)[0].rstrip()
        after_part = text.split(marker, 1)[1]
        if "\n## " in after_part:
            after = "\n## " + after_part.split("\n## ", 1)[1]
        else:
            after = ""
        readme.write_text(before + "\n\n" + line + after)
    else:
        insert_after = "The package keeps one full upstream copy in `shared/agent-design-patterns/` and adds thin adapter layers for each host app.\n"
        readme.write_text(text.replace(insert_after, insert_after + "\n" + line))


def main() -> None:
    parser = argparse.ArgumentParser(description="Sync bundled Agent Design Patterns copies from upstream.")
    parser.add_argument("--ref", default=DEFAULT_REF, help="Upstream branch, tag, or commit to sync from.")
    parser.add_argument("--root", default=Path.cwd(), type=Path, help="Repository root to update.")
    args = parser.parse_args()

    root = args.root.resolve()
    with tempfile.TemporaryDirectory(prefix="adps-upstream-") as tmp:
        clone = Path(tmp) / "agent-design-patterns"
        run(["git", "clone", "--depth", "1", "--branch", args.ref, UPSTREAM_URL, str(clone)])
        upstream_commit = run(["git", "rev-parse", "HEAD"], cwd=clone)
        for rel in REPO_COPIES:
            copy_repo(clone, root / rel)
        repo_map = build_repository_map(clone, upstream_commit)
        for rel in MAP_TARGETS:
            target = root / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(repo_map)
        upstream_changed = write_metadata(root, args.ref, upstream_commit)
        update_plugin_versions(root, upstream_changed)
        update_readme_badge(root, upstream_commit)
        print(upstream_commit)


if __name__ == "__main__":
    main()
