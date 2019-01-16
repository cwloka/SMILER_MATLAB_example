% Function to apply randomized point noise to an image; note that this
% noise is always in the form of either zeroing or saturating pixels, and
% is split evenly between the two.
% Author: Calden Wloka
% * Function Syntax:
% outimg = pointnoise(img, pixprop, noisetype)
% **** Input ****
% * img = an image matrix; can be single channel or multi-channel, but
% assume it is in double format (min 0, max 1)
% * pixprop = a value between 0 and 1 which specifies the proportion of
% pixels which are affected by the point noise. Note that this proportion
% is based on the number of pixels, not the number of channels; if a
% multi-channel image is affected by point-noise, the subset of channels
% which are affected is randomly determined.
% **** Output ****
% * outimg = an image matrix consisting of the content of img degraded by
% the noise function
function outimg = pointnoise(img, pixprop)

% get the image dimensions
[h, w, ch] = size(img);

numpix = h*w; % the number of pixel locations

% get the number of pixels which should have noise applied to them
numnoise = round(numpix*pixprop); 

% generate a pseudorandom permutation of the pixel indices and take enough
% to fulfill the noise quota
idxs = randperm(numpix);
idxs = idxs(1:numnoise);

% now check if we need to take into account channels
if(ch == 3)
    chset = cell(7,1); % there are seven options for which subset of channels to affect
    
    % calculate the proportion of each channel subset into which the noise
    % pixels will fall
    numinchan = rand(7);
    numinchan = numinchan/sum(numinchan);
    
    startidx = 1;
    for i = 1:7
        if(i < 7)
            endidx = startidx + floor(numinchan(i)*numnoise);
        else
            endidx = numnoise;
        end
        chset{i} = idxs(startidx:endidx);
        startidx = endidx;
    end
elseif(ch ~= 1)
    error('The image must have 1 or 3 channels.');
end

if(ch == 1)
    outimg = img;
    numblack = floor(numnoise/2);
    outimg(idxs(1:numblack)) = 0;
    outimg(idxs(numblack+1:end)) = 1;
else
    % split the image into three channel images to modify them as
    % needed
    rchan = img(:,:,1);
    gchan = img(:,:,2);
    bchan = img(:,:,3);

    % seven options for channel modifications include:
    % 1 - red only
    % 2 - green only
    % 3 - blue only
    % 4 - red and green
    % 5 - red and blue
    % 6 - green and blue
    % 7 - all three
    for i = 1:7
        numblack = floor(numel(chset{i})/2);
        if(i == 1 || i == 4 || i == 5 || i == 7)
            % the red channel should be modified
            rchan(chset{i}(1:numblack)) = 0;
            rchan(chset{i}(numblack+1:end)) = 1;
        end
        if(i == 2 || i == 4 || i == 6 || i == 7)
            % the green channel should be modified
            gchan(chset{i}(1:numblack)) = 0;
            gchan(chset{i}(numblack+1:end)) = 1;
        end
        if(i == 3 || i == 5 || i == 6 || i == 7)
            % the blue channel should be modified
            bchan(chset{i}(1:numblack)) = 0;
            bchan(chset{i}(numblack+1:end)) = 1;
        end
    end

    outimg = zeros(size(img));
    outimg(:,:,1) = rchan;
    outimg(:,:,2) = gchan;
    outimg(:,:,3) = bchan;
end