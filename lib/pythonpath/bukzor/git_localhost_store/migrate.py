"""Migrate a legacy gitfile-style git-localhost-store repo to the symlink layout."""
from __future__ import annotations

import os
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

from bukzor.xtrace import query, run

REPOS_ROOT = Path(
    os.environ.get("XDG_STATE_HOME", str(Path.home() / ".local/state"))
) / "git-localhost-store/repos"

HOOKS_TEMPLATE_DIR = Path(
    os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))
) / "git-localhost-store/template-repo/hooks"

# Per-worktree files we promote up to the store's root. Order matters only for
# trace readability (HEAD and index first). For "logs", only logs/HEAD is
# per-worktree — the rest of <store>/logs/ is shared and untouched.
WORKTREE_PROMOTABLE = (
    "HEAD", "index", "COMMIT_EDITMSG",
    "ORIG_HEAD", "FETCH_HEAD", "REBASE_HEAD", "logs",
)
# These intentionally overwrite their store counterparts. The bare repo's HEAD
# is the default "ref: refs/heads/<default>"; the worktree's HEAD is the
# authoritative one. The bare repo has no index.
WORKTREE_OVERWRITES_STORE = frozenset({"HEAD", "index"})
# Per-worktree pointer files; meaningless in the symlink layout.
WORKTREE_DISCARDABLE = frozenset({"commondir", "gitdir"})
# Junk files left behind by the pre-commit hook's index swapping.
INDEX_COMMIT_STAGED_RE = re.compile(r"^index\.commit-staged\.\d+$")

# Active git operations whose state lives in the worktree dir. REBASE_HEAD is
# NOT here: it is left behind even after a successful rebase. The directory
# markers are the reliable signal of an in-progress rebase.
IN_PROGRESS_MARKERS = (
    "MERGE_HEAD", "MERGE_MSG", "CHERRY_PICK_HEAD", "REVERT_HEAD",
    "BISECT_LOG", "BISECT_START",
    "rebase-merge", "rebase-apply",
)


def is_index_commit_staged(name: str) -> bool:
    return bool(INDEX_COMMIT_STAGED_RE.match(name))


def classify_worktree_entry(name: str) -> str:
    if name in WORKTREE_PROMOTABLE:
        return "promote"
    if name in WORKTREE_DISCARDABLE:
        return "discard"
    if name == "refs":
        return "refs"  # emptiness checked separately
    if is_index_commit_staged(name):
        return "junk"
    return "unknown"


# --- Types ---------------------------------------------------------------

@dataclass(frozen=True)
class GitfileLayout:
    """A repo whose .git is a regular file with `gitdir: <store>/worktrees/<name>`."""
    workdir: Path
    store: Path
    worktree_dir: Path
    name: str


@dataclass(frozen=True)
class MigrationPlan:
    layout: GitfileLayout
    new_store: Path


@dataclass(frozen=True)
class PreconditionFailure:
    code: str
    detail: object


# --- Pure: discovery -----------------------------------------------------

def parse_gitfile(workdir: Path) -> Path:
    """Read <workdir>/.git, return the gitdir path it references."""
    text = (workdir / ".git").read_text()
    line = text.strip()
    prefix = "gitdir: "
    assert line.startswith(prefix), (workdir, line)
    return Path(line[len(prefix):])


def check_gitfile_shape(workdir: Path) -> PreconditionFailure | None:
    """Pre-check that <workdir>/.git is a regular file (a gitfile)."""
    git = workdir / ".git"
    if git.is_symlink():
        return PreconditionFailure("expected-gitfile-found-symlink", str(git))
    if git.is_dir():
        return PreconditionFailure("expected-gitfile-found-plain-gitdir", str(git))
    if not git.is_file():
        return PreconditionFailure("expected-gitfile-found-nothing", str(git))
    return None


def discover_gitfile_layout(workdir: Path) -> GitfileLayout:
    worktree_dir = parse_gitfile(workdir)
    store = worktree_dir.parent.parent
    return GitfileLayout(
        workdir=workdir.resolve(),
        store=store,
        worktree_dir=worktree_dir,
        name=worktree_dir.name,
    )


def encode_path(workdir: Path) -> str:
    return query("claude-path", str(workdir))


def plan_migration(layout: GitfileLayout, repos_root: Path) -> MigrationPlan:
    encoded = encode_path(layout.workdir)
    return MigrationPlan(layout=layout, new_store=repos_root / encoded)


# --- Pure: precondition checks -------------------------------------------

def check_layout_shape(layout: GitfileLayout) -> PreconditionFailure | None:
    """Layout-level shape checks (gitdir target points where we expect)."""
    if not str(layout.worktree_dir).rstrip("/").endswith("/worktrees/" + layout.name):
        return PreconditionFailure(
            "unexpected-gitdir-shape",
            str(layout.worktree_dir),
        )
    if not layout.store.is_dir() or not layout.worktree_dir.is_dir():
        return PreconditionFailure(
            "store-or-worktree-missing",
            {"store": str(layout.store), "wt": str(layout.worktree_dir)},
        )
    return None


def check_single_worktree(layout: GitfileLayout) -> PreconditionFailure | None:
    entries = sorted(p.name for p in (layout.store / "worktrees").iterdir())
    if entries != [layout.name]:
        return PreconditionFailure("multiple-worktrees", entries)
    return None


def check_no_in_progress_ops(layout: GitfileLayout) -> PreconditionFailure | None:
    found = [m for m in IN_PROGRESS_MARKERS if (layout.worktree_dir / m).exists()]
    if found:
        return PreconditionFailure("in-progress-op", found)
    return None


def check_empty_per_worktree_refs(layout: GitfileLayout) -> PreconditionFailure | None:
    refs = layout.worktree_dir / "refs"
    if not refs.is_dir():
        return None
    leftover = [str(p.relative_to(refs)) for p in refs.rglob("*") if p.is_file()]
    if leftover:
        return PreconditionFailure("nonempty-per-worktree-refs", leftover)
    return None


def check_no_unexpected_worktree_files(layout: GitfileLayout) -> PreconditionFailure | None:
    extras = sorted(
        p.name for p in layout.worktree_dir.iterdir()
        if classify_worktree_entry(p.name) == "unknown"
    )
    if extras:
        return PreconditionFailure("unexpected-worktree-files", extras)
    return None


def check_no_promote_collisions(layout: GitfileLayout) -> PreconditionFailure | None:
    """A promotable file the worktree wants to move up must not already exist in the store."""
    collisions = []
    for name in WORKTREE_PROMOTABLE:
        wt_path = layout.worktree_dir / name
        if not wt_path.exists():
            continue
        if name in WORKTREE_OVERWRITES_STORE:
            continue
        if name == "logs":
            # only logs/HEAD is per-worktree; logs/refs/heads/* is shared
            if (layout.store / "logs" / "HEAD").exists():
                collisions.append("logs/HEAD")
            continue
        if (layout.store / name).exists():
            collisions.append(name)
    if collisions:
        return PreconditionFailure("promote-collisions", collisions)
    return None


def check_target_store_does_not_exist(plan: MigrationPlan) -> PreconditionFailure | None:
    # In-place migration: source store is already at the encoded target path.
    # The relocate_store step is skipped in migrate(); collision is benign here.
    if plan.new_store == plan.layout.store:
        return None
    if plan.new_store.exists():
        return PreconditionFailure("target-store-already-exists", str(plan.new_store))
    return None


def all_layout_preconditions(layout: GitfileLayout) -> list[PreconditionFailure]:
    results = [
        check_layout_shape(layout),
        check_single_worktree(layout),
        check_no_in_progress_ops(layout),
        check_empty_per_worktree_refs(layout),
        check_no_unexpected_worktree_files(layout),
        check_no_promote_collisions(layout),
    ]
    return [r for r in results if r is not None]


# --- Impure: execution steps ---------------------------------------------

def install_hooks(store: Path, template_hooks: Path) -> None:
    for name in ("pre-commit", "post-index-change", "reference-transaction"):
        run("install", "-D", "-m", "0755",
            template_hooks / name, store / "hooks" / name)


def promote_worktree_state(layout: GitfileLayout) -> None:
    wt, store = layout.worktree_dir, layout.store
    for name in WORKTREE_PROMOTABLE:
        src = wt / name
        if not src.exists():
            continue
        if name == "logs":
            # only logs/HEAD is per-worktree; mkdir is idempotent (store/logs/refs/* already exists)
            run("mkdir", "-p", store / "logs")
            run("mv", "-f", src / "HEAD", store / "logs" / "HEAD")
            continue
        run("mv", "-f", src, store / name)
    # discard junk left behind by the pre-commit hook's index swapping
    for entry in wt.iterdir():
        if is_index_commit_staged(entry.name):
            run("rm", "-f", entry)
    # commondir, gitdir, empty refs/, empty logs/ remain — discarded by remove_worktree_subdir.


def remove_worktree_subdir(layout: GitfileLayout) -> None:
    run("rm", "-r", layout.worktree_dir)
    run("rmdir", layout.store / "worktrees")


def rewrite_config(store: Path) -> None:
    cfg = store / "config"
    run("git", "config", "-f", str(cfg), "core.bare", "false")
    # submodule.active=. is a leftover from the bare-repo era — drop if present.
    rc = subprocess.run(
        ["git", "config", "-f", str(cfg), "--unset", "submodule.active"],
    ).returncode
    if rc not in (0, 5):  # 5 = section/key not found
        raise SystemExit(f"git config --unset returned {rc}")


def relocate_store(plan: MigrationPlan) -> None:
    plan.new_store.parent.mkdir(parents=True, exist_ok=True)
    run("mv", "-T", plan.layout.store, plan.new_store)


def swap_gitlink_atomic(workdir: Path, new_store: Path) -> None:
    tmp = workdir / ".git.new"
    run("ln", "-s", str(new_store), str(tmp))
    run("mv", "-Tf", str(tmp), str(workdir / ".git"))


# --- Composition ---------------------------------------------------------

def migrate(plan: MigrationPlan, template_hooks: Path) -> None:
    install_hooks(plan.layout.store, template_hooks)
    promote_worktree_state(plan.layout)
    remove_worktree_subdir(plan.layout)
    rewrite_config(plan.layout.store)
    if plan.new_store != plan.layout.store:
        relocate_store(plan)
    swap_gitlink_atomic(plan.layout.workdir, plan.new_store)


# --- Entry point ---------------------------------------------------------

def usage() -> None:
    print("usage: python -m bukzor.git_localhost_store.migrate <workdir>", file=sys.stderr)


def report_failures(failures: list[PreconditionFailure]) -> None:
    print("Precondition failures:", file=sys.stderr)
    for f in failures:
        print(f"  - {f.code}: {f.detail}", file=sys.stderr)


def main() -> int:
    if len(sys.argv) != 2:
        usage()
        return 2
    workdir = Path(sys.argv[1])
    if not workdir.is_dir():
        print(f"not a directory: {workdir}", file=sys.stderr)
        return 2

    shape_failure = check_gitfile_shape(workdir)
    if shape_failure is not None:
        report_failures([shape_failure])
        return 1

    layout = discover_gitfile_layout(workdir)
    layout_failures = all_layout_preconditions(layout)
    if layout_failures:
        report_failures(layout_failures)
        return 1

    plan = plan_migration(layout, REPOS_ROOT)
    plan_failure = check_target_store_does_not_exist(plan)
    if plan_failure is not None:
        report_failures([plan_failure])
        return 1

    print(f"Migrating: {layout.workdir}", file=sys.stderr)
    print(f"  old store: {layout.store}", file=sys.stderr)
    print(f"  new store: {plan.new_store}", file=sys.stderr)
    migrate(plan, HOOKS_TEMPLATE_DIR)
    print("✓ migration complete", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
