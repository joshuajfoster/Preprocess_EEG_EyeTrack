function eeg = doEEG(sub,data_path,filename,settings)
% Read in EEG data, rereference, create EOG difference channels, drop unwanted electrodes, organize condition codes.
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

% Create EOG difference channels
eeg = calculateEOGchannels(eeg); 

% Drop unwanted channels (note: done after HEOG difference so you can drop
% the individual EOG chanels if you don't want them)
eeg = dropElectrodes(eeg,settings); 
 
% Remove spaces and letters from the BrainProducts codes
eeg = changeCondCodes(eeg); 

% save data file
if settings.saveContinuousEEG == 1
    fprintf('saving EEG file.. \n')
    eegName = [settings.dir.processed_data_path,num2str(sub),'_EEG_',settings.dir.raw_filename,'.mat'];
    save(eegName,'eeg');% note: faster to load file that isn't v7.3 but there is a size limitation
else
   fprintf('selected not to save unsegmented EEG file \n')
end