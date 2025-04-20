#!/bin/bash

# This is a one-time script to migrate the slsa repo-to a late-branch model.
# Starting from the current tip of main:
# 1. For each subfolder the spec, create a branch with the name of the version.
# 2. Remove all other spec versions and docs content
# 3. Commit the result and publish the branch to the remote.

set -euo pipefail

# --- Ensure script is run from the repo root ---
REPO_ROOT="$(git rev-parse --show-toplevel)"
if [[ "$PWD" != "$REPO_ROOT" ]]; then
  echo "Error: Please run this script from the repository root: $REPO_ROOT"
  exit 1
fi

# --- Check for uncommitted changes ---
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: You have uncommitted changes. Please commit or stash them first."
  exit 1
fi

# --- Save the current branch to return to later ---
ORIG_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# --- Find all subfolders in docs/spec ---
SPECDIR="docs/spec"
if [[ ! -d "$SPECDIR" ]]; then
  echo "Error: $SPECDIR does not exist."
  exit 1
fi

cd "$(git rev-parse --show-toplevel)"

# --- Collect all released version subfolders before starting the loop ---
VERSIONS=($(ls -1 "$SPECDIR" | grep -vE '^\.|^README|^draft$'))
REF_SPEC="test/releases"
for version in "${VERSIONS[@]}"; do
  # --- Create a new branch for this version ---
  BRANCH="$REF_SPEC/$version"
  git checkout -b "$BRANCH"

  # --- move the version folder to the root of the spec directory ---
  mv "$SPECDIR/$version" "spec"

  # --- remove docs folder ---
  rm -rf docs

  # --- Commit the changes ---
  git add --all
  git commit -m "Migrate $version to its own branch ($BRANCH)."
  git push -u origin "$BRANCH"

  # --- Return to the original branch ---
  git checkout "$ORIG_BRANCH"
done

# Summary of updated branches
echo "Done. All branches created:"
for v in "${VERSIONS[@]}"; do
  echo "  - $REF_SPEC/$v"
done
