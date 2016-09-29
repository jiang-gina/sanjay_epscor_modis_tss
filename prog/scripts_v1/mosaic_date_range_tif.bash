#!/bin/bash
#accept start_date and end_date, do mosaic for files in the date range.
#input date in YYYY.mm.dd format
#input range must be within one calender year.
#remenber to define PYTHONPATH to include /home/jiang/projects/sanjay/prog/py

if [ $# != 3 ];then

	echo "Three input parameters: start_date(yyyy.mm.dd), end_date(yyyy.mm.dd), data_main_dir"

	exit 1;

fi

st_date=$1

ed_date=$2

data_main_dir=$3


if [ ! -d "$data_main_dir" ]; then
	echo "data_main_dir does not exist"
	exit 1
fi


source ./project_env.bash


st_yyyy=${st_date:0:4}

cmd="import convert_date_doy; print convert_date_doy.date2doy('$st_date')"

st_doy=$($PYTHON_DIR/python -c "$cmd" )

ed_yyyy=${ed_date:0:4}

cmd="import convert_date_doy; print convert_date_doy.date2doy('$ed_date')"

ed_doy=$($PYTHON_DIR/python -c "$cmd" )



i=$st_doy

while [[ $i -le $ed_doy ]]

do
	cmd="import convert_date_doy; print convert_date_doy.doy2date('$st_yyyy',$i)"

    yyyydotmmdotdd=$($PYTHON_DIR/python -c "$cmd" )

    yyyy1=${yyyydotmmdotdd:0:4}
	mm1=${yyyydotmmdotdd:5:2}
	dd1=${yyyydotmmdotdd:8:2}

    src_dir=$data_main_dir/$yyyy1/$mm1/$yyyydotmmdotdd
    des_dir=$data_main_dir/$yyyy1/$mm1/$yyyydotmmdotdd
     
	istr=$(printf "%03d" $i)

	./mosaic_one_day_tif.bash $src_dir $des_dir ${yyyy1}${istr}
    
	#delete two tile files
    rm $src_dir/MOD09GQ.*h11v03*.hdf
	rm $src_dir/MOD09GQ.*h10v03*.hdf

    ((i = i + 1))
done	
