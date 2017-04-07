function blocking = art_block(rawTS,rateAcq,winStep,winSize,x,y)
% implements X-within-Y-of-peak rejection procedure as described in 
% "An Introduction to the Event Related Potential Technique" by Steve Luck (pp. 168).
%
% Inputs:
% rawTS: raw time-series
% rateAcq: acquisition rate (e.g., 2 ms for 500 Hz)
% winStep:size of step between windows (ms)
% winSize: size of test window (ms)
% x: # time period for which amplitude must be within Y of peak, ms
% y: threshold - how close a value must be wto the peak to be counted, microvolts
%
% Outputs:
% jump: vector with 1s in the windows where the p2p exceeded threshold

x =  x./rateAcq; % # of points that must within Y of peak (convert to samples)

winSize = round(winSize/rateAcq); % size of test window, samples
winStep = round(winStep/rateAcq); % size of step between windows, samples

wInd = 1; blocking = zeros(size(rawTS));

while 1
    % determine portion of raw TS to test.
    wEnd = wInd +winSize;
    window = wInd:wEnd;
    
    % calculate the min and max for the window
    maxPeak = max(rawTS(window));
    minPeak = min(rawTS(window));
    
    diffFromMax = maxPeak - rawTS(window); % always +ve
    diffFromMin = rawTS(window) - minPeak; % always +ve
    
    xwithinMax = diffFromMax < y;
    xwithinMin = diffFromMin < y;
    
    % mark the window as blocking if more than x points y within the min or
    % max
    if sum(xwithinMax) > x || sum(xwithinMin) > x
        blocking(window) = 1; % changed from 1 to chan so that we can visualize which chans were counted as blocking! 
    end

    wInd = wInd + winStep;
    
    if wInd + winSize > length(rawTS)
        break
    end   
end