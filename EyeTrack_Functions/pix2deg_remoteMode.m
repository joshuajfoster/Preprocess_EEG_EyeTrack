function [degHfromFix degVfromFix] = pix2deg_remoteMode(pixH,pixV,head2camDist,cam2screenDist,pixelsH,pixelsV,pxSize)
% covert pixel coordinates to degrees of visual angle from the center of
% the monitor
%
% Inputs:
% pixH: horizontal gaze coordinates in pixels(can be a matrix of values)
% pixV: vertical gaze coordinate in pixels (can be a matrix of values)
% head2camDist: head to eye tracker distance (should be the same dimensions as pixH and pixV, will throw error otherwise)
% cam2screenDist: distance of eye tracker from monitor
% pixelsH: width of monitor in pixels
% pixelsV: height of monitor in pixels
% pxSize: the size of pixels (in cm)
% viewDist: viewing distance (in cm)

% if any of the input matrices are not the same size, throw an error
if size(head2camDist) ~= size(pixH) | size(head2camDist) ~= size(pixV) | size(pixH) ~= size(pixV)
    error('One of these input matrices is not like the others... in size')
end

% add these distance to get viewing distance
viewDist = head2camDist + cam2screenDist;

% calculate pixels from the middle of the screen
pixHfromFix = pixH-(pixelsH/2); 
pixVfromFix = pixV-(pixelsV/2);

% convert these values to cm to calculate degrees of visual angle
cmHfromFix = pixHfromFix.*pxSize;
cmVfromFix = pixVfromFix.*pxSize;

% calculate degrees of visual angle from fixation
degHfromFix = atand(cmHfromFix./viewDist);
degVfromFix = atand(cmVfromFix./viewDist);

end

