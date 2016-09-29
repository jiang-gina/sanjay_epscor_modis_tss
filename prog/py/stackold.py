#!/usr/local/bin/python2.7

from osgeo import gdal

import numpy as np

import matplotlib.pyplot as plt

import numpy.ma as ma

#file="/home/jiang/projects/sanjay/data_v2/MOD09GQ.A2015140.h11v02.005.2015142080932.hdf"

def hdf2tif(fn_hdfeos,fn_tiff)
	#this function accepts input hdf-eos file, output geotiff file
	#band1 and band2 will only save good data, bad data will be filled with -9999
	#input file is mosaiced file, name yyyymmdoy.hdf
    
    fn_tiff_prex=fn_hdfeos.split('.')[0]

	ds=gdal.Open(fn_hdfeos)

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
	#read in array of unint8 and transform into int8
	d0 = d0_sd.ReadAsArray().view(np.int8)

	d1_sd = gdal.Open(d1_name)

	d1 = d1_sd.ReadAsArray()

	d2_sd = gdal.Open(d2_name)

	d2 = d2_sd.ReadAsArray()

	d3_sd = gdal.Open(d3_name)

	d3 = d3_sd.ReadAsArray()

	d4_sd = gdal.Open(d4_name)

	d4 = d4_sd.ReadAsArray().view(np.int8)

	#process data

	#only choose good data which are indicated by d3=0011000000000000 binary


	msk=d3!=4096

	d1[msk]=-9999

	d2[msk]=-9999


	#d1msk=ma.MaskedArray(d1,mask=(d3 == 4096), fill_value=None)

	#d2msk=ma.MaskedArray(d2,mask=(d3 == 4096), fill_value=None)




	#output data into 4 separated geotiff format files

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
    
	rst=[]
    
	return [d0,d1,d2,d3,d4]


def stack2hdfeos(desVarList,fn_hdfeos)
	#read fn_hdfeos, add it to desVarList
	list=hdf2tif(fn_hdfeos)
	for i in xrange(1,4):
		desVarList[i]=dstack(desVarList[i],list[i])
    rst=desVarList
	return rst










