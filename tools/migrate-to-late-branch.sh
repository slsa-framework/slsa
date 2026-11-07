#!/bin/bash

# migrate-to-late-branch.sh
# 
# Purpose: Migrate SLSA repository to a late-branch model.
# 
# Before: All versions are in subfolders in docs/spec/<version>
# After:  Each version lives in its own branch under releases/<version>
#         with content directly under /spec/
#
# For each subfolder of docs/spec on the main branch:
# 1. Checkout the main branch. Create a branch with the subfolder name and check it out.
# 2. On this branch, remove all other spec versions, the content for this release should exist directly under /spec/
# 3. Commit the result and publish the branch to the remote.
#
# Options:
#   --push    Push branches to the remote repository (default: off)

set -euo pipefail

# --- Parse command line arguments ---
PUSH_BRANCHES=false
SPEC_DIR=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --push)
      PUSH_BRANCHES=true
      shift
      ;;
    --spec-dir)
      SPEC_DIR="$2"
      shift 2
      ;;
    --spec-dir=*)
      SPEC_DIR="${1#*=}"
      shift
      ;;
    --help)
      echo "Usage: $0 [--push] [--spec-dir <dir>]"
      echo ""
      echo "Options:"
      echo "  --push          Push branches to the remote repository (default: off)"
      echo "  --spec-dir DIR  Directory containing version subfolders (default: auto-detect)"
      echo "  --help          Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information."
      exit 1
      ;;
  esac
done

# --- Check for uncommitted changes ---
if [[ -n $(git status --porcelain -uno) ]]; then
  echo "Error: You have uncommitted changes. Please commit or stash them first."
  exit 1
fi

# --- Ensure script is run from the repo root ---
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

# --- Save the current branch to return to later ---
ORIG_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# --- Locate the spec directory containing version subfolders ---
SPECDIR=""
if [[ -n "$SPEC_DIR" ]]; then
  if [[ -d "$SPEC_DIR" ]]; then
    SPECDIR="$SPEC_DIR"
  else
    echo "Error: Specified spec directory '$SPEC_DIR' does not exist."
    exit 1
  fi
else
  # Auto-detect directory with version subfolders (docs/spec, www/spec, or spec)
  for candidate in "docs/spec" "www/spec" "spec"; do
    if [[ -d "$candidate" ]]; then
      for item in $(ls -1 "$candidate" 2>/dev/null | grep -vE '^\.|^README|^draft$' || true); do
        if [[ -d "$candidate/$item" && "$item" =~ ^v[0-9] ]]; then
          SPECDIR="$candidate"
          break 2
        fi
      done
    fi
  done
fi

if [[ -z "$SPECDIR" ]]; then
  if [[ -d "spec" ]]; then
    echo "No version subdirectories (e.g. v1.0, v1.1) found in spec/."
    echo "The repository appears to already have been migrated to the late-branch model."
    exit 0
  else
    echo "Error: Could not find spec directory (checked docs/spec, www/spec, and spec)."
    exit 1
  fi
fi

# --- Collect all released version subfolders before starting the loop ---
VERSIONS=()
for item in $(ls -1 "$SPECDIR" | grep -vE '^\.|^README|^draft$'); do
  if [[ -d "$SPECDIR/$item" ]]; then
    VERSIONS+=("$item")
  fi
done

if [[ ${#VERSIONS[@]} -eq 0 ]]; then
  echo "No version subdirectories found in $SPECDIR. Migration may already be complete."
  exit 0
fi

REF_SPEC="releases"

# --- Check if any of the version refs already exist ---
echo "Checking for existing version refs..."
for version in "${VERSIONS[@]}"; do
  BRANCH="$REF_SPEC/$version"
  if git show-ref --verify --quiet "refs/heads/$BRANCH" || git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
    echo "Error: Branch $BRANCH already exists locally or remotely. Please delete it first."
    exit 1
  fi
done
echo "No existing version refs found. Proceeding with migration..."

for version in "${VERSIONS[@]}"; do
  # --- Create a new branch for this version ---
  BRANCH="$REF_SPEC/$version"
  git checkout -b "$BRANCH"

  # --- move the version folder to the root of the spec directory ---
  git mv "$SPECDIR/$version" "spec"

  # --- remove website folders ---
  if [[ -d docs ]]; then
    git rm -rf docs
  fi
  if [[ -d www ]]; then
    git rm -rf www
  fi

  # --- Commit the changes ---
  git add --all
  git commit -m "Migrate $version to its own branch ($BRANCH)."
  
  # --- Push the branch if the flag is enabled ---
  if [[ "$PUSH_BRANCHES" == true ]]; then
    git push -u origin "$BRANCH"
  else
    echo "Skipping push for branch $BRANCH (use --push to push branches)"
  fi

  # --- Return to the original branch ---
  git checkout "$ORIG_BRANCH"
done

# --- Summary of updated branches ---
echo "Done. All branches created:"
for v in "${VERSIONS[@]}"; do
  echo "  - $REF_SPEC/$v"
done

if [[ "$PUSH_BRANCHES" == true ]]; then
  echo "All branches have been pushed to origin."
else
  echo "Branches were created locally but not pushed. Use --push to push them to origin."
fi
