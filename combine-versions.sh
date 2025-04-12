#
# This script is used to combine the different versions of the spec into a single directory
# for easier access. It creates a new directory called _build and copies the
# contents of the different versions into it.
# Please run the script from the root of the repository.

# Ensure the script is run from root
if [ ! -d .git ]; then
    echo "Error: This script must be run from the root of a git repository."
    exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BUILD_DIR=_build # ignored by git

# Remove the build directory if it exists
if [ -d $BUILD_DIR ]; then
    rm -rf $BUILD_DIR
fi
mkdir $BUILD_DIR
cd $BUILD_DIR

# TODO: update eventually -- this should just be the main branch representing the draft spec.
git reset --hard
git checkout users/zc/refactor-main
mkdir draft
cp -r ../docs/spec/* draft/

# build versioned folders
VERSIONS=("v1.0" "v1.0-rc1" "v1.0-rc2" "v1.1-rc1" "v1.1-rc2" )
for version in "${VERSIONS[@]}"; do
    RELEASE_BRANCH=releases/$version
    git reset --hard
    git fetch origin $RELEASE_BRANCH:refs/remotes/origin/$RELEASE_BRANCH # not sure if we need this -- depends on the CI setup
    git checkout $RELEASE_BRANCH
    mkdir $version
    cp -r ../docs/spec/* $version/
done

# back to the original branch
git reset --hard
git checkout $CURRENT_BRANCH
