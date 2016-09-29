#!/bin/bash
#this script calls idl program to stack 5 catagroies of one year of daily tif files into 5 one-year-stacked files.

if [ $# != 1 ];then

	echo "filelist for one-band.tif is required."
    exit 1
fi


cur_dir=$PWD

#flist='/mnt/old_root/MOD09GQ/2001/2001_flist_num_observations'

flist=$1

if [ ! -e $flist ]; then

	echo "file: $flist does not exist."
	exit 1
fi


source ./project_env.bash

idl_prog=$IDL_PROG_DIR/tss_enviobj

idl_com=$IDL_COM_DIR/idl


cd $idl_prog


$idl_com -e tss_main_one_band -args $flist


#$idl_com<<EOF
#restore,filename='${idl_prog}/tss_enviobj.sav'
#stack_one_year_enviobj,'$flist'
#exit
#EOF

cd $cur_dir
