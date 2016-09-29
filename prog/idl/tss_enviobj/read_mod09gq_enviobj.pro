;jzhu, 11/18/2011, this progranm read cover, fract, and quali files, and stack, subset,return three file describers
 
pro read_mod09gq_enviobj,wrkdir,fn_numobs,fn_obscov,fn_qc250,fn_refl1,fn_refl2,rt_fid_n,rt_fid_c,rt_fid_q,rt_fid_b1,rt_fid_b2

;inputs:
;wrkdir, work_directory
;fn_numobs, fn_obscov, fn_qc250, fn_refl1, fn_refl2
;output: rt_fid_numobs,rt_fid_obscov, rt_fid_qc250, rt_fid_refl1, rt_fid_refl2


if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse

;---- initial batch mode

p =strpos(fn_numobs,sign,/reverse_search)

;---open file_numobs data file, n_fn

envi_open_data_file,fn_numobs,r_fid=n_fid


if (n_fid NE -1) then begin

envi_file_query,n_fid,dims=n_dims,nb=n_nb,ns=n_ns,nl=n_nl,data_type=n_dt

data_n = envi_get_data(fid=n_fid, dims=n_dims, pos=0)


endif

;---open file obscov file, c_fn

ENVI_OPEN_FILE,fn_obscov,R_FID=c_fid

if (c_fid NE -1) then begin

envi_file_query,c_fid,dims=c_dims,nb=c_nb,ns=c_ns,nl=c_nl,data_type=c_dt

data_c = envi_get_data(fid=c_fid, dims=c_dims, pos=0)

endif


;---open qc250 file, q_fn

ENVI_OPEN_FILE,fn_qc250,R_FID=q_fid

if (q_fid NE -1) then begin

envi_file_query,q_fid,dims=q_dims,nb=q_nb,ns=q_ns,nl=q_nl,data_type=q_dt

data_q = envi_get_data(fid=q_fid, dims=q_dims,pos=0)

endif


;---open refl1 file, b1_fn

ENVI_OPEN_FILE,fn_refl1,R_FID=b1_fid

if (b1_fid NE -1) then begin

envi_file_query,b1_fid,dims=b1_dims,nb=b1_nb,ns=b1_ns,nl=b1_nl,data_type=b1_dt

data_b1 = envi_get_data(fid=b1_fid, dims=b1_dims, pos=0)

endif

;---open refl2 file, b2_fn

ENVI_OPEN_FILE,fn_refl2,R_FID=b2_fid

if (b2_fid NE -1) then begin

  envi_file_query,b2_fid,dims=b2_dims,nb=b2_nb,ns=b2_ns,nl=b2_nl,data_type=b2_dt

  data_b2 = envi_get_data(fid=b2_fid, dims=b2_dims,pos=0)

endif




; process bands 1 and 2 data
; 
;mask b1 and b2 according to qc250, mask_value=4096, keeps pixel where data_q= mask_value, set others with -9999

mask_value=4096 ;can be changed by user to filter different data

idx=where (data_q EQ mask_value,complement=idx_comp) 


;subtract minimum value for data_b1 and data_b2

b1min=min(data_b1[idx])

b2min=min(data_b2[idx])


data_b1=data_b1-b1min

data_b2=data_b2-b2min

;set no data as -9999

data_b1[idx_comp] =-9999

data_b1[idx_comp] =-9999






  
  
  
  ;
  ; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;
; out_proj = envi_get_projection(fid=n_fid,pixel_size=out_ps)


;layer_file = 'layer_'+strtrim(string(n_fid),2)

; out_name = wrkdir+tmp_layer_file

; out_dt=n_dt 
  


;---output five data to five files.


map_info=envi_get_map_info(fid=n_fid)

;--- output data_n
out_numobs_name = wrkdir+'_numobs_'+strtrim(string(n_fid),2)
envi_write_envi_file, data_n, data_type= n_dt, $
descrip = 'numobs', $
map_info = map_info,out_name=out_numobs_name, $
nl=n_nl, ns=n_ns, nb=1, r_fid=rt_fid_n

;----output data_c
map_info=envi_get_map_info(fid=c_fid)
out_obscov_name=wrkdir+'_obscov_'+strtrim(string(c_fid),2)
envi_write_envi_file, data_c, data_type= c_dt, $
descrip = 'obscov', $
map_info = map_info,out_name=out_obscov_name, $
nl=c_nl, ns=c_ns, nb=1, r_fid=rt_fid_c

;----output data_q
map_info=envi_get_map_info(fid=q_fid)
out_qc250_name=wrkdir+'_qc250_'+strtrim(string(q_fid),2)
envi_write_envi_file, data_q, data_type= q_dt, $
descrip = 'qc250', $
map_info = map_info,out_name=out_qc250_name, $
nl=q_nl, ns=q_ns, nb=1, r_fid=rt_fid_q


;----output refl1
map_info=envi_get_map_info(fid=b1_fid)
out_refl1_name=wrkdir+'_refl1_'+strtrim(string(b1_fid),2)
envi_write_envi_file, data_b1, data_type= b1_bt, $
descrip = 'refl1', $
map_info = map_info,out_name=out_refl1_name, $
nl=b1_nl, ns=b1_ns, nb=1, r_fid=rt_fid_b1

;----output refl2
map_info=envi_get_map_info(fid=b2_fid)
out_refl2_name=wrkdir+'_refl2_'+strtrim(string(b2_fid),2)
envi_write_envi_file, data_b2, data_type= b2_bt, $
descrip = 'refl2', $
map_info = map_info,out_name=out_refl2_name, $
nl=b2_nl, ns=b2_ns, nb=1, r_fid=rt_fid_b2

;---free memory and also delete temperary files, layer_* and subset_*

data_n=0
data_c=0
data_q=0
data_b1=0
data_b2=0


;---close file-ids

envi_file_mng, id=n_fid,/remove
envi_file_mng, id=c_fid,/remove
envi_file_mng, id=q_fid,/remove
envi_file_mng, id=b1_fid,/remove
envi_file_mng, id=b2_fid,/remove


return

end






