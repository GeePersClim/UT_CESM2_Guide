#!/bin/tcsh

set vproj = 'test.B1850.f09g17.default.test4Frontera'
set vcomps = 'B1850'
set vres = 'f09_g17'
set projid = 'A-ig2'
set casepath = '/work2/07931/dunyuliu/1.Geeta/CESM2.1.3/cases/' #first mkdir of this directory under your account.
set caserunpath = '/scratch1/07931/dunyuliu/CESM2.1.3/'
set cesm_installation_root = '/work2/07931/dunyuliu/group_share/CESM2.1.3/my_cesm_sandbox_frontera'
set input_dir = '/work2/07931/dunyuliu/group_share/CESM2.1.3/inputdata'
set cesm_scripts = $cesm_installation_root/cime/scripts

rm -r $casepath$vproj
rm -r $caserunpath$vproj

cd $cesm_scripts
./create_newcase --project $projid --case $casepath$vproj --compset $vcomps --res $vres --input-dir $input_dir

cd $casepath$vproj

./xmlchange NTASKS_ATM=-4
./xmlchange NTASKS_CPL=-4
./xmlchange NTASKS_OCN=-2
./xmlchange NTASKS_WAV=-1
./xmlchange NTASKS_GLC=-1
./xmlchange NTASKS_ICE=-2
./xmlchange NTASKS_ROF=-2
./xmlchange NTASKS_LND=-2
./xmlchange NTASKS_ESP=1

./xmlchange NTHRDS=1

./xmlchange ROOTPE_ATM=0
./xmlchange ROOTPE_CPL=0
./xmlchange ROOTPE_OCN=-4
./xmlchange ROOTPE_WAV=0
./xmlchange ROOTPE_GLC=0
./xmlchange ROOTPE_ICE=-2
./xmlchange ROOTPE_ROF=0
./xmlchange ROOTPE_LND=0
./xmlchange ROOTPE_ESP=0

./xmlchange JOB_WALLCLOCK_TIME=10:00:00

./case.setup
./case.build
./xmlquery STOP_OPTION,STOP_N
./xmlchange STOP_OPTION=nmonths,STOP_N=12
#./xmlchange DOUT_S=FALSE
./case.submit
