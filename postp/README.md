There are 4 files for post-processing.

1. postproc_nco.sh is the serial shell script that use nco commands to get time series from CESM2 history files.
2. var_list hosts the variables to be post-processed.
3. parallel_post.slurm is the batch script for Lonestar6's Slurm system. 
4. parallel_launcher is the executable file to run postproc_nco.sh in pseudo-parallel mode with the module 'launcher' onn Lonestar6.
