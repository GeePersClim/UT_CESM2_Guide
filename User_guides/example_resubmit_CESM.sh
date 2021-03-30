#! /bin/tcsh
 
set vproj = 'B1850.f19_g17.example'  		# set the directory for your existing case
set casepath = '/work/07931/dunyuliu/CESM2/cases/'  
# set the directory for your existing case root.
 
cd $casepath$vproj					# get into the case root directory
 
./xmlchange JOB_WALLCLOCK_TIME=12:00:00   # Change wall clock time to 12 hours.
 
./xmlquery STOP_OPTION,STOP_N 		# show stop options
./xmlchange STOP_OPTION=nmonths,STOP_N=12 
# change stop option to months and ask the code to stop after 12 months run. 
# Pay attention to that no space is allowed between 'nmonths,STOP_N'.

./xmlchange DOUT_S=FALSE 			
# No short time archiving and writing out results. For productive runs and postprocessing
# set the value to TRUE.
 
./xmlchange RESUBMIT=3 
# let CESM resubmit the job 3 times after the first run. A total of 4 runs will be
# conducted. 

./case.submit --resubmit-immediate			
# submit a case to the HPC cluster. It is suggested to add a flag --resubmit-immediate to
# submit all the jobs together with batch dependency. In this case, you don't need to
# worry about unintended termination of your resubmission.  
