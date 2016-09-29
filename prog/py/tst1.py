#!/home/jiang/anaconda/bin/python
from osgeo import gdal

file="/home/jiang/projects/sanjay/a_image.tif"

dataset = gdal.Open(file, gdal.GA_ReadOnly)

for x in range(1, dataset.RasterCount + 1):
	band = dataset.GetRasterBand(x)
	array = band.ReadAsArray()
