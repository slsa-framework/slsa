# This script combines multiple versions of the SLSA spec into the ./spec directory for deployment.
#
# Target folder structure after running:
# ./spec/
#   draft/           # Latest draft version from /spec
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

# --- Parse command line arguments ---
FETCH_BRANCHES=true

for arg in "$@"; do
  case "$arg" in
    --nofetch)
      FETCH_BRANCHES=false
      ;;
    --help)
      echo "Usage: $0 [--fetch]"
      echo ""
      echo "Options:"
      echo "  --nofetch Do not fetch branches from the remote repository (default is to fetch)"
      echo "  --help    Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Use --help for usage information."
      exit 1
      ;;
  esac
done

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "HEAD" ]; then
    # If detached, store commit SHA
    CURRENT_BRANCH=$(git rev-parse HEAD)
fi

REPO_ROOT=$(git rev-parse --show-toplevel)

# clean spec dir
echo Cleaning spec folder
if [ -d spec ]; then
    rm -rf spec
fi
mkdir spec

# deploy draft from main
echo Populating spec/draft
mkdir spec/draft
cp -r "$REPO_ROOT/spec"/* spec/draft/

# deploy older versions
for RELEASE_BRANCH in $(git branch -r --list 'origin/releases/*'); do
    version="$(basename $RELEASE_BRANCH)"
    echo Populating spec/$version
    git -C "$REPO_ROOT" reset --hard
    if [[ "$FETCH_BRANCHES" == true ]]; then
	git -C "$REPO_ROOT" fetch origin $RELEASE_BRANCH:refs/remotes/origin/$RELEASE_BRANCH
    fi
    git -C "$REPO_ROOT" checkout $RELEASE_BRANCH
    mkdir spec/$version
    cp -r "$REPO_ROOT/spec"/* spec/$version/
done

# back to the original branch
git reset --hard
git checkout $CURRENT_BRANCH
echo '
The spec folder is now ready:'
ls -F spec
