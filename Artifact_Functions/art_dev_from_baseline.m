function bad_section = art_dev_from_baseline(rawTS,thresh)
% Detect whether any point in the trial deviates from the baseline by more
% than some amount.
%
% Inputs:
% rawTS: raw time-series (must be baselined!!)
% thresh: max acceptable peak-to-peak amplitude
%
% Outputs:
% jump: vector with 1s in the windows where the threshold was exceeded
%
% note: currently not in use

% preallocate bad section
bad_section = zeros(size(rawTS));

% absolute value of rawTS
rawTS_abs = abs(rawTS);

% mark samples in which threshold was exceeded
bad_section(rawTS_abs > thresh) = 1;
