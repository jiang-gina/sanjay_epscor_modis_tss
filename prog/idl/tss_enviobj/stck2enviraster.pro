;this program define some common functions
;

pro stck2enviraster, tot_enviraster, one_enviraster, out_file

Task = ENVITask('BuildBandStack')

Task.INPUT_RASTERS = [tot_enviraster, one_enviraster]

;Define outputs
Task.OUTPUT_RASTER_URI = out_file

;Run the task
Task.Execute

end