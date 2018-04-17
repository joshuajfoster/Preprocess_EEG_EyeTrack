function step = art_2D_step(xVal,yVal,rateAcq,winStep,winSize,thresh)
% detect steps in time-series data. Finds the mean x-y coordinates in the first
% and second halves of the windows, and calcuates the difference. Good for 
% detecting or sudden changes in voltage (e.g. saccades).
%
% Inputs:
% xVal: x gaze coordinate
% yVal: y gaze coordinate
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

% throw an error if the size of xVal and yVal don't match
if size(xVal) ~= size(yVal)
   error('the dimension of the x and y vectors do not match...'); 
end

winSize = round(winSize/rateAcq); % size of test window, samples
winStep = round(winStep/rateAcq); % size of step, samples

wInd = 1; step = zeros(1,size(xVal,2));
while 1
    % determine portion of rawTS to test
    wEnd = wInd + winSize; 
    midPoint = round(mean([wInd wEnd]));
    window = wInd:wEnd;
        
    preCoord = [mean(xVal(wInd:midPoint)) mean(yVal(wInd:midPoint))];
    postCoord = [mean(xVal(midPoint:wEnd)) mean(yVal(midPoint:wEnd))];
    
    stepDist = norm(postCoord-preCoord); % size of movement from pre-window to post-window
        
    % mark as bad if stepDist exceeds threshold
    if stepDist > thresh
        step(window) = 1; 
    end
    
    % move to next window
    wInd = wInd + winStep;
    
    if wInd + winSize > length(xVal)
        break
    end
end
