function eeg = dropElectrodes(eeg,settings)
% this channels removes unwanted channels specified in EEG_settings.m (see settings.droppedElectrodes)
% Joshua J. Foster, 8/9/2019

notIncluded = settings.droppedElectrodes; % grab the list of electrodes to drop
toIncludeIdx = ~ismember(eeg.chanLabels,notIncluded); % index the channels to be included

% save dropped channels to different struct (must be done before they are
% removed from eeg.data)
eeg.dropped_data = eeg.data(~toIncludeIdx,:); 
eeg.dropped_chanLabels = eeg.chanLabels(~toIncludeIdx); 

% remove unwanted channels
eeg.data = eeg.data(toIncludeIdx,:); 
eeg.chanLabels = eeg.chanLabels(toIncludeIdx);

% update nChans
eeg.nChans = length(eeg.chanLabels); 