function eeg = fixTiming(eeg,timeOffset)
% For timing critical experiments, this function allows you to shift the
% exact recorded event times by a constant amount if there was a small,
% constant difference between event markers and change in the stim trak
% data. 
%
% Written by Joshua J. Foster, August 25, 2019

fprintf('applying timing correction... \n')

correction = timeOffset/eeg.rateAcq; % convert milliseconds into samples
eeg.eventTimesCorrected = eeg.eventTimes + correction; % apply correction

