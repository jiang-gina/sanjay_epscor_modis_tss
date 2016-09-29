function create_geotag, file_envi

;start up traditional envi programming env.
;
start_batch

;file_envi='/home/jzhu4/data/sanjay_data/2013/2013_refl1'

envi_open_file,file_envi,/NO_INTERACTIVE_QUERY,r_fid=n_fid

envi_file_query,n_fid,dims=n_dims,nb=n_nb,ns=n_ns,nl=n_nl,data_type=n_dt

map_info = ENVI_GET_MAP_INFO(FID=n_fid)

;file_geotag='/home/jzhu4/data/sanjay_data/2013/geotag.sav'

;restore, filename=file_geotag

;Create some sample tag and geokey information

g_tags = { $
  ModelPixelScaleTag: [25, 25, 0d], $
  ModelTiepointTag: [80, 100, 0, 200000, 1500000, 0d], $
  GTModelTypeGeoKey: 1, $ ; (ModelTypeProjected)
  GTRasterTypeGeoKey: 2, $ ; (RasterPixelIsArea)
  GTCITATIONGEOKEY:'AEA        North American Datum 1983',     $ ; (North America Datum 1983)
  GeographicTypeGeoKey: 4269, $ ; (GCS_NAD27)
  GEOGGEODETICDATUMGEOKEY:6269,$
  GeogLinearUnitsGeoKey: 9001, $ ; (Linear_Meter)
  GEOGANGULARUNITSGEOKEY: 9102, $
  ProjectedCSTypeGeoKey: 32767, $ ; (user-defined)
  ProjectionGeoKey: 32767, $ ; (user-defined)
  ProjCoordTransGeoKey: 11, $ ; ( )
  PROJLINEARUNITSGEOKEY: 9001, $
  ProjStdParallel1GeoKey: 65.0d, $
  ProjStdParallel2GeoKey: 55.0d, $
  PROJNATORIGINLONGGEOKEY: -154.0d, $
  ProjNatOriginLatGeoKey: 50.0d, $
  ProjFalseEastingGeoKey: 0.0d, $
  ProjFalseNorthingGeoKey: 0.0d, $
  PROJFALSEORIGINLONGGEOKEY: 0.0d, $
  PROJFALSEORIGINLATGEOKEY: 0.0d $
}

;assign values to the g_tags
;parameters inmap_info.proj.params is defined as 
;3 Albers Equal Area |SMajor|SMinor|STDPR1|STDPR2|CentMer|OriginLat|FE|FN|x|x|x|x|x|x|x|
;from MRT41 user manual

g_tags.ModelPixelScaleTag[0:1]=map_info.ps

g_tags.ModelTiepointTag[0]=map_info.mc[0]
g_tags.ModelTiepointTag[1]=map_info.mc[1]
g_tags.ModelTiepointTag[2]=0.0d
g_tags.ModelTiepointTag[3]=map_info.mc[2]
g_tags.ModelTiepointTag[4]=map_info.mc[3]
g_tags.ModelTiepointTag[0]=0.0d

g_tags.GTCITATIONGEOKEY=map_info.proj.DATUM
g_tags.ProjStdParallel1GeoKey=map_info.proj.params[6]
g_tags.ProjStdParallel2GeoKey=map_info.proj.params[7]
g_tags.PROJNATORIGINLONGGEOKEY=map_info.proj.params[3]
g_tags.ProjNatOriginLatGeoKey=map_info.proj.params[2]
g_tags.ProjFalseEastingGeoKey=map_info.proj.params[4]
g_tags.ProjFalseNorthingGeoKey=map_info.proj.params[5]

;help, /stru,map_info.proj
;help,/stru,geotag

return, g_tags
end