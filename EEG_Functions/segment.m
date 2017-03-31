function trial = segment(erp,codes,preTime,postTime)
% Segment data
%
% This function will segment data based on the event codes of interest
% (erp.codes)
%
% INPUTS:
% erp: this function uses general info from the erp struct (rateAcq, eventCodes, eventTimes, codes, nChans)
% codes: vector of port codes to time-lock segments to
% preTime:  the time (in ms) you want the segment to start (relative to time-locking event)
% postTime: the time (in ms) you want the segment to end (relative to time-locking event)
%
% OUTPUTS:
% trial.data: the segmented data
% trial.codes: the event codes for each segment
% trial.times: the sample times in segments (relative to time-locking event)
% trial.nTrials: # of trials
%
% Written by Joshua J. Foster, January 28, 2016.

fprintf('segmenting data... \n')

% Determine onset of each trial
trial.times = -preTime:erp.rateAcq:postTime;% the sample times in segments
preTimeSamp = preTime./erp.rateAcq;         % # of samples we need to go back from event code
postTimeSamp = postTime./erp.rateAcq;       % # of samples we need to go forward from event
tLength = preTimeSamp + postTimeSamp + 1;   % trial length in samples
codesInd = ismember(erp.eventCodes,codes);  % index where these codes of interest occured
nTrials = sum(codesInd);                    % calculate number of trials
trial.nTrials = nTrials;

% preallocate matrices
trial.data = nan(nTrials,erp.nChans,tLength);
trial.codes = nan(nTrials,1);

tCnt = 1;
% loop through all event codes
for ii = 1:length(erp.eventCodes);
    if codesInd(ii) % if a code of interest, grab the segment!
        
    % Determine start and stop of trial
    tStart = erp.eventTimes(ii)-preTimeSamp; % jjf: rename this??
    tEnd = erp.eventTimes(ii)+postTimeSamp;   %jjf: rename this??
    tWindow = tStart:tEnd;
    
    % get time-series data for segment
    rawTS = erp.data(:,tWindow);
    
    % save time-series data to data matrix
   trial.data(tCnt,1:erp.nChans,:) = rawTS;      % what should I call dMat?
    
    % grab trial lable....
    trial.codes(tCnt) = erp.eventCodes(ii);
    
    tCnt = tCnt + 1; % advance trial indexing counter

    end
end


