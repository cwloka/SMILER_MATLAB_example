% Function to score a saliency map based on the ratio between the maximally
% salient target pixel and the maximally salient distractor pixel
% Author: Calden Wloka
% * Function Syntax:
% ratio = maxrat(salmap, targmap, dil, distmap)
% **** Input ****
% * salmap = a saliency map
% * targmap = a binary map denoting target pixels
% * dil = an optional dilation parameter; if not provided, no dilation is
% performed.
% * distmap = a binary map denoting distractor pixels. If none is provided
% all non-target pixels will be assumed to be distractor pixels
% **** Output ****
% * outimg = an image matrix consisting of the content of img degraded by
% the noise function
function ratio = maxrat(salmap, targmap, dil, distmap)

% dil parameter not specified, so set it to 0
if(nargin < 3)
    dil = 0; % do not perform a dilation of the target and distractor masks
end

% if we've specified a dilation, perform it
if(dil > 0)
    dilkern = strel('disk', dil); % create a dilation structure element in disk form using default approximation values for speed
    targmap = imdilate(targmap, dilkern);
    if(nargin < 4)
        % a distractor map was not provided, so invert the target map (post
        % dilation)
        distmap = ~targmap;
    else
        % a distractor map was provided, so dilate that
        distmap = imdilate(distmap, dilkern);
    end
else
    if(nargin < 4)
        distmap = ~targmap;
    end
end

% we need to make sure the maps are logical arrays and not images
if(~islogical(targmap))
    targmap = targmap > 0;
end
if(~islogical(distmap))
    distmap = distmap > 0;
end

ratio = max(salmap(targmap))/max(salmap(distmap));