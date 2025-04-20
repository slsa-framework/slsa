#!/bin/bash

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

# --- Look up current ref and extract the version from it ---
# If on a release branch, use the version from the branch name.
# If on main, use "draft" as the version.
# Otherwise, exit with an error.
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH_NAME" =~ ^releases/([^/]+)$ ]]; then
  VERSION="${BASH_REMATCH[1]}"
elif [[ "$BRANCH_NAME" == "main" ]]; then
  VERSION="draft"
else
  echo "Error: This script must be run from a 'releases/*' or 'main' branch. Current branch: $BRANCH_NAME"
  exit 1
fi

# --- Create a zip file of the spec directory ---
zip -r spec.zip spec
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to create spec.zip."
  exit 1
fi
echo "Created spec.zip successfully."

# --- Delete existing release with this version, if it exists ---
if gh release view "$VERSION" > /dev/null 2>&1; then
  gh release delete "$VERSION" --yes
fi

# --- Optionally generate an attestation if running in GitHub Actions ---
if [[ -n "$GITHUB_ACTIONS" ]]; then
  gh attestation generate build-provenance \
    --repo "$GITHUB_REPOSITORY" \
    --subject-path spec.zip \
    --output spec.attestation.json
fi

# --- Create a new release and upload the spec artifact and attestation ---
gh release create "$VERSION" spec.zip \
  --title "Release $VERSION" \
  --notes "This is the release of the spec. The source artifact and attestation are attached."