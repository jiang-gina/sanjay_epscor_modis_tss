pro tss_main

;THis is main program. it calls stack_one_year_enviobj to do yearly stack, 
;then calls convert_envi_tif to convert envi file pairs to geotif file.
;commanline argumentL flist_numobs

args = COMMAND_LINE_ARGS(COUNT = num_args)

if num_args NE 1 then begin
  
  print, 'File list for num_observations is required.'
  
  return
  
endif

flist_numobs=args[0]

strn='num_observations'

p=strpos(flist_numobs,strn)


if p EQ -1 then begin
  
  print, 'File list for num_observations is required.'

  return
  
endif


;flist_numobs='/mnt/old_root/MOD09GQ/2001/2001_flist_num_observations_tst'


print, flist_numobs

;len=strlen(flist_numobs)

;file_hdr=strmid(fn_numobs,0,p)

;file_end =strmid(fn_numobs,p+strlen(strn),len-1-strlen(strn) )


wrkdir=file_dirname(flist_numobs)

filen=file_basename(flist_numobs)

year=strmid(filen,0,4)  ;flist_numobs has "yyyy_flist_num_observations" name style.


;print, 'wrkdir: '+wrkdir

;print, 'filen: '+filen

;print,'year: '+year

;call stack precedure to stack data according to flist_numobs

restore,filename='tss_enviobj.sav'


stack_one_year_enviobj, flist_numobs, out_fn, out_fc, out_fq, out_fb1, out_fb2


;call procedure to convert envi file pairs to geotif file.

file_geotag='/home/jzhu4/projects/sanjay/prog/idl/tss_enviobj/geotag.sav'

;convert_to_tiff, out_fn, file_geotag

;convert_to_tiff, out_fc, file_geotag

;convert_to_tiff, out_fq, file_geotag

;convert_to_tiff, out_fb1,file_geotag

;convert_to_tiff, out_fb2,file_geotag

end
