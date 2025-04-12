CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
mkdir build
cd build

git reset --hard
git checkout users/zc/refactor-main
mkdir draft 
cp -r ../docs/spec/* draft/

version=v1.1-rc1
git reset --hard
git checkout releases/$version
mkdir $version
cp -r ../docs/spec/* $version/

version=v1.1-rc2
git reset --hard
git checkout releases/$version
mkdir $version
cp -r ../docs/spec/* $version/

version=v1.0
git reset --hard
git checkout releases/$version
mkdir $version
cp -r ../docs/spec/* $version/

# back to the original branch
git reset --hard
git checkout $CURRENT_BRANCH