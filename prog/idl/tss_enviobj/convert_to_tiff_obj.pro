pro convert_to_tiff_obj

;bring up traditional envi_* subroutiones 
;start_batch

;launch the obj application

e=ENVI()

file='/home/jzhu4/data/sanjay_data/2013/2013_refl1'

;file='/home/jzhu4/data/sanjay_data/2013/01/2013.01.01/2013001_se_ak_aea.obscov_1.tif'


raster = e.OpenRaster(file)

x=raster.spatialref

; Create an output raster

newFile = e.GetTemporaryFilename('tif')

;subRaster = ENVISubsetRaster(raster)

projx=e.CreateRasterSpatialRef('standard', PIXEL_SIZE=x.PIXEL_SIZE, $
  TIE_POINT_MAP=X.TIE_POINT_MAP, TIE_POINT_PIXEL=x.TIE_POINT_PIXEL, $
  COORD_SYS_STR=x.COORD_SYS_STR)

;raster = e.OpenRaster(file, SPATIALREF_OVERRIDE=projx)

Raster.Export, newFile, 'TIFF'

end


