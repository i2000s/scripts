Scripts:
========

*SyncFromMaster.sh*: bash shell script for synchronizing changes from the master branch to distributed branches and then push changes to the remote for writing LaTeX files in parallel with multiple authors. Require the LaTeX makefile and associated tools. Usage example: [NanofiberPaper](https://github.com/CQuIC/FaradaySqueezingProtocol). Distributed branches are explicitly put in folders named after the branch names and got ignored in the master branch. Need to modify the distributed branch names in order to adapt to specific cases.

*SyncToMaster.sh*: similar to `SyncFromMaster.sh`, but to synchronize changes from distributed branches to the master branch as well as push changes to the remote.
