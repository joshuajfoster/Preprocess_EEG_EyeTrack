function step = art_step(rawTS,rateAcq,winStep,winSize,thresh)
% detect steps in time-series data. Finds the mean amplitude in the first
% and second halves of the windows, and calcuates the difference. Good for 
% detecting or sudden changes in voltage (e.g. saccades).
%
% Inputs:
% rawTS: raw time-series
% rateAcq: acquisition rate (e.g., 2 ms for 500 Hz)
% winStep: size of step between windows (ms)
% winSize: size of test window (ms)
% thresh: max acceptable step size
%
% Outputs:
% step: vector with 1s in the windows where the p2p exceeded threshold
%
% Note: uses KA's edits to accept single trial data rather than the full
% dataset (this is much faster).

winSize = round(winSize/rateAcq); % size of test window, samples
winStep = round(winStep/rateAcq); % size of step, samples

wInd = 1; step = zeros(1,size(rawTS,2));
while 1
    % determine portion of rawTS to test
    wEnd = wInd + winSize; 
    midPoint = round(mean([wInd wEnd]));
    window = wInd:wEnd;
    
    preAmp = mean(rawTS(wInd:midPoint)); % mean amplitude prior to midpoint
    postAmp = mean(rawTS(midPoint:wEnd)); % mean amplitude after midpoint
    
    stepAmp = abs(postAmp-preAmp); % peak to peak amplitude
    
    % mark as bad if stepAmp exceeds threshold
    if stepAmp > thresh
        step(window) = 1; 
    end
    
    % move to next window
    wInd = wInd + winStep;
    
    if wInd + winSize > length(rawTS)
        break
    end
end