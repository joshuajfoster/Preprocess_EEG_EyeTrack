function drift = art_drift(rawTS,rateAcq,thresh)
% check for drifts across trial. Take an absolute voltage difference for the 
% first quarter of the segment versus the last quarter.
% 
% Inputs:
% rawTS: raw time-series
% rateAcq: acquisition rate (e.g., 2 ms for 500 Hz)
% thresh: max acceptable peak-to-peak amplitude
%
% Outputs:
% drift: vector with 1s if the drift threshold is violated
% 
% Written by KA

drift = zeros(size(rawTS));

nSamples = length(rawTS);
breaks = round(linspace(1,nSamples,5)); % split epoch into quarters

firstQuarter = mean(rawTS(breaks(1):breaks(2)));
lastQuarter = mean(rawTS(breaks(4):breaks(5)));

if abs(firstQuarter-lastQuarter)>thresh
    drift = ones(size(rawTS));
end
