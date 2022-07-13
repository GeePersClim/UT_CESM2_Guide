#!/bin/bash

# This bash script uses NCO commands to post-process CESM model outputs.
# 
 
sim='b.e21.B1850cmip6.f09_g17.CESM2-SF-AA_EE.n8.001'   # name of the model
user="07931/dunyuliu"		# user id on Lonestar6
#var='TREFHT'			# variable to be processed
comp=$1
var=$2
start_yrs=1850			# first $start_yrs years of data to be dropped
run_yrs=1855			# the ending year

archdir="/scratch/${user}/CESM2.1.3/cesm_archive/${sim}/${comp}/hist" # directory to artchived hist data
scratchdir="/scratch/${user}/CESM2.1.3/timeseries/${sim}/${comp}"		  # directory for output
mkdir -p ${scratchdir}
#scratchdir = "/scratch/07931/dunyuliu/CESM2.1.3/cesm_archive/${sim}/atm/hist"

# Controlling parameters for functions desired
calc_tot_run_avg=0 		#Calculate average over the run, dropping first 40 years of data
calc_tot_run_avg_alt=0
doing_ts=1 			# Do initial calc needed for time series, if it hasn't been done previously
calc_mon_ts=1 			# Calculate monthly time series
calc_seas_ts=0 			# Calculate time series of seasonal averages
calc_ann_ts=0 			# Calculate time series of annual averages
calc_seas_avg=0 #DO NOT USE THIS #Calculate total average over each season, dropping first 40 years of data, just for var
calc_tot_avg_var=0 		# Calculate average over the run, dropping first 40 years of data, just for var

# Func1: do initial calculation for time series. 
if [ $doing_ts == 0 ]; then
  echo "==================="
  echo "Initial calculation for time series exsit. Skipping this step ..."
fi

if [ $doing_ts == 1 ]; then
  echo "==================="
  echo "Doing initial calculation for time series ..."

  i=${start_yrs}
  while [ $i -le $run_yrs ] 
  do
    if [ $i -lt 10 ]; then
      year="000$i"
    elif [ $i -lt 100 -a  $i -ge 10 ]; then
      year="00$i"
    elif [ $i -lt 1000 -a $i -ge 100 ]; then
      year="0$i"
    elif [ $i -ge 1000 ]; then
      year="$i"
    fi
    echo $year
    j=1
    while [ $j -le 12 ] 
    do
      if [ $j -lt 10 ];then
        month="0$j"
      else
        month="$j"
      fi
      
      ncks -O -v ${var} ${archdir}/${sim}.cam.h0.${year}-${month}.nc ${scratchdir}/${var}_${year}-${month}.nc
      
      pathtmp=${scratchdir}/${var}_${year}-${month}.nc
	  echo $pathtmp" is created ..."
      ((j+=1))
     done
     ((i+=1)) #or i=`expr $i + 1`
  done
fi

# Func2: calculate monthly time series.
if [ $calc_mon_ts == 1 ]; then
  echo "==================="
  echo "Calculating monthly time series ..."
  ncrcat -O ${scratchdir}/${var}_????-??.nc ${scratchdir}/${var}.${sim}.mon.${start_yrs}-${run_yrs}.nc
  pathtmp=${scratchdir}/${var}.${sim}.mon.${start_yrs}-${run_yrs}.nc
  echo $pathtmp" is created ..."
  
fi

# Func3: calculate seasonal time series.
if [ $calc_seas_ts == 1 ]; then

  # First, create single month time series.
  echo "==================="
  echo "Calculating seasonal time series ..."
  echo "First, creating single month time series ..."
  echo "Then, creating seasonal time series ..."
  for monid in $(seq -f "%02g" 1 12)
    do 
  	ncrcat -O ${scratchdir}/${var}_???-${monid}.nc ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.${monid}.nc
    done

  #DJF
  ncea -O ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.12.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.01.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.02.nc ${archdir}/${var}.${sim}.ts.001-${run_yrs}.DJF.nc
  pathtmp=${archdir}/${var}.${sim}.ts.001-${run_yrs}.DJF.nc
  echo $pathtmp" is created ..."
  
  #MAM
  ncea -O ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.03.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.04.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.05.nc ${archdir}/${var}.${sim}.ts.001-${run_yrs}.MAM.nc
  pathtmp=${archdir}/${var}.${sim}.ts.001-${run_yrs}.MAM.nc
  echo $pathtmp" is created ..."
  
  #JJA
  ncea -O ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.06.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.07.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.08.nc ${archdir}/${var}.${sim}.ts.001-${run_yrs}.JJA.nc
  pathtmp=${archdir}/${var}.${sim}.ts.001-${run_yrs}.JAN.nc
  echo $pathtmp" is created ..."
  
  #SON
  ncea -O ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.09.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.10.nc  ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.11.nc ${archdir}/${var}.${sim}.ts.001-${run_yrs}.SON.nc
  pathtmp=${archdir}/${var}.${sim}.ts.001-${run_yrs}.SON.nc
  echo $pathtmp" is created ..."
  
###
fi

# Func3: calculate annual time series.
if [ ${calc_ann_ts} == 1 ]; then
  echo "==================="
  echo "Calculating annual time series ..."
  ncea -O ${scratchdir}/${var}.${sim}.mon.001-${run_yrs}.??.nc ${archdir}/${var}.${sim}.ts.001-${run_yrs}.ANN.nc
  pathtmp=${archdir}/${var}.${sim}.ts.001-${run_yrs}.ANN.nc
  echo $pathtmp" is created ..."

fi

# Func4: calculate the total run average, dropping the assigned first $start_yrs of data
if [ $calc_tot_avg_var == 1 ]; then
  echo "==================="
  pathtmp="Calculating the total run average, dropping the first "$start_yrs" data ..."
  echo $pathtmp
  
  if [ $run_yrs -le 99 ]; then
	yrcap=$run_yrs
  else 
	yrcap=99
  fi
  
  for NUM in $(seq -f "%03g" $((start_yrs+1)) $yrcap)
    do 

      ncra -O ${scratchdir}/${var}_${NUM}-??.nc ${scratchdir}/${var}.${sim}.cam.ann.${NUM}.nc
	  pathtmp=${scratchdir}/${var}.${sim}.cam.ann.${NUM}.nc
      echo $pathtmp" is created ..."
    
    done

  if [ $run_yrs -ge 100 ]; then
  for NUM2 in `seq 100 1 ${run_yrs}`
    do
      ncra -O ${scratchdir}/${var}_${NUM2}-??.nc ${scratchdir}/${var}.${sim}.cam.ann.0${NUM2}.nc
	  pathtmp=${scratchdir}/${var}.${sim}.cam.ann.0${NUM2}.nc
      echo $pathtmp" is created ..."
    
    done
  fi

  ncra -O ${scratchdir}/${var}.${sim}.cam.ann.???.nc  ${archdir}/${var}.${sim}.cam.mean.${start_yr}-${run_yrs}.nc
  pathtmp=${archdir}/${var}.${sim}.cam.mean.${start_yr}-${run_yrs}.nc
  echo $pathtmp" is created ..."
fi


# ######NEED TO FIX EVERYTHING BELOW THIS####

# if [ ${calc_seas_avg} == 1 ]; then
# ### Seasonal averages -- have to have created seasonal time series
# for NUM in `seq 40 1 99`
# do 
# ncra ${archdir}/${sim}.cam.h0.00${NUM}-??.nc ${scratchdir}/${sim}.cam.ann.00${NUM}.nc
# done

# if [ ${run_yrs} -ge 100 ]; then
# for NUM2 in `seq 100 1 ${run_yrs}`
# do
# ncra ${archdir}/${sim}.cam.h0.0${NUM2}-??.nc ${scratchdir}/${sim}.cam.ann.0${NUM2}.nc
# done
# fi

# #ncra ${scratchdir}/${sim}.cam.ann.????.nc  ${archdir}/${sim}.cam.mean.40-${run_yrs}.nc

# #DJF
# ncra ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.12.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.01.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.02.nc ${archdir}/${var}.${sim}.ts.40-${run_yrs}.DJF.nc

# #MAM
# ncra ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.03.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.04.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.05.nc ${archdir}/${var}.${sim}.ts.40-${run_yrs}.MAM.nc

# #JJA
# ncra ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.06.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.07.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.08.nc ${archdir}/${var}.${sim}.ts.40-${run_yrs}.JJA.nc

# #SON
# ncra ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.09.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.10.nc  ${scratchdir}/${var}.${sim}.mon.40-${run_yrs}.11.nc ${archdir}/${var}.${sim}.ts.40-${run_yrs}.SON.nc

# ###
# fi

# exit
