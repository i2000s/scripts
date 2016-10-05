Scripts:
========

*SyncFromMaster.sh*: bash shell script for synchronizing changes from the master branch to distributed branches and then push changes to the remote for writing LaTeX files in parallel with multiple authors. Require the LaTeX makefile and associated tools. Usage example: [NanofiberPaper](https://github.com/CQuIC/FaradaySqueezingProtocol). Distributed branches are explicitly put in folders named after the branch names and got ignored in the master branch. Need to modify the distributed branch names in order to adapt to specific cases.

*SyncToMaster.sh*: similar to `SyncFromMaster.sh`, but to synchronize changes from distributed branches to the master branch as well as push changes to the remote.

*UpdateSubmoduleToMaster.sh*: similar to above, but to merge changes from submodules of distributed branches only to the submodules in the main branch. This can be run independent of the above two scripts, but it is recommended to run before the *SyncToMaster.sh* script in case the submodule merges to the main branch needs to be committed and push to the remote.

*UpdateSubmoduleFromRemote.sh*: similar to the script `UpdateSubmoduleToMaster.sh`, but it lets all branches clone files from remote for all of the given submodules. Although this script is independent from other scripts, but it is recommended to run after `UpdateSubmoduleToMaster.sh` and before `SyncFromMaster.sh`.
