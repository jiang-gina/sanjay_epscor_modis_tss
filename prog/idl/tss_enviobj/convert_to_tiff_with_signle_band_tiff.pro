pro convert_to_tiff_with_single_band_tiff, file_in

;bring up traditional envi_* subroutiones 

start_batch

;restore, filename=file_geotag

;restore, filename='/home/jzhu4/projects/sanjay/prog/idl/tss_enviobj/geotag.sav'

;file='/home/jzhu4/data/sanjay_data/2013/2013_refl1'

;file='/home/jzhu4/data/sanjay_data/2013/01/2013.01.01/2013001_se_ak_aea.obscov_1.tif'

;void= READ_TIFF(file, GEOTIFF=geotag)

;save, geotag, filename='geotag.sav'


;-   convert into tiff

wrkdir=file_dirname(file_in)

filen=file_basename(file_in)

yyyy=strmid(filen,0,4)

file_out=file_in+'.tif'



;produce the geotag from the file_in

;geotag=create_geotag(file_in)

;get single_band_tiff file

file_single_band=wrkdir+'/01/'+yyyy+'.01.01/'+yyyy+'001_se_ak_aea.num_observations.tif'

void= READ_TIFF(file_single_band, GEOTIFF=geotag)

;save, geotag, filename='geotag.sav'


envi_open_file,file_in,/NO_INTERACTIVE_QUERY,r_fid=n_fid

envi_file_query,n_fid,dims=n_dims,nb=n_nb,ns=n_ns,nl=n_nl,data_type=n_dt 

pos=lindgen(n_nb)

;use write_tiff with geotiff keyward to output a tiff file 

;file_out='/home/jzhu4/data/sanjay_data/2013/2013_refl1_test.tif'
 
img=make_array(n_nb, n_ns, n_nl,/INTEGER)
  
for i=0L, n_nb-1 do begin
  
img[i,*,*]=envi_get_data(FID=n_fid,DIMS=n_dims,POS=pos[i])
 
endfor

write_tiff, file_out, img, /signed, /short, geotiff=geotag

end  
