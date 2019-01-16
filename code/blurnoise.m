% Function to apply blurring noise to an image
% Author: Calden Wloka
% * Function Syntax:
% outimg = blurnoise(img, sigma)
% **** Input ****
% * img = an image matrix; can be single channel or multi-channel
% * sigma = the standard deviation of the blurring kernel specified as a
% proportion of the major axis of the image (between 0 and 1). The kernel
% size will always be set to three times this value.
% **** Output ****
% * outimg = an image matrix consisting of the content of img degraded by
% the noise function
function outimg = blurnoise(img, sigma)

% get the image dimensions
[h, w, ~] = size(img);

sigma = round(sigma*max(h,w));

kern = fspecial('gaussian', 3*sigma, sigma);

outimg = imfilter(img, kern, 'replicate');