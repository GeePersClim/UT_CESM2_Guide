#! /bin/tcsh
 
set vproj = 'B1850.f19_g17.example'      	          # set the directory name for your case
set vcomps = 'B1850'                              	# set the alias for your --compset
set vres = 'f19_g17'                                # set the alias for your –grid (or resolution)
set projid = 'A-ig2'                                # set the account charged
set casepath = '/work/07931/userid/CESM2/cases/'   
# set the directory for your case root. Please change the userid to yours.
set caserunpath = '/scratch/07931/userid/CESM2.1.3/' 
# set the directory where the output should be generated. It is suggested to be put in a directory under /scratch/. 
 
rm -r $casepath$vproj                           
# delete the case root directory. For continuous resubmitted jobs, this line should be commented.
 
rm -r $caserunpath$vproj                       
# delete the case run directory. Same as above. 
 
cd /work/07931/dunyuliu/group_share/CESM2.1.3/my_cesm_sandbox/cime/scripts

./create_newcase --project $projid --case $casepath$vproj --compset $vcomps --res $vres --input-dir /work/07931/dunyuliu/group_share/CESM2.1.3/inputdata 
# It calls create_newcase to create a new CESM case. The input data has already been
# downloaded in the shared directory
# /work/07931/dunyuliu/group_share/CESM2.1.3/inputdata/. For access, please contact
# Dr. Persad. Alternatively, you can set your own path for storing input data. 
 
cd $casepath$vproj					      # get into the case root directory
 
# setting up PE layout.
./xmlchange NTASKS_ATM=-4   			# 4 nodes for the ATM component.
# A negative number indicates the number of nodes used. A positive number indicates
# the number of # cores. On Lonestar5, a node typically has 24 nodes.
./xmlchange NTASKS_CPL=-4
./xmlchange NTASKS_OCN=-3
./xmlchange NTASKS_WAV=-1
./xmlchange NTASKS_GLC=-1
./xmlchange NTASKS_ICE=-2
./xmlchange NTASKS_ROF=-2
./xmlchange NTASKS_LND=-2
./xmlchange NTASKS_ESP=1  
# 1 core for ESP. When you scale, you don’t need to change this.
 
./xmlchange NTHRDS=1  				    # Thread for OpenMP parallelization.
 
#setting up the Root PE, i.e., the starting node number counted from 0. 
./xmlchange ROOTPE_ATM=0 
# For example, ATM component starts from node number 0 and runs on node 0-3.
./xmlchange ROOTPE_CPL=0
./xmlchange ROOTPE_OCN=-4 
# For example, OCN component starts from node number 4 and runs on node 4 and 5.
# It is suggested ATM and CPL run on the same nodes while OCN runs on separate
# nodes.
./xmlchange ROOTPE_WAV=0
./xmlchange ROOTPE_GLC=0
./xmlchange ROOTPE_ICE=-2
./xmlchange ROOTPE_ROF=0
./xmlchange ROOTPE_LND=0
./xmlchange ROOTPE_ESP=0
 
./xmlchange JOB_WALLCLOCK_TIME=12:00:00  
# Change wall clock time to 12 hours. Format for time is XX:XX:XX.
 
./case.setup   						       # set up a case
./case.build						         # build a case
./xmlquery STOP_OPTION,STOP_N 	 # show stop options
./xmlchange STOP_OPTION=nmonths,STOP_N=12 	
# change stop option to months and ask the code to stop after 12 months run. Pay #attention to that no space is allowed between 'nmonths,STOP_N'
./xmlchange DOUT_S=FALSE 			
# No short time archiving and writing out results. For productive runs and #postprocessing, it is suggested to be set as TRUE
 
#./xmlchange RESUBMIT=3				
# let CESM resubmit the job 3 times after the first run. A total of 4 runs will be #conducted. Pay attention to comment the rm commands at the beginning of the script if #you want to resubmit jobs

./case.submit  --resubmit-immediate 			
# submit a case to the clusters. Note that if you want to resubmit jobs, it is suggested to #add a flag --resubmit-immediate to submit all the jobs together with batch dependency. #In this case, you don't need to worry about unintended termination of your #resubmission.  
