pro test_source_destination_index_offset

;
; Setup source image array
;
   source_samples = 3
   source_lines = 3
   source = intarr( source_samples, source_lines )
   source(*) = 1

;
; Setup destination image array
;
   destination_samples = 5
   destination_lines = 5
   destination = intarr( destination_samples, destination_lines )

;
; Setup source sample and line values
;
   source_sample_values = indgen( source_samples )
   source_line_values = indgen( source_lines )

;
; Setup source sample and line indices
;
   source_sample_indices = replicate(1,source_lines)##source_sample_values
   source_line_indices = replicate(1,source_samples)#source_line_values

;
; Apply offset to source indices to come up with a set of 
; destination indices
;
   destination_sample_indices = source_sample_indices + 2
   destination_line_indices = source_line_indices + 2

;
; Print out the arrays, intermediate, and final results
;

print, source
print
print, destination

;
; Looks like the two expressions below are equivalent...
; Who knew?...
;
; Second form may be more appropriate if it is subsectioning
; a smaller section of the source image
;
;
destination[ destination_sample_indices, destination_line_indices ] = $
      source
;destination[ destination_sample_indices, destination_line_indices ] = $
;      source[ source_sample_indices, source_line_indices ]

print
print, destination


end
