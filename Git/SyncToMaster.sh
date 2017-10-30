#!Bash
# Define configuration variables.
mainBranch="master"
distributedBranch="Ivan Ezad"

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
  echo "Updating $distrb branch to master."
  cd $distrb
  git fetch origin
  if ! git diff-index --quiet HEAD --; then
      echo "Update changes from $distrb branch."
      git add -u .
      git commit -m "Update from $distrb."
      git merge origin/$distrb
      git submodule update
      # Determine if the merge is in-progress because of potential conflicts.
      git merge HEAD &> /dev/null
      result=$?
      if [ $result -ne 0 ]
      then
          git status
          echo "Updating $distrb in progress. There may be potential conflicts."
          echo " Please fix them on subfolder $distrb before further processing. Program aborted."
          exit 0
      else
          echo "Update on branch $distrb was finished peacefully."
      fi
      git push origin $distrb
      cd ..
      echo "Merge changes from $distrb branch to the target branch."
      git fetch origin
      git checkout $mainBranch
      git merge origin/$distrb
      git submodule update
      # Determine if the merge is in-progress because of potential conflicts.
      git merge HEAD &> /dev/null
      result=$?
      if [ $result -ne 0 ]
      then
          git status
          echo "Merge from origin/$distrb in progress. There may be potential conflicts. "
          echo "Please fix them in the master folder before further processing. Program aborted."
          exit 0
      else
          echo "Merge was finished peacefully from branch $distrb."
      fi
      git push origin $mainbranch
      cd $distrb
  else
      git push origin $distrb
      cd ..
      git fetch origin
      git checkout $mainBranch
      git merge origin/$distrb
      git submodule update
      # Determine if the merge is in-progress because of potential conflicts.
      git merge HEAD &> /dev/null
      result=$?
      if [ $result -ne 0 ]
      then
          git status
          echo "Merge from origin/$distrb in progress. There may be potential conflicts."
          echo " Please fix them in the target folder before further processing. Program aborted."
          exit 0
      else
          echo "Merge was finished peacefully."
      fi
      git push origin $mainBranch
      cd $distrb
  fi
  cd ..
done

make && make clean
echo " Finished compiling pdf."
echo " "
echo "Done."
