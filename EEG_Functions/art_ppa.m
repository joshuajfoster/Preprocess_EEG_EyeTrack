function jump = art_ppa(rawTS,rateAcq,winStep,winSize,thresh)
% Detect whether peak-to-peak amplitude exceeds thresh.
%
% Inputs:
% rawTS: raw time-series
% rateAcq: acquisition rate (e.g., 2 ms for 500 Hz)
% winStep:size of step between windows (ms)
% winSize: size of test window (ms)
% thresh: max acceptable peak-to-peak amplitude
%
% Outputs:
% jump: vector with 1s in the windows where the p2p exceeded threshold

winSize = round(winSize/rateAcq); % size of test window, samples
winStep = round(winStep/rateAcq); % size of step, samples

wInd = 1; jump = zeros(size(rawTS));

while 1
    % determine portion of rawTS to test
    wEnd = wInd + winSize; 
    window = wInd:wEnd;
    
    % calculate p2p in window of interest
    minPeak = min(rawTS(window)); % minimum peak amplitude
    maxPeak = max(rawTS(window)); % maximum peak amplitude
    p2p = abs(maxPeak-minPeak); % peak to peak amplitude
    
    % mark bad segment if p2p exceeds threshold
    if p2p > thresh
        jump(window) = 1;
    end
    
    % move to next window
    wInd = wInd + winStep;
    
    if wInd + winSize > length(rawTS)
        break
    end
end