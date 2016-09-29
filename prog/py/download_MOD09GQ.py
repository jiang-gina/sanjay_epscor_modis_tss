#!/home/jzhu4/apps/virtpython27/bin/python
#jzhu, 2015/6/9
#This script use wget to download MOD09GQ dataset from http://e4ftl01.cr.usgs.gov/MOLT/MOD09GQ.005.
#user input start date, end date, as well as output directory.
#MOD09GQ data h10v03 and h11v03 tile files are downloaded and
#saved to $out_dir/$yyyy/$mm.
import sys
from datetime import date
import os

def date2doy(yyyydotmmdotdd):
	[yyyy,mm,dd]=yyyydotmmdotdd.split('.')
	d1=date(int(yyyy),int(mm),int(dd))
	d2=date(int(yyyy),1,1)
	doy=(d1-d2).days + 1
	return doy

def doy2date(yyyy,doy):
    ss=date.fromordinal(date(int(yyyy),1,1).toordinal() +doy-1 )	
    return ss.strftime('%Y.%m.%d')


if __name__ == "__main__":

	if len(sys.argv) != 4:
		print "Three input parameters:date_st(yyyy.mm.dd), date_ed(yyyy.mm.dd),out_dir"
		sys.exit(1)

	datestr1=sys.argv[1]
	datestr2=sys.argv[2]
	out_dir =sys.argv[3]
    
	os.system("mkdir -p "+out_dir)

	[yyyy1, mm1,dd1]=datestr1.split('.')

	doy1=date2doy(datestr1)
	doy2=date2doy(datestr2)
    
	for date_i in xrange( doy1,doy2 + 1 ):
		datestr=doy2date(yyyy1,date_i)
		[yyyy, mm,dd]=datestr.split('.')
                
                #check if files exist, yes, no dot downlaod again                 
                #flist=os.listdir(out_dir+"/"+yyyy+"/"+mm+"/"+datestr)
		#matching=[s for s in flist if "h10v03" or "h11v03" in s]
                #num=len(matching)

                #if num < 2: 
		url_dir="http://e4ftl01.cr.usgs.gov/MOLT/MOD09GQ.005"
		cmd1="wget  -r  --no-parent -nH -nd -A '*h10v03*.hdf' "+"-P "+out_dir+"/"+yyyy+"/"+mm+"/"+datestr+"/ " +url_dir+"/"+datestr+"/"
		os.system(cmd1)
		cmd2="wget  -r  --no-parent -nH -nd -A '*h11v03*.hdf' "+"-P "+out_dir+"/"+yyyy+"/"+mm+"/"+datestr+"/ " +url_dir+"/"+datestr+"/"
		os.system(cmd2)

