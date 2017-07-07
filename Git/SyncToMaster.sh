#!Bash
# This script merges changes from distributed branches to the main branch and run the Makefile on the main branch.
# This script should be put in the main branch folder with the main branch checked out, and all distributed branches should be put in the subfolders named after the branch names.
# Define configuration variables. This should be the only part to adapt to particular cases.
# The name of the remote is called origin by default. If not, you need to modify the code.
mainBranch="master" # The branch to merge changes to.
distributedBranch="Ivan Ezad" # The branches to be merged from. The source should be put in the folders named after the distributed branch's names.

# Synchronize the main branch from remote. It is recommmended to set remote with username or using ssh without typing in password every time git pushes.
echo "Synchronizing $mainBranch from origin. It will stop if there is any uncommitted changes in the $mainBranch branch locally."
if ! git diff-index --quiet HEAD --; then
    echo "The local $mainBranch branch has uncommitted changes. Check it out."
    git status
    exit 0
fi
git fetch origin
git merge origin/$mainBranch
git submodule update
git push origin $mainBranch

# Updating distributed branches to the main branch.
for distrb in $distributedBranch
do
  echo "Updating $distrb branch to $mainBranch."
  cd $distrb
  git fetch origin
  if ! git diff-index --quiet HEAD --; then
      echo "Update changes from $distrb branch."
      git add -u .
      git commit -m "Update from $distrb."
      git merge origin/$distrib
      git submodule update
      git push origin $distrb
      cd ..
      echo "Merge changes from $distrb branch to $mainBranch branch."
      git fetch origin
      git checkout $mainBranch
      git merge origin/$distrb
      git submodule update
      git push origin $mainbranch
      cd $distrb
  else
      git push origin $distrb
      cd ..
      git fetch origin
      git checkout $mainBranch
      git merge origin/$distrb
      git submodule update
      git push origin $mainBranch
      cd $distrb
  fi
  cd ..
done

make && make clean
echo " Finished compiling pdf."
echo " "
echo "Done."
