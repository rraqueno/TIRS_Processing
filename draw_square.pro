pro draw_square

n_image_samples = 512
n_image_lines = 512

n_kernel_samples = 101
n_kernel_lines = 101

kernel_sample_center = n_kernel_samples/2
kernel_line_center = n_kernel_lines/2

n_window_samples = n_image_samples + n_kernel_samples
n_window_lines = n_image_lines + n_kernel_lines

window,xsize=n_window_samples,ysize=n_window_lines 

image=findgen(n_image_samples, n_image_lines )

buffered_image = fltarr(n_window_samples, n_window_lines )

buffered_image[ kernel_sample_center, kernel_line_center ] = image

window,0

tvscl, image, kernel_sample_center, kernel_line_center, /ord, $
	xsize=n_window_samples, ysize=n_window_lines


window,1

square_region_x = [0,0,101,101]
square_region_y = [0,101,101,0]
middle_region_x = 50
middle_region_y = 50

;x_values = indgen(500)
;y_values = indgen(500)

;x_index_array = replicate(1,n_elements(y_values)##x_values
;y_index_array = replicate(1,n_elements(y_values)#y_values

for sample = kernel_sample_center,n_image_samples do begin
	for line = kernel_line_center, n_image_lines do begin


	
	b=buffered_image[ sample - kernel_sample_center: $
			sample + kernel_sample_center, $
			line - kernel_sample_center: $
			line + kernel_sample_center ]

mean_dc = mean(b)

wset,1
tvscl,b,/ord
wset,0


		
plots,  square_region_x+sample,  - (square_region_y+line) + n_window_lines,/device
xyouts,middle_region_x+sample, -( middle_region_y+line ) + n_window_lines,/device,string(mean_dc)
wait,0.01
plots,  square_region_x+sample,  - (square_region_y+line) + n_window_lines, /cont,/device,color=0
xyouts,middle_region_x+sample, -( middle_region_y+line ) + n_window_lines,/device,string(mean_dc),color=0


endfor

endfor

end
