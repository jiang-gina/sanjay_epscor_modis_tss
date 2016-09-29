# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from osgeo import gdal
import sys
import numpy as np
file="TrueMarble.32km.1350x675.tif"
g = gdal.Open(file)

red =  np.array(g.GetRasterBand(1).ReadAsArray())
green= np.array(g.GetRasterBand(2).ReadAsArray())
blue = np.array(g.GetRasterBand(3).ReadAsArray())

geo = g.GetGeoTransform()  
proj = g.GetProjection()   
shape = red.shape        
"""
do some processs on red

""" 

"""
output red into a geotiff file

"""

"one line comment"
 
driver = gdal.GetDriverByName("GTiff")

dst_ds = driver.Create( "ndvi.tif", shape[1], shape[0], 3, gdal.GDT_Byte)

dst_ds.SetGeoTransform( geo )

dst_ds.SetProjection( proj ) 

dst_ds.GetRasterBand(1).WriteArray(red)

dst_ds.GetRasterBand(2).WriteArray(green)

dst_ds.GetRasterBand(3).WriteArray(blue)

dst_ds = None  # save, close
 
sys.exit()


