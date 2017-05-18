#!Bash
# This script replaces some parameters to new ones from previous simulation codes, compile them and submit the generated binary scripts on a cluster as PBS jobs.
# Please run this script with "bash quickreplacesubmitjobs.sh".

# Below are the configuration parameters to change for the simulation case.
# The file to be updated and compiled. It should be in the same folder as this bash script.
codefiles="nanofiber_dipolex_E_new.cpp nanofiber_dipoley_E_new.cpp nanofiber_dipolez_E_new.cpp" 
# The parameter to look for in the code files. Make sure it can be uniquely found.
variabletochange="x=" 
# The initial value of the parameter being looking for before running this script.
parameterorigin="530" 
parameterlist="260 300 340 380 420 460 500 540 580" # Parameter values to be simulated.
# The file names to be compiled to as for each code file. The same size as codefiles.
compiledscripts="scripts_dipolex_E scripts_dipoley_E scripts_dipolez_E" 
# The directory where this script and the code files are located. This directory will be used after going into the target directory. Relative path to the target directory is recommended to use.
currentdirectory="../bem2D" 
# The directory where the code files are going to be compiled to for binaries. Relative path to the "currentdirectory" is recommended to use. It will only be called while in the currentdirectory.
targetdirectory="../p42"
# First parts (before the variable value to be changed) of the corresponding generated pbs file names. The number of elements in the list should be the same as codefiles.
pbsfilenamepart1="dipolex_E_N_1_lam_894_eps_2.1013_0.001_a_225_x_ dipoley_E_N_1_lam_894_eps_2.1013_0.001_a_225_x_ dipolez_E_N_1_lam_894_eps_2.1013_0.001_a_225_x_"
# Second part of the generated pbs file names after the variable value to be updated.
pbsfilenamepart2="_y_0_q_0_1.45_146.pbs"


# Starting the job. Most likely no need to change the following.
echo "Updating code files $codefiles from original $variabletochange$parameterorigin to a list of new values in [$parameterlist] and then compile the codes to submit as PBS jobs. "

arr=($compiledscripts) # Put compiled script files in a list.
pbsarr=($pbsfilenamepart1) # Put pbs file name part1 into a list.
for param in $parameterlist
do
  ii=0;
  # Replace lines.
  for codefile in $codefiles
  do
    echo "Modifying $codefile by updating $variabletochange from $parameterorigin to $param."
    # Update parameter.
    if grep -q "$varialbetochange$parameterorigin" "$codefile"; then
      echo "    Search and replace lines with s/$variabletochange$parameterorigin/$variabletochange$param/ from $codefile"
      sed -i "s/$variabletochange$parameterorigin/$variabletochange$param/" $codefile
      # Compile the code.
      echo "    running g++ $codefile -lstdc++ -o $targetdirectory/${arr[$ii]}" 
      g++ $codefile -lstdc++ -o $targetdirectory/${arr[$ii]}
      cd $targetdirectory
      echo "    now in $targetdirectory to run ./${arr[$ii]}"
      ./${arr[$ii]}
      echo "    submitting ${pbsarr[$ii]}$param$pbsfilenamepart2."
      qsub ${pbsarr[$ii]}$param$pbsfilenamepart2
      echo "Parameter $param for ${arr[$ii]} is now in simulation."
      cd $currentdirectory
    else
      echo " ERROR: The code file $codefile doesn't have the line $variabletochange$parameterorigin."
      exit 0
    fi
    ii=$(($ii+1))
    echo $ii
  done
  parameterorigin=$param ;
done
echo "All done!"
