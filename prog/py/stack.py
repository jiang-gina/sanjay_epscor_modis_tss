#!/home/jzhu4/apps/virtpython27/bin/python

from osgeo import gdal

import numpy as np
import os
import matplotlib.pyplot as plt

import numpy.ma as ma

#file="/home/jiang/projects/sanjay/data_v2/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf"

def hdf2dic(fn_hdfeos):
	#this function accepts input hdf-eos file, output file tif files
	#band1 and band2 will only save good data, bad data will be filled with -9999
	#input file is mosaiced file, name yyyymmdoy.hdf
    
	fn_tiff_prex=fn_hdfeos.split('.')[0]
	
	bname=os.path.basename(fn_hdfeos)[0:7]

	ds=gdal.Open(fn_hdfeos.split('\n')[0])

	# get the path for a specific subdataset
	#ds[0]=num_observations MODIS_Grid_2D (8-bit integer)
	#ds[1]=sur_refl_b01_1 MODIS_Grid_2D (16-bit integer)
	#ds[2]=sur_refl_b02_1 MODIS_Grid_2D (16-bit integer)
	#ds[3]=QC_250m_1 MODIS_Grid_2D (16-bit unsigned integer)
	#ds[4]=obscov_1 MODIS_Grid_2D (8-bit integer)

	#d2_name= [sd for sd, descr in ds.GetSubDatasets() if descr.endswith('sur_refl_b02_1 MODIS_Grid_2D (16-bit integer)')][0]


	#d0_name='HDF4_EOS:EOS_GRID:"/home/jiang/projects/sanjay/data/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf":MODIS_Grid_2D:num_observations'

	ds_name=ds.GetSubDatasets()

	d0_name=ds_name[0][0]

	#d1_name='HDF4_EOS:EOS_GRID:"/home/jiang/projects/sanjay/data/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf":MODIS_Grid_2D:sur_refl_b01_1'

	d1_name=ds_name[1][0]

	#d2_name='HDF4_EOS:EOS_GRID:"/home/jiang/projects/sanjay/data/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf":MODIS_Grid_2D:sur_refl_b02_1'

	d2_name=ds_name[2][0]

	#d3_name='HDF4_EOS:EOS_GRID:"/home/jiang/projects/sanjay/data/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf":MODIS_Grid_2D:QC_250m_1'

	d3_name=ds_name[3][0]

	#d4_name='HDF4_EOS:EOS_GRID:"/home/jiang/projects/sanjay/data/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf":MODIS_Grid_2D:obscov_1'

	d4_name=ds_name[4][0]

	#open and read it like normal

	d0_sd = gdal.Open(d0_name)
	d0_type=d0_sd.GetRasterBand(1).DataType
	#read in array of unint8 and transform into int8
	d0 = d0_sd.ReadAsArray()
	
	d1_sd = gdal.Open(d1_name)
	d1_type=d1_sd.GetRasterBand(1).DataType
	d1 = d1_sd.ReadAsArray()
	d2_sd = gdal.Open(d2_name)
	d2_type=d2_sd.GetRasterBand(1).DataType
	d2 = d2_sd.ReadAsArray()
	
	d3_sd = gdal.Open(d3_name)
	d3_type=d3_sd.GetRasterBand(1).DataType
	d3 = d3_sd.ReadAsArray()
	
	d4_sd = gdal.Open(d4_name)
	d4_type=d4_sd.GetRasterBand(1).DataType
	d4 = d4_sd.ReadAsArray().view(np.int8)
	
	#process data
	
	#only choose good data which are indicated by d3=0011000000000000 binary
	
	
	msk=d3!=4096
	
	d1msk=ma.masked_array(d1,msk)
	
	d2msk=ma.masked_array(d2,msk)
	
	# subtract minimum value for bands1 and 2.

	d1=d1-d1msk.min()

	d2=d2-d2msk.min()

	d1[msk]=-9999
	d2[msk]=-9999


	#d1msk=ma.MaskedArray(d1,mask=(d3 == 4096), fill_value=None)

	#d2msk=ma.MaskedArray(d2,mask=(d3 == 4096), fill_value=None)




	#output data into 5 separated geotiff format files

	#get parameters, ds must be from geotiff, for hfd, getProjection() return''
	geotransform = d0_sd.GetGeoTransform()
	spatialreference = d0_sd.GetProjection()
	ncol = d0_sd.RasterXSize
	nrow = d0_sd.RasterYSize
	nband = 1
 
	#create output file for d0
	#fmt = 'GTiff'
	#output_file=fn_tif_prex+'_num_observations.tif'
	#driver = gdal.GetDriverByName(fmt)
	#dst_dataset = driver.Create(output_file, ncol, nrow, nband, gdal.GDT_Byte)
	#dst_dataset.SetGeoTransform(geotransform)
	#dst_dataset.SetProjection(spatialreference)
	#dst_dataset.GetRasterBand(1).WriteArray(data)
	#dst_dataset = None



	#
	d0_sd = None
	d1_sd = None
	d2_sd = None
	d3_sd = None
	d4_sd = None
	ds = None
	rst=[d0,d1,d2,d3,d4]
	rst_name=['num_observations','sur_refl_b01_1','sur_refl_b02_1','QC_250m_1','obscov_1']
	totbname=[bname]
	rst_type=[d0_type,d1_type,d2_type,d3_type,d4_type]
	dic={'name':totbname,'5bandtype':rst_type,'5bandname':rst_name,'5banddata':rst,'proj':spatialreference, 'geotransform':geotransform,'fn_tiff_prex':fn_tiff_prex}
	return dic

def stack2hdfeos(dic,fn_hdfeos):
	#read fn_hdfeos, add it to desVarList
	dic2=hdf2dic(fn_hdfeos)
	if not dic:
		dic=dic2
	else:
		#append filename to dic
		
		dic['name'] = dic['name'] + dic2['name']

		num=len(dic['5banddata'])
		for i in xrange(0,num):

			dic['5banddata'][i]=np.dstack( (dic['5banddata'][i],dic2['5banddata'][i]) )

	rst=dic 
	return rst


   


def writegeotiff(onebanddic,output_fn_prex):
	#write geotif the one band, 
	#onebanddic={'filename':filename,'bandtype':bandtype,'bandname':bandname, 'banddata':banddata, 'proj':proj, 'geotransform':geotransform}
	[nrow,ncol,nband]=onebanddic['banddata'].shape
	xsize=ncol
	ysize=nrow
	geotransform=onebanddic['geotransform']
	proj=onebanddic['proj']
	datatype=onebanddic['bandtype']
    
	#create output file for band
	fmt = 'GTiff'
	output_file=output_fn_prex+'_'+onebanddic['bandname']+'.tif'
	driver = gdal.GetDriverByName(fmt)
	#dst_dataset = driver.Create(output_file, ncol, nrow, nband, gdal.GDT_Byte)
	dst_dataset = driver.Create(output_file, xsize, ysize, nband,datatype)
	dst_dataset.SetGeoTransform(geotransform)
	dst_dataset.SetProjection(proj)
    	
	for i in xrange(0,nband):
		dst_dataset.GetRasterBand(i+1).WriteArray(onebanddic['banddata'][:,:,i])
		
		dst_dataset.GetRasterBand(i+1).SetMetadata({'name':onebanddic['name'][i]})

def write5bandgeotiff(totdic,output_fn_prex):
	#write 5 band geotif files, one file per band.
	num=len(totdic['5bandname'])
	for i in xrange(0,num):
		onebanddic={'name':totdic['name'],'bandtype':totdic['5bandtype'][i],'bandname':totdic['5bandname'][i],'banddata':totdic['5banddata'][i],'proj':totdic['proj'],\
			    'geotransform':totdic['geotransform']}
		writegeotiff(onebanddic,output_fn_prex)
