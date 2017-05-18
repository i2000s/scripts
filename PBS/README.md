# README

This folder houses a few scripts used to automate some of the PBS job submissions in doing simulations on a cluster in UNM.

- C++ and bash script examples to setup a set of BEM simulations, compile them in binaries and submit them to a cluster with generated PBS scripts.
  - C++ script examples to generate the geometry configuration files and PBS scripts for submissions (see the later part of `quickreplacesubmitjobs.sh` for the steps to compile and submit those jobs):
    - `nanofiber_dipolex_E_new.cpp`, `nanofiber_dipoley_E_new.cpp` and `nanofiber_dipolez_E_new.cpp`.
  - A Bash script example to change a single parameter from the C++ scripts and automate the compilation and job-submission processes:
    - `quickreplacesubmitjobs.sh`.
