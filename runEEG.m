function runEEG(sn)
%% JJF's wrapper to run to read in and save EEG file, and run ERP preprocessing
%
% Inputs: 
% sn: subject number
% all details to change are specified in the function EEG_Settings

%%
dbstop if error
root = pwd; eRoot = [root,'\EEG_Functions\']; addpath(eRoot) % add folder with eeg functions
arfRoot = [root,'\Artifact_Functions\']; addpath(arfRoot); % add folder with artifact detection functions

%% load in the preprocessing settings.
%Everything that you'd want to change is specifed in the EEG_Settings script.
settings = EEG_Settings;

%% Print subject number
fprintf('Subject:\t%d\n',sn)

%% preprocess EEG data and save file (no segmentation)
tic
eeg = doEEG(sn,settings.dir.raw_data_path,settings.dir.raw_filename,settings);
fprintf('saving EEG file.. \n')
eegName = [settings.dir.processed_data_path,num2str(sn),'_EEG_',settings.dir.raw_filename,'.mat'];
eeg.droppedElectrodes = settings.droppedElectrodes; % only save dropped electrodes, other settings apply to segmentation
save(eegName,'eeg');% note: faster to load file that isn't v7.3 but there is a size limitation
toc % report time to process EEG data

%% do ERPs
tic
erp = eeg; clear eeg; % pass eeg data to erp structure
erp = doERPs(erp,settings); % doERP pipeline
fprintf('saving ERP file.. \n')
erpName = [settings.dir.processed_data_path,num2str(sn),'_EEG_SEG_',settings.dir.raw_filename,'.mat'];
erp.settings = settings; % add settings to erp struct before saving
save(erpName,'erp'); % note: faster to load file that isn't v7.3 but there is a size limitation
toc % report time to doERPs
clear erp
