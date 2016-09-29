;this program convert envi image file pair to geotiff file
;

pro convert_envi_tif, envi_file

  ;-   convert into tiff
  
  wrkdir=file_dirname(envi_file)

  ;filen =strmid(flistnumobs,p+1,len-p)

  filen=file_basename(envi_file)

  tif_file=envi_file+'.tif'

  e=ENVI(/HEADLESS)

  if FILE_TEST(tif_file) then begin
    FILE_DELETE, tif_file
  endif
  raster=e.OpenRaster(envi_file)
  raster.Export, tif_file, 'TIFF'
  ;FILE_DELETE, envi_file, envi_file+'.hdr'
  
  e.close
     
end
