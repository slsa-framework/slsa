#!/bin/bash

# migrate-to-late-branch.sh
# For each subfolder in docs/spec, create a branch releases/<subfolder>,
# remove all other spec versions and docs content, and commit the result.
#
# Usage: Run from the repo root. Make sure you have no uncommitted changes.

set -euo pipefail

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

for version in $(ls -1 "$SPECDIR" | grep -vE '^\.|^README'); do
  # --- Create a new branch for this version ---
  BRANCH="releases/$version"
  git checkout -b "$BRANCH"

  # --- Remove all other subfolders in docs/spec except this one ---
  for other in "$SPECDIR"/*; do
    if [[ "$(basename "$other")" != "$version" ]]; then
      rm -rf "$other"
    fi
  done

  # --- Remove all other content in docs/ except spec ---
  for item in docs/*; do
    if [[ "$(basename "$item")" != "spec" ]]; then
      rm -rf "$item"
    fi
  done

  # --- Remove all content in docs/spec except the current version ---
  for item in "$SPECDIR"/*; do
    if [[ "$(basename "$item")" != "$version" ]]; then
      rm -rf "$item"
    fi
  done

  # --- Commit the changes ---
  git add docs/
  git commit -m "Migrate $version to its own branch ($BRANCH) with only its spec version."

done

# --- Return to the original branch ---
git checkout "$ORIG_BRANCH"
echo "Done. All branches created."
