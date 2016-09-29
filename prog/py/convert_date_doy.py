#!/home/jzhu4/apps/virtpython27/bin/python
#jzhu, 2015/6/9
#This script use wget to download MOD09GQ dataset from http://e4ftl01.cr.usgs.gov/MOLT/MOD09GQ.005.
#user input start date, end date, as well as output directory.
#MOD09GQ data h10v03 and h11v03 tile files are downloaded and
#saved to output directory.
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
