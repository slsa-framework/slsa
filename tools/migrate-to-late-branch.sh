#!/bin/bash

# This is a one-time script to migrate the slsa repo to a late-branch model.
# Currently, all versions are in subfolders in docs/spec/<version>
#
# For each subfolder of docs/spec on the main branch:
# 1. Checkout the main branch. Create a branch with the subfolder name and check it out.
# 2. On this branch, remove all other spec versions, the content for this release should exist directly under /spec/
# 3. Commit the result and publish the branch to the remote.

set -euo pipefail

# --- Ensure script is run from the repo root ---
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd $REPO_ROOT

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

# --- Start from the root of the repo ---
cd "$(git rev-parse --show-toplevel)"

# --- Collect all released version subfolders before starting the loop ---
VERSIONS=($(ls -1 "$SPECDIR" | grep -vE '^\.|^README|^draft$'))
REF_SPEC="releases"

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
