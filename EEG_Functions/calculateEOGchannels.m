function eeg = calculateEOGchannels(eeg)
% Calcuate HEOG and VEOG difference channels
% Joshua J. Foster, 8/9/2019

chanLabels = eeg.chanLabels; % grab channel labels from EEG struct
data = eeg.data; % grab data from EEG struct

% HEOG = left HEOG (LHEOG) - right HEOG (RHEOG)
leftHEOG_idx = ismember(chanLabels,'LHEOG'); 
rightHEOG_idx = ismember(chanLabels,'RHEOG'); 
HEOG = data(leftHEOG_idx,:)-data(rightHEOG_idx,:);

% VEOG = lower VEOG (BVEOG) - upper VEOG (TVEOG)
lowerVEOG_idx = ismember(chanLabels,'BVEOG');
upperVEOG_idx = ismember(chanLabels,'TVEOG'); 
VEOG = data(lowerVEOG_idx,:)-data(upperVEOG_idx,:); 

% append EOG channels to data
chanLabels =[chanLabels {'HEOG'},{'VEOG'}]; 
data = [data; HEOG; VEOG]; 
nChans = length(chanLabels); % recalculate nChans

% update eeg struct
eeg.chanLabels = chanLabels; 
eeg.data = data; 
eeg.nChans = nChans;