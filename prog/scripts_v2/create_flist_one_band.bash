#!/bin/bash
#create file list of a year
#input data_main_dir and yyyy
#looking for every day in $data_main_dir/$yyyy, create file list which include
#absolutely file names.

if [ $# -ne 3 ]; then
	echo "three parameters: data_main_dir, year(yyyy), bandname(num_observations, obscov_1, QC_250m_1, sur_refl_b01_1, sur_refl_b02_1"
	exit 1
fi

data_main_dir=$1

yyyy=$2

#create file list of $data_main_dir/$yyyy

cd $data_main_dir/$yyyy

find $PWD -name *se_ak_aea.${bandname}.tif |sort >${yyyy}_flist_${bandname}

exit 0
