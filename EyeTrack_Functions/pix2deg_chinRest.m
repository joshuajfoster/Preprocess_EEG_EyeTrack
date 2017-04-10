function [degHfromFix degVfromFix] = pix2deg_chinRest(pixH,pixV,pixelsH,pixelsV,pxSize,viewDist)
% covert pixel coordinates to degrees of visual angle from the center of
% the monitor
%
% Inputs:
% pixH: horizontal gaze coordinates in pixels(can be a matrix of values)
% pixV: vertical gaze coordinate in pixels (can be a matrix of values)
% pixelsH: width of monitor in pixels
% pixelsV: height of monitor in pixels
% pxSize: the size of pixels (in cm)
% viewDist: viewing distance (in cm)

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

