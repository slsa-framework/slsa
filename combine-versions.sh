#
# This script is used to combine the different versions of the spec into a single directory
# for easier access. 
# It will create spec folder in the www directory and deploy the spec from the current and other branches
# Please run the script from the root of the repository.

# Ensure the script is run from root
if [ ! -d .git ]; then
    echo "Error: This script must be run from the root of a git repository."
    exit 1
fi

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
CURRENT_DIR=$(pwd)

# clean spec dir
if [ -d www/spec ]; then
    rm -rf www/spec
fi
mkdir www/spec

# deploy draft from main
mkdir www/spec/draft
cp -r docs/spec/* www/spec/draft/

# deploy older versions
VERSIONS=("v1.0" "v1.0-rc1" "v1.0-rc2" "v1.1-rc1" "v1.1-rc2" )
for version in "${VERSIONS[@]}"; do
    RELEASE_BRANCH=releases/$version
    git reset --hard
    git fetch origin $RELEASE_BRANCH:refs/remotes/origin/$RELEASE_BRANCH # not sure if we need this -- depends on the CI setup
    git checkout $RELEASE_BRANCH
    mkdir www/spec/$version
    cp -r docs/spec/* www/spec/$version/
done

# back to the original branch
git reset --hard
git checkout $CURRENT_BRANCH
cd $CURRENT_DIR
