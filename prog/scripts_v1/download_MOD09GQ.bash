#!/bin/bash

#inputs: datastrst, datastrnd. data string in yyyyy.mm.dd format
#download MOD09GQ.005 data h10v03 and h11v03, save to current directory

if [ $# != 2 ]; then
	echo 
	echo "this script takes three parameters:data_st, date_nd"
	echo
	exit 1
fi



datestr1=$1
datestr2=$2



url_dir=http://e4ftl01.cr.usgs.gov/MOLT/MOD09GQ.005
wget  -r  --no-parent -nH -nd -A '*h10v03*.hdf' $url_dir/$datestr/
wget  -r  --no-parent -nH -nd -A '*h11v03*.hdf' $url_dir/$datestr/
