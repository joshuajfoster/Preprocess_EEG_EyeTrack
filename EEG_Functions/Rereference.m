function eeg = Rereference(eeg,settings)
% Rereference to the average of the left and right mastoids
% Based on Luck (2005). Introduction to the Event-Related Potential Technique pg. 107-108
% Subtantial rewrite by Joshua Foster, 8/9/2019

chanLabels = eeg.chanLabels;          % grab channel labels from eeg struct
data = eeg.data;                      % grab matrix of EEG data

% index left mastoid
leftMastoidIdx = ismember(chanLabels,'TP9'); % TP9 is the left mastoid to be re-referenced to (T910 is the right mastoid - the online reference)

% grab left mastoid data
leftMastoidData = data(leftMastoidIdx,:); 

% remove left mastoid from data matrix and chanLabels
chanLabels = chanLabels(~leftMastoidIdx); 
data = data(~leftMastoidIdx,:); % (a, in Luck's formula)
nChans = size(data,1); % get the size of the matrix with left mastoid removed

% index channels to rereference (all but the stimtrak)
chans2rerefIdx = ~ismember(chanLabels,'StimTrak'); 

leftMastoidValue = leftMastoidData./2; % (r/2, in Luck's formula)

dataRerefed = nan(size(data)); % preallocate
% loop through each channel, reference all but the stim trak
for c = 1:nChans
    if chans2rerefIdx(c) == 1
        dataRerefed(c,:) = data(c,:) - leftMastoidValue; % a - (r/2);
    else 
        dataRerefed(c,:) = data(c,:);
    end
end

eeg.data = dataRerefed;
eeg.chanLabels = chanLabels;
eeg.nChans = nChans;