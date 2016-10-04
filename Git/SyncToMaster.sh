#!Bash
echo "Synchronizing master from origin. It will stop if there is any uncommitted changes in the master branch locally."
if ! git diff-index --quiet HEAD --; then
    echo "Master has uncommitted changes. Check it out."
    git status
    exit 0
fi
git fetch origin
git merge origin/master
git push origin master

echo "Updating Ivan branch to master."
cd Ivan
git fetch origin
if ! git diff-index --quiet HEAD --; then
    echo "Update changes from Ivan branch."
    git add -u .
    git commit -m "Update from Ivan."
    git merge origin/Ivan
    git push origin Ivan
    cd ..
    echo "Merge changes from Ivan branch to master branch."
    git fetch origin
    git checkout master
    git merge origin/Ivan
    git push origin master
    cd Ivan
else
    git push origin Ivan
    cd ..
    git fetch origin
    git checkout master
    git merge origin/Ivan
    git push origin master
    cd Ivan
fi
cd ..

echo "Updating Ezad branch to master."
cd Ezad
git fetch origin
if ! git diff-index --quiet HEAD --; then
    echo "Update changes from Ezad branch."
    git add -u .
    git commit -m "Update from Ezad."
    git merge origin/Ezad
    git push origin Ezad
    cd ..
    echo "Merge changes from Ezad branch to master branch."
    git fetch origin
    git checkout master
    git merge origin/Ezad
    git push origin master
    cd Ezad
else
    git push origin Ezad
    cd ..
    git fetch origin
    git checkout master
    git merge origin/Ezad
    git push origin master
    cd Ezad
fi
cd ..
make && make clean
echo " Finished compiling pdf."
echo " "
echo "Done."
