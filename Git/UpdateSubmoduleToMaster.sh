#!Bash
# This script merges changes from the submodules of distributed branches to the remote and then fetch to the main branch for all changes in distributed branches.
# It will stop if any submodule has been changed local for manual reviews and fixes.
# After the manual fixes, this script can be ran iteratively to make sure the main branch has the most updated submodule hash merged.
# This script should be put in the main branch folder with the main branch checked out, and all distributed branches should be put in the subfolders named after the branch names.
# Define configuration variables. This should be the only part to adapt to particular cases.
# The name of the remote is called origin by default. If not, you need to modify the code.
mainBranch="master" # The branch to merge changes to.
distributedBranch="Ivan Ezad twocolumn" # The branches to be merged from. The source should be put in the folders named after the distributed branch's names.
submoduledir=( "refs" ) # The directories contain submodule sources. All submodules should be checked out to the correct branch recorded in the .gitsubmodule file. Notice I used brackets to make it an array.
submodulebranch=( "NanofiberPaper" )  # The tracking branch of submodule repos. It should be a one-to-one map to the submoduledir array.

# Updating submodules in the distributed branches to the remote.
echo "Checking submodules in distributed branches."
echo "The script will stop if there is any uncommitted changes in any submodule for manual fixes."
for distrb in $distributedBranch
do
  echo "Updating submodules in $distrb branch to remote."
  cd $distrb
  for ((i=0;i<${#submoduledir[@]};++i))
  do
    cd ${submoduledir[i]}
    git fetch origin
    if ! git diff-index --quiet HEAD --; then
      echo "The submodule in /${submoduledir[i]} of $distrb branch has been changed locally. Check it out."
      git status
      exit 0
      break;
    else
      echo " Commits in /${submoduledir[i]} is clean."
      cd ..
    fi
  done
  git push --recurse-submodules=on-demand origin $distrb
  cd ..
done

# Synchronize the main branch from remote. It is recommmended to set remote with username or using ssh without typing in password every time git pushes.
echo "Synchronizing submodules in $mainBranch from their remotes."
echo "It will stop if there is any uncommitted changes in the submodules of $mainBranch branch locally."
for ((i=0;i<${#submoduledir[@]};++i))
do
  cd ${submoduledir[i]}
  git fetch origin
  if ! git diff-index --quiet HEAD --; then
    echo "The submodule in /${submoduledir[i]} of local $mainBranch branch has uncommitted changes. Check it out."
    git status
    exit 0
    break;
  else
    echo " Submodule in /${submoduledir[i]} is clean in the $mainBranch branch."
    cd ..
  fi
done

git submodule update --recursive --remote --merge
# Determine if the merge is in-progress because of potential conflicts.
git merge HEAD &> /dev/null
result=$?
if [ $result -ne 0 ]
then
    git status
    echo "Merge in progress. There may be potential conflicts."
    echo " Please fix them in the target folder before further processing. Program aborted."
    exit 0
else
    echo "Merge was finished peacefully."
fi
git push --recurse-submodules=on-demand origin $mainBranch

echo " The $mainBranch now has the latest SHA recorded for all submodules."
echo " "
echo "Done."
