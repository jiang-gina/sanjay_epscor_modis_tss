#!/bin/bash
#create file list of a year
#input data_main_dir and yyyy
#looking for every day in $data_main_dir/$yyyy, create file list which include
#absolutely file names.

if [ $# -ne 2 ]; then
	echo "two parameters: data_main_dir, year(yyyy)"
	exit 1
fi

data_main_dir=$1

yyyy=$2

#create file list of $data_main_dir/$yyyy

cd $data_main_dir/$yyyy

find $PWD -name *se_ak_aea.num_observations.tif |sort >${yyyy}_flist_num_observations

exit 0
