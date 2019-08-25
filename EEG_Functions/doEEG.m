function eeg = doEEG(sub,data_path,filename,settings)
% Read in EEG data, rereference, organize condition codes.
%
% Inputs:
% sub: subject #
% data_path: directory of EEG data
% filename: name of file to load (minus subject number)
% settings: settings struct with preprocessing info, created by
% EEG_Settings function

clear eeg

% read in data
data_file = [num2str(sub),'_',filename,'.vhdr'];
eeg = load_BrainProducts_file(data_path,data_file);
eeg.data_file = data_file;

% Re-reference and/or drop unwanted electrodes
eeg = Rereference(eeg,settings);

% Remove spaces and letters from the BrainProducts codes
eeg = changeCondCodes(eeg); 
