#!Bash
# This script merges changes from the main branch to distributed branches and run the Makefile on those distributed branches.
# This script should be put in the main branch folder with the main branch checked out, and all distributed branches should be put in the subfolders named after the branch names.
# Define configuration variables. This should be the only part to adapt to particular cases.
# The name of the remote is called origin by default. If not, you need to modify the code.
mainBranch="master" # The branch to merge changes from.
distributedBranch="Ivan Ezad twocolumn" # The target branches to be merged into. The source should be put in the folders named after the distributed branch's names.

# Synchronize the main branch from remote. It is recommmended to set remote with username or using ssh without typing in password every time git pushes.
echo "Synchronizing $mainBranch branch from origin. It will stop if the $mainBranch branch has uncommitted changes locally."
if ! git diff-index --quiet HEAD --; then
    echo "The local $mainBranch branch has uncommitted changes. Check it out manually."
    git status
    exit 0
fi

git fetch origin
git checkout $mainBranch
git merge origin/$mainBranch
git push origin $mainBranch

# Merge main branch to distributed branches.
for distrb in $distributedBranch
do
  echo "Synchronizing $distrb branch from $mainBranch."
  cd $distrb
  git fetch origin
  if ! git diff-index --quiet HEAD --; then
      echo "$distrb branch has been changed locally. Check it out."
      git status
      exit 0
  else
      git checkout $distrb
      git merge origin/$mainBranch
      git push origin $distrb
      make && make clean
      echo " Finished compiling pdf in folder $distrb."
      cd ..
  fi
done

echo " "
echo "Done."
