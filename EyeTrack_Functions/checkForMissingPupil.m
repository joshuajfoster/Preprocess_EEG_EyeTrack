function [mpx mpy] = checkForMissingPupil(xgaze,ygaze)
% check for gaze data (in pixels) for missing pupil data. Missing pupil
% operationalized as values > 10,000.
% 
% Inputs:
% xgaze: segment of xgaze data (in pixels)
% ygaze: segment of ygaze data (in pixels)
%
% Outputs:
% mpx: vector with 1s specifiying samples with missing pupil, 0s elsewhere
% mpy: same for ygaze data

mpx = zeros(size(xgaze));
mpy = zeros(size(ygaze));

pmx(xgaze > 10000) = 1;
pmy(ygaze > 10000) = 1;

end

