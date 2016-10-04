#!Bash
echo "Synchronizing master from origin. It will stop if master brach has uncommitted changes locally."
if ! git diff-index --quiet HEAD --; then
    echo "Master has uncommitted changes. Check it out manually."
    git status
    exit 0
fi
git fetch origin
git checkout master
git merge origin/master
git push origin master

echo "Synchronizing Ivan branch from master."
cd Ivan
git fetch origin
if ! git diff-index --quiet HEAD --; then
    echo "Ivan branch has been changed locally. Check it out."
    git status
    exit 0
else
    git checkout Ivan
    git merge origin/master
    git push origin Ivan
    make && make clean
    echo " Finished compiling pdf."
    cd ..
fi

echo "Synchronizing Ezad branch from master."
cd Ezad
git fetch origin
if ! git diff-index --quiet HEAD --; then
    echo "Ezad branch has been changed locally. Check it out."
    git status
    exit 0
else
    git checkout Ezad
    git merge origin/master
    git push origin Ezad
    make && make clean
    echo " Finished compiling pdf."
    cd ..
fi

echo "Synchronizing twocolumn branch from master."
cd twocolumn
git fetch origin
if ! git diff-index --quiet HEAD --; then
    echo "twocolumn branch has been changed locally. Check it out."
    git status
    exit 0
else
    git checkout twocolumn
    git merge origin/master
    git push origin twocolumn
    make && make clean
    echo " Finished compiling pdf."
    cd ..
fi
echo " "
echo "Done."
