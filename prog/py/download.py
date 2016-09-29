#!/usr/local/bin/python2.7

import os
import wget
import sys


args=sys.argv

#args[1]=yyyy.mm.dd, args[2]=des_dir


des_dir='/home/jiang/projects/sanjay/data_v3'
url='http://e4ftl01.cr.usgs.gov/MOLT/MOD09GQ.005/2000.02.24/MOD09GQ.A2000055.h11v03.005.2006268081657.hdf'
cmd='cd '+des_dir
os.system(cmd)
wget.download(url)
