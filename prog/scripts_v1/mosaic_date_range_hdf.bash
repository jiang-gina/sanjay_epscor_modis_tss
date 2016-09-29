#!/bin/bash
#accept start_date and end_date, do mosaic for files in the date range.
#input date in YYYY.mm.dd format
#input range must be within one calender year.
#remenber to define PYTHONPATH to include /home/jiang/projects/sanjay/prog/py

if [ $# != 2 ];then

	echo "two input parameters: start_date, end_date"

	exit 1;

fi

st_date=$1

ed_date=$2

st_yyyy=${st_date:0:4}

cmd="import convert_date_doy; print convert_date_doy.date2doy('$st_date')"

st_doy=$(/usr/local/bin/python2.7 -c "$cmd" )

ed_yyyy=${ed_date:0:4}

cmd="import convert_date_doy; print convert_date_doy.date2doy('$ed_date')"

ed_doy=$(/usr/local/bin/python2.7 -c "$cmd" )




#RESULT=$(python -c 'import test; print test.get_foo()')
#create the temp_dir

data_main_dir=/mnt/old_root/MOD09GQ

i=$st_doy

while [[ $i -le $ed_doy ]]

do
	cmd="import convert_date_doy; print convert_date_doy.doy2date('$st_yyyy',$i)"

    yyyydotmmdotdd=$(/usr/local/bin/python2.7 -c "$cmd" )

    yyyy1=${yyyydotmmdotdd:0:4}
	mm1=${yyyydotmmdotdd:5:2}
	dd1=${yyyydotmmdotdd:8:2}

    src_dir=$data_main_dir/$yyyy1/$mm1/$yyyydotmmdotdd
    des_dir=$data_main_dir/$yyyy1/$mm1/$yyyydotmmdotdd
     
	istr=$(printf "%03d" $i)

	./mosaic_one_day_hdf.bash $src_dir $des_dir ${yyyy1}${istr}
    
    ((i = i + 1))
done	
