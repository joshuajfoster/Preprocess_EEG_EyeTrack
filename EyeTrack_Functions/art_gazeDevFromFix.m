function bad_section = art_gazeDevFromFix(xVal_bl,yVal_bl,thresh)
% Detect whether any point in the trial deviates from the baseline by more
% than some amount.
%
% Inputs:
% xVal_bl: baselined x-coordinates
% yVal_bl: baselined y-coordinate
% thresh: max acceptable distance from fixation point
%
% Outputs:
% bad_section: marks portion where gaze was exceeded the acceptable
% distance from fixation

% preallocate bad section
bad_section = zeros(size(xVal_bl));
dist_from_fix = nan(size(xVal_bl));
nTimes = length(xVal_bl);

for t = 1:nTimes
   dist_from_fix(t) = norm([xVal_bl(t),yVal_bl(t)]); 
end

bad_section(dist_from_fix > thresh) = 1;