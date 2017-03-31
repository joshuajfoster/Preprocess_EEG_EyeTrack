function eeg = Rereference(eeg,settings)
%Rereference to the average of the Left and Right mastoids
% Created by David W. Sutterer 12/4/2015
% Checked by Kirsten C.S. Adam on: 12/14/2015
% Checked by Joshua J. Foster on: 1/26/2016
% Based on Introduction to the Event-Related Potential Technique pg. 107-108

chanLabels = eeg.chanLabels;          % grab channel labels from eeg struct
notIncluded = settings.droppedElectrodes;  % grab the list of electrodes to drop

leftMastoid = ismember(chanLabels,'TP9')';               % TP9 is the left mastoid, TP10 is the right mastoid (and the online referece)
l = length(notIncluded); notIncluded{l+1} = 'TP9';       % add the offline reference (TP9) to the notIncluded vector
notIncludedInd = ismember(chanLabels,notIncluded)';   
chanLabels_reref = chanLabels(~notIncludedInd);     
skipReRef = {'HEOG','VEOG','StimTrak'};                  % eye channels and stim track are last and have their own references so don't rereference them
Chan2ReRef = sum(~ismember(chanLabels_reref,skipReRef)); % drop TP9 from our reReferenceSet and don't include eye channels and stim
tmpreRef = eeg.data(~notIncludedInd,:); % a    
mastoidValue = eeg.data(leftMastoid,:) ./ 2; % r/2
for chan = 1:Chan2ReRef %NOTE This for loop is set up for HEOG,VEOG, and Stimtrack (which have their own face reference) as the last 3 channels. If you change the order make sure you restructure the script to skip rereferencing those channels!
    tmpreRef(chan,:) = tmpreRef(chan,:) - mastoidValue; % a - (r/2)
end

%save chan labels for moving forward
eeg.data = tmpreRef;
eeg.chanLabels = chanLabels_reref;
eeg.nChans = sum(~notIncludedInd);
eeg.nArfChans = sum(~notIncludedInd)-1; % don't count stim trak as a chan to be looked at for arfs
eeg.chanCoordinates = eeg.chanCoordinates(~notIncludedInd);   % JJF: update this....
