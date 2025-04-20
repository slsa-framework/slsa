# This script combines multiple versions of the SLSA spec into the ./spec directory for deployment.
#
# Target folder structure after running:
# ./spec/
#   draft/           # Latest draft version from docs/spec
#   v1.0/            # Spec files from releases/v1.0 branch
#   v1.0-rc1/        # Spec files from releases/v1.0-rc1 branch
#   v1.0-rc2/        # Spec files from releases/v1.0-rc2 branch
#   v1.1-rc1/        # Spec files from releases/v1.1-rc1 branch
#   v1.1-rc2/        # Spec files from releases/v1.1-rc2 branch
# Each subdirectory contains a full copy of the spec files for that version.
# Usage: ./combine-versions.sh

# Ensure the script is run from www/
if [ "$(basename $(pwd))" != "www" ]; then
    echo "Error: This script must be run from the www directory."
    exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO_ROOT=$(git rev-parse --show-toplevel)

# clean spec dir
if [ -d spec ]; then
    rm -rf spec
fi
mkdir spec

# deploy draft from main
mkdir spec/draft
cp -r "$REPO_ROOT/docs/spec"/* spec/draft/

# deploy older versions
VERSIONS=("v1.0" "v1.0-rc1" "v1.0-rc2" "v1.1-rc1" "v1.1-rc2" )
for version in "${VERSIONS[@]}"; do
    RELEASE_BRANCH=releases/$version
    git -C "$REPO_ROOT" reset --hard
    git -C "$REPO_ROOT" fetch origin $RELEASE_BRANCH:refs/remotes/origin/$RELEASE_BRANCH
    git -C "$REPO_ROOT" checkout $RELEASE_BRANCH
    mkdir spec/$version
    cp -r "$REPO_ROOT/docs/spec"/* spec/$version/
done

# back to the original branch
git reset --hard
git checkout $CURRENT_BRANCH
