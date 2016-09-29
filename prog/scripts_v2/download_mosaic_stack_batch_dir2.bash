#!/bin/bash
#this script do downlaod, mosaic, and stack process of one-year data

if [ $# != 1 ];then
	echo "input year(yyyy)"
	exit 1
fi

source /home/jzhu4/projects/sanjay/prog/scripts/project_env.bash

proj_home_dir=/home/jzhu4/projects/sanjay

data_raw_dir=/home/jzhu4/data/sanjay_data

data_out_dir=/home/jzhu4/data/sanjay_data_dir2

#work_dir=$WORK_DIR

yyyy=$1

#st_date=${yyyy}.01.01

st_date=${yyyy}.01.01
ed_date=${yyyy}.12.31


#set up environment variables

source ./project_env.bash

#1. download data

cd $proj_home_dir/prog/py

./download_MOD09GQ.py $st_date $ed_date $data_raw_dir

#2. mosaic data

cd $proj_home_dir/prog/scripts

./mosaic_date_range_tif.bash $st_date $ed_date $data_raw_dir $data_out_dir

#3. create file list for num_observations files in $data_main_dir/$yyyy

./create_flist.bash $data_out_dir $yyyy

#4. stack the files acording to the file list

./stack_one_year_tif.bash ${data_out_dir}/${yyyy}/${yyyy}_flist_num_observations

