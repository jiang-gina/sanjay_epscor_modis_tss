pro stack_one_year_enviobj,flist_numobs, out_fn, out_fc, out_fq, out_fb1, out_fb2

;This routine open one year snow files defined in file lists, stack these file,subset, and output the one-year snow file 
;which includes a 365*2 bands. 

;inputs: yyyy_flist_cover----file list of snow cover classification of snow year yyyy
;        yyyy_flist_fract----file list of snow fractional cover of snow_year yyyy 
;;;        yyyy_flist_qual ----- file list of snow data quanlity of snow year yyyy

;        upper_l_lon,upper_l_lat-----upper left coordinate in unit of meter
;        low_r_lon,low_r_lat-----lower right cordinate in unit of meter
;        if you do not want to do subsize, you input 0,0,0,0 for upper_l_lon,upper_l_lat,
;        lower_r_lon and lower_r_lat.
;        
;jzhu, 6/16/2015, stack one-year of numobs, obscov, qc250, refl1, and refl2 respectively, that means we get five one-year-stacked data files.

;five sd are: num_observations, obscov_1, QC_250m_1, sur_refl_b01_1, sur_refl_b02_1


if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse

;---- read these five file lists into flist and flist_bq


openr,u1,flist_numobs,/get_lun

flistnumobs=strarr(368) ; 366/year

;---- read flist_numobs file into flistnumobs
tmp=' '
j=0L
while not EOF(u1) do begin

readf,u1,tmp

flistnumobs(j)=tmp

j=j+1

endwhile


close,u1


flistnumobs =flistnumobs[where(flistnumobs NE '')]

;---- get the number of files

num=(size(flistnumobs))(1)

;---- get workdir and year from file

;;p =strpos(flistnumobs,sign,/reverse_search)

;len=strlen(flistnumobs)

;wrkdir=strmid(flistnumobs,0,p+1)

wrkdir=file_dirname(flist_numobs)

;filen =strmid(flistnumobs,p+1,len-p)

filen=file_basename(flist_numobs)

year=strmid(filen,0,4)  ;eMTH_NDVI.2008.036-042.QKM.VI_NDVI.005.2011202142526.tif


;---- define a struc to save info of each file


x={flist,fn:'abc',bname:'abc',fid:0L,dims:lonarr(5),pos:0L}

flistn=replicate(x,num) ;save num of observation data files

flist1=replicate(x,num) ;save refl1 data files

flist2=replicate(x,num) ;save refl2 data files

flistq=replicate(x,num); save QC data files

flistc=replicate(x,num); save obscove data files


start_batch  ; into envi batch_mode

;---- go through one year cover and fract files

for j=0L, num-1 do begin

fn_numobs = strtrim(flistnumobs(j),2)

;---- for new data name
strn='num_observations'
strc='obscov_1'
strq='QC_250m_1'
str1='sur_refl_b01_1'
str2='sur_refl_b02_1'

p=strpos(fn_numobs,strn)

len=strlen(fn_numobs)

file_hdr=strmid(fn_numobs,0,p)

file_end =strmid(fn_numobs,p+strlen(strn),len-1-strlen(strn) )

fn_obscov=file_hdr+strc+file_end

fn_qc250=file_hdr+strq+file_end

fn_refl1=file_hdr+str1+file_end

fn_refl2=file_hdr+str2+file_end


idx =where(flistnumobs EQ fn_numobs,cnt)

if cnt EQ 1 then begin

;---- read cover, fract, and qual 

print, 'process the '+string(j)+' th file: ' +fn_numobs

read_mod09gq_enviobj, wrkdir,fn_numobs,fn_obscov,fn_qc250,fn_refl1, fn_refl2, rt_fid_numobs,rt_fid_obscov,rt_fid_qc250,rt_fid_refl1, rt_fid_refl2

endif else begin

;---- no relative bq file, do not cut off no-sense points
endelse


;------- save info fo each numofobs file --------------
envi_file_query,rt_fid_numobs,dims=dims,nb=nb,fname=fn,data_type=n_dt

p1=strpos(fn_numobs,sign,/reverse_search)

tmpbname= strmid(fn_numobs,p1+1,7)  ; for new data, its name looks like:2010-273.Fractional_Snow_Cover.tif

flistn[j].fn=fn_numobs+'.good'
flistn[j].bname=tmpbname
flistn[j].fid=rt_fid_numobs
flistn[j].dims=dims
flistn[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each obscov file------------
envi_file_query,rt_fid_obscov,dims=dims,nb=nb,fname=fn,data_type=c_dt

p1=strpos(fn_obscov,sign,/reverse_search)
tmpbname= strmid(fn_obscov,p1+1,7)
flistc[j].fn=fn_obscov+'.good'
flistc[j].bname=tmpbname
flistc[j].fid=rt_fid_obscov
flistc[j].dims=dims
flistc[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each qc250 file------------
envi_file_query,rt_fid_qc250,dims=dims,nb=nb,fname=fn,data_type=q_dt

p1=strpos(fn_qc250,sign,/reverse_search)
tmpbname= strmid(fn_qc250,p1+1,7)
flistq[j].fn=fn_qc250+'.good'
flistq[j].bname=tmpbname
flistq[j].fid=rt_fid_qc250
flistq[j].dims=dims
flistq[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each refl1 file------------
envi_file_query,rt_fid_refl1,dims=dims,nb=nb,fname=fn,data_type=b1_dt

p1=strpos(fn_refl1,sign,/reverse_search)
tmpbname= strmid(fn_refl1,p1+1,7)
flist1[j].fn=fn_refl1+'.good'
flist1[j].bname=tmpbname
flist1[j].fid=rt_fid_refl1
flist1[j].dims=dims
flist1[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate


;-------save info of each refl2 file------------
envi_file_query,rt_fid_refl2,dims=dims,nb=nb,fname=fn,data_type=b2_dt

p1=strpos(fn_refl2,sign,/reverse_search)
tmpbname= strmid(fn_refl2,p1+1,7)
flist2[j].fn=fn_refl2+'.good'
flist2[j].bname=tmpbname
flist2[j].fid=rt_fid_refl2
flist2[j].dims=dims
flist2[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate


endfor



; 
;----stack numobs  ------------------

  ; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;

  ;first file id is flistn[0].fid

  out_proj = envi_get_projection( fid=flistn[0].fid, pixel_size=out_ps)

  out_name = wrkdir+'/'+year+'_numobs.img'
  
  out_fn =out_name
  
  out_dt = n_dt

 envi_doit, 'envi_layer_stacking_doit', /EXCLUSIVE, $
    fid=flistn.fid, pos=flistn.pos, dims=flistn.dims,$
    out_dt=out_dt, out_name=out_name,out_bname=flistn.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistn[j].fid,/remove,/delete

endfor

envi_file_mng,id=tot_layer_fid, /remove


;-   convert into tiff

;e=ENVI(/HEADLESS)

;if FILE_TEST(out_name+'.tif') then begin
;  FILE_DELETE, out_name+'.tif'
;endif
;raster=e.OpenRaster(out_name)
;raster.Export, out_name+'.tif', 'TIFF'
;FILE_DELETE, out_name, out_name+'.hdr'


;---- stack obscov together

 ;first file id is flistc[0].fid

  out_proj = envi_get_projection(fid = flistc[0].fid, pixel_size=out_ps)

  out_name = wrkdir+'/'+year+'_obscov.img'
  
  out_fc=out_name
  
  out_dt = c_dt

 envi_doit, 'envi_layer_stacking_doit', /EXCLUSIVE, $
    fid=flistc.fid, pos=flistc.pos, dims=flistc.dims,$
    out_dt=out_dt, out_name=out_name,out_bname=flistc.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistc[j].fid,/remove,/delete

endfor

envi_file_mng,id=tot_layer_fid, /remove


;-   convert into tiff

;e=ENVI(/HEADLESS)

;if FILE_TEST(out_name+'.tif') then begin
;  FILE_DELETE, out_name+'.tif'
;endif
;raster=e.OpenRaster(out_name)
;raster.Export, out_name+'.tif', 'TIFF'
;FILE_DELETE, out_name, out_name+'.hdr'
;output quali file

;---- stack qc250 together

 ;first file id is flistt[0].fid

  out_proj = envi_get_projection(fid = flistq[0].fid, pixel_size=out_ps)

  out_name = wrkdir+'/'+year+'_qc250.img'

  out_fq=out_name
  
  out_dt = q_dt



 envi_doit, 'envi_layer_stacking_doit', /EXCLUSIVE, $
    fid=flistq.fid, pos=flistq.pos, dims=flistq.dims,$
    out_dt=out_dt, out_name=out_name,out_bname=flistq.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flistq[j].fid,/remove,/delete

endfor

envi_file_mng,id=tot_layer_fid, /remove

;-   convert into tiff

;e=ENVI(/HEADLESS)

;if FILE_TEST(out_name+'.tif') then begin
;  FILE_DELETE, out_name+'.tif'
;endif
;raster=e.OpenRaster(out_name)
;raster.Export, out_name+'.tif', 'TIFF'
;FILE_DELETE, out_name, out_name+'.hdr'


;output refl1 file

;first file id is flistt[0].fid

  out_proj = envi_get_projection(fid = flist1[0].fid, pixel_size=out_ps)

  out_name = wrkdir+'/'+year+'_refl1.img'

  out_fb1=out_name
  
  out_dt = b1_dt

  ;
  ; Call the layer stacking routine. Do not
  ; set the exclusive keyword allow for an
  ; inclusive result. Use cubic convolution
  ; for the interpolation method.
  ;
 ; envi_doit, 'envi_layer_stacking_doit', $
 ;   fid=fid, pos=pos, dims=dims, $
 ;   out_dt=out_dt, out_name=out_name, $
 ;   interp=2, out_ps=out_ps, $
 ;   out_proj=out_proj, r_fid=r_fid
  ;

 envi_doit, 'envi_layer_stacking_doit', /EXCLUSIVE, $
    fid=flist1.fid, pos=flist1.pos, dims=flist1.dims,$
    out_dt=out_dt, out_name=out_name,out_bname=flist1.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

envi_file_mng,id=flist1[j].fid,/remove,/delete

endfor

envi_file_mng,id=tot_layer_fid, /remove




;-   convert into tiff

;e=ENVI(/HEADLESS)


;if FILE_TEST(out_name+'.tif') then begin
;  FILE_DELETE, out_name+'.tif'
;endif
;raster=e.OpenRaster(out_name)
;raster.Export, out_name+'.tif', 'TIFF'
;FILE_DELETE, out_name, out_name+'.hdr'


;---- stack refl2 together

;first file id is flistt[0].fid

out_proj = envi_get_projection(fid = flist2[0].fid, pixel_size=out_ps)

out_name = wrkdir+'/'+year+'_refl2.img'

out_fb2=out_name

out_dt = b2_dt


envi_doit, 'envi_layer_stacking_doit',/EXCLUSIVE, $
  fid=flist2.fid, pos=flist2.pos, dims=flist2.dims,$
  out_dt=out_dt, out_name=out_name,out_bname=flist2.bname, $
  interp=2, out_ps=out_ps, $
  out_proj=out_proj, r_fid=tot_layer_fid

;---- delete good_* files

for j=0L,num-1 do begin

  envi_file_mng,id=flist2[j].fid,/remove,/delete

endfor

envi_file_mng,id=tot_layer_fid, /remove

;-   convert into tiff

;e=ENVI(/HEADLESS)

;if FILE_TEST(out_name+'.tif') then begin
;  FILE_DELETE, out_name+'.tif'
;endif
;raster=e.OpenRaster(out_name)
;raster.Export, out_name+'.tif', 'TIFF'
;e.close
;FILE_DELETE, out_name, out_name+'.hdr'


;-------print finish signal

print,'finishing stacking 5 science dataset files separately...'

envi_batch_exit

;e.close
; convert envi image file pairs 

end
