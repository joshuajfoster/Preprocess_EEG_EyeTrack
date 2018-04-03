function [baselined baseCorrection] = doBaseline(data,times,baselineStart,baselineEnd)
% Baseline segmented eye tracking data
%
% Inputs:
% data: matrix of segmented data to baseline (trials x electrode)
% times: the sample timepoints for the segmented data (e.g., -500, -498, -496...., 1496, 1498, 1450)
% baselineStart: start of baseline in ms (e.g., -500 ms)
% baselineEnd: end of baseline period in ms (e.g., 0 ms)
% 
% Output: 
% baselined: the baselined data
% baseCorrection: the baseline values that were subtracted for each trial
% so that the baseline correction can be easily undone.
%
% Written by JJF

fprintf('baselining data... \n')

% get dimensions from data
nTrials = size(data,1); 
nSamps = size(data,2);

% create baseline index
bInd = ismember(times,baselineStart:baselineEnd); 

% preallocate array for baselined data
baselined = nan(size(data));
baseCorrection = nan(nTrials,1);

for t = 1:nTrials
        dat = squeeze(data(t,:));         % grab the raw time-series
        base = mean(dat(bInd));           % calcuate mean during baseline period
        baselined(t,:) = dat-base;   % do baseline subtraction
        baseCorrection(t) = base;    % save how much the data was shifted by (for easy undoing of baseline correction)
end

