pro process_tirs_image

;
; Read in the test image which is a PGM file with maximum value of 64
; integer.
; 

read_ppm,'hot_64_E.pgm', image

;
; Add a 25 count offset to the image so we can see the non-zero regions
;

image = image+25

window,0


tvscl, image,/ord

;
; Get the dimensions of the image
;
samples = (size(image,/dimensions))[0]
lines = (size(image,/dimensions))[1]


;
; Create a buffered image (integer - two bytes) that will hold a padded version
; of the original image.
;
buffered_image = intarr( samples*3, lines*3)

window, 1

tvscl, buffered_image,/ord

;
; Insert the input file into a larger array such that the input image 
; above is buffered by the size of the image in each direction.
; For example, if the input image is 512x512, then the resulting buffer
; image will be 3*512 in each direction or 1536x1536.
;
; Insert original image into the buffered image array
;

buffered_image[ samples, lines ] = image

tvscl, rebin(buffered_image,samples,lines),/ord

;
; Make a blank array of the same dimension in order deposit the 
; per pixel answer
;
answer_image = intarr( samples*3, lines*3)

;
; The following is a test to see if we are looping properly to deposit
; the correct values into the answer image 
;

;
; Specify the indices for both samples and lines 
;

sample_values = indgen(samples)
line_values = indgen(lines)

;
; Create two dimensional indices to access the data from source image
; and the destination image
;

;
; Define the indices from the source
;
source_sample_indices = replicate(1,lines)##sample_values
source_line_indices = replicate(1,samples)#line_values

;
; Define the indices for the destination array such that the
; source image is deposited in the middle of the destination
; array and a buffer area is maintained around the source
; image copy.
;
destination_sample_indices = source_sample_indices + samples
destination_line_indices = source_line_indices + lines

;
; Deposit a copy of the source image into the middle of the 
; buffered array.
;
answer_image[ destination_sample_indices, destination_line_indices ] = $
   image 

window,2
tvscl, rebin(answer_image,samples,lines),/ord

print, 'destination_sample_indices[0] = ',destination_sample_indices[0]
print, samples
print, 'destination_line_indices[0] = ',destination_line_indices[0]
print, lines

;stop 

for line_index = destination_line_indices[0,0], destination_line_indices[0,lines-1] do begin
;
; Need to modify this because the region of interest is too large
; Will probably have to do a region of interest and use NaNs to handle
; areas where data should not be defined.
;
;	offset_line_indices = destination_line_indices - $
;		(lines/4)+line_index
	offset_line_indices = [200,201,202,203,204] - $
		(lines/4)+line_index
	for sample_index = destination_sample_indices[0,0], $
	    destination_sample_indices[samples-1,0] do begin

;
; Test to simply add 100 to the values at the location of interest
;
;	    answer_image[ sample_index, line_index ] = $
;		 answer_image[ sample_index, line_index ] + 100


;
; Figure out the extents of the area to be averaged which in this 
; case will be to the upper left of the location of interest
;
; The following did not quite work because the region of interest was
; simply too big.  Will try one that is only 3x3
;	    offset_sample_indices = destination_sample_indices - $
;		(samples/4)+sample_index
;	    answer_image[ sample_index, line_index ] = $
;		answer_image[ sample_index, line_index ] + $
;		total( buffered_image[ offset_sample_indices, $
;			offset_line_indices ] )

	    offset_sample_indices = [200,201,202,203,204]- $
		(samples/4)+sample_index
	    answer_image[ sample_index, line_index ] = $
		answer_image[ sample_index, line_index ] + $
		total( buffered_image[ offset_sample_indices, $
			offset_line_indices ] )



	endfor
  print, "sample_index = ", sample_index
  print, "line_index = ", line_index
endfor

window,3
tvscl, rebin(answer_image,samples,lines),/ord

;
; Next we want to go through each pixel and average the entire
; sample x lines region and add that value to the current location.
;

; 
; Create samples_delta band and a lines_delta band of the same size as
; the original image.  
;
; These two bands will hold the sample and line offset within the original
; image that will be used to add a contibuting signal to the pixel at
; a given location.
;
; We are using this structure in the event that the distance from the 
; contributing pixel changes as a function of pixel location.  If it 
; does not change, we will still be able to handle this simpler condition
; using this data structure.
;

;
; We will also create a weighting band that will apply a weighting 
; function on the area specified by the samples_delta and line_delta
; location (center of contributing area).  This will start out as an
; area of all 1's and can modulated with future tests.
;
 
end
