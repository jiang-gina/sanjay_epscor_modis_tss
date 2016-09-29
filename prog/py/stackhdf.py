#!/home/jzhu4/apps/virtpython27/bin/python
#input filelist name, stack the files into a big file for each SD in the hdf file. output stacked geotif files.
#for example, filelist="/mnt/old_root/MOD09GQ/2001/flist_2001"

import sys
import os
import stack


if len(sys.argv) != 2:
	print "Input parameter:filelist"
	sys.exit(1)

flist=sys.argv[1]

data_main_dir=os.path.dirname(flist)

fname=os.path.basename(flist)

yyyy=(fname.split('_'))[0]

fn_tif_pref=data_main_dir+'/'+yyyy+'_satcked'



fn_list = open(flist,"r")

linelist = fn_list.readlines()

count = len(linelist)

totdic={}

for line in linelist:
    
	print "process "+ line

	totdic=stack.stack2hdfeos(totdic, line)

#write out the geotif files for 5 bands, one band per file.

stack.write5bandgeotiff(totdic, fn_tif_pref)

sys.exit(0)
