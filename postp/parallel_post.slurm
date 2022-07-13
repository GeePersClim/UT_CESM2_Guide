#!/bin/bash
#SBATCH -J postp.0ka.4XCO2          # job name
#SBATCH -o launcher.o%j             # output and error file name (%j expands to SLURM jobID)
#SBATCH -N 1                        # number of nodes requested
#SBATCH -n 10                       # total number of tasks to run in parallel
#SBATCH -p normal                   # queue (partition) 
#SBATCH -t 10:00:00                 # run time (hh:mm:ss) 
#SBATCH -A ATM22001                 # Allocation project name to charge job against
#SBATCH --mail-user=youremail@address
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes

module load launcher # Load the module launcher on Lonestar6.

export LAUNCHER_WORKDIR=working_directory # Put here the work directory that hosts all these scripts.
export LAUNCHER_JOB_FILE=parallel_launcher # It refers to the file parallel_launcher in this repo.

${LAUNCHER_DIR}/paramrun
