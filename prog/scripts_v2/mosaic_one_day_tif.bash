#!/bin/bash
#jzhu, 2015/6/1
#This script accepts inputs: source_dir, dest_dir, and data_str,
#it mosaic tile files in $dest_dir/$date_str, it also do resample and subsize. 
#output are single-band tif files.
#for input example:
#raw_data_dir=/home/jiang/projects/sanjay/data_v2
#out_data_dir=/home/jiang/projects/sanjay/data_1
#date_str=2015136  #yyyydoy
#jzhu, 7/31/2015, check if we have ${item}.hdf, if yes, skip to resample,
#in the resample, use differnt parm file, which results in re-projection to alaska albers.


# check input parameters

if [ $# != 3 ]; then 

echo
echo "this script take three parameters: raw_data_dir, out_data_dir,date_str"
echo
exit 1
fi

raw_data_dir=$1

out_data_dir=$2

date_str=$3


if [ ! -d "$raw_data_dir" ]; then 
echo
echo "the data directory does not exist"
echo
exit 1
fi

source ./project_env.bash

#create output directroy

mkdir -p $out_data_dir

cur_dir=$PWD


item=${date_str}

if [ -e $out_data_dir/${item}.hdf ];then

cp $out_data_dir/${item}.hdf ${item}.hdf

else 

#create file list

ls $raw_data_dir/MOD09GQ.A$date_str*.hdf>flist

#1. mosaic tiles

#/home/jiang/apps/mrt/bin/mrtmosaic -i flist -o ${item}.hdf

${MRT_DIR}/mrtmosaic -i flist -o ${item}.hdf

fi

#2. subsize the data

#echo "INPUT_FILENAME = ${item}.hdf" > K.prm
#echo "SPECTRAL_SUBSET = ( 1 1 1 1 1)" >> K.prm
#echo "SPATIAL_SUBSET_TYPE = INPUT_LAT_LONG" >> K.prm
#echo "SPATIAL_SUBSET_UL_CORNER = ( 71.5 -179.9 )" >> K.prm
#echo "SPATIAL_SUBSET_LR_CORNER = ( 50.5 -129.5 )" >> K.prm
#echo "OUTPUT_FILENAME = Test.tif" >> K.prm
#echo "RESAMPLING_TYPE = NEAREST_NEIGHBOR" >> K.prm
#echo "OUTPUT_PROJECTION_TYPE = AEA" >> K.prm
#echo "OUTPUT_PROJECTION_PARAMETERS = ( 0.0 0.0 65.0 55.0 -154.0 50.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 )" >> K.prm
#echo "DATUM = NAD83" >> K.prm
#echo "OUTPUT_PIXEL_SIZE = 250" >> K.prm
#sed s/Test.tif/${item}.tif/ < K.prm > $item.prm

#/home/jiang/apps/mrt/bin/resample -i ${item}.hdf -f -o ${item}_se_ak_aea.tif -p modis_SE_AK_SIN_LINE_SAMPLE_tif.prm

${MRT_DIR}/resample -i ${item}.hdf -o ${item}_se_ak_aea.tif -p modis_SE_AK_AEA_tif.prm >> ${item}.log 2>&1

#mv output files to $data_out_dir

mv ${item}.hdf $out_data_dir

mv ${item}.log $out_data_dir

mv ${item}_se_ak_aea*.tif $out_data_dir

#/bin/rm ${item}.prm

/bin/rm flist

/bin/rm *.log

cd $cur_dir

exit
