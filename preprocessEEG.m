function preprocessEEG(sn)
%% JJF's wrapper to run to read in and save EEG file, and run ERP preprocessing
%
% Inputs: 
% sn: subject number
% all details to change are specified in the function EEG_Settings

%% setup directories
root = pwd; 
addpath([root,'/EEG_Functions']) % add EEG_Functions
addpath([root,'/Artifact_Functions']); % add Artifact_Functions
addpath([root,'/Settings/']); % add Settings


%% load in the preprocessing settings.
%Everything that you'd want to change is specifed in the EEG_Settings script.
settings = Settings_EEG;

%% Print subject number
fprintf('Subject:\t%d\n',sn)

%% preprocess EEG data and save file (no segmentation)
tic
eeg = doEEG(sn,settings.dir.raw_data_path,settings.dir.raw_filename,settings);
toc % report time to process EEG data

%% do ERPs
tic
erp = eeg; clear eeg; % pass eeg data to erp structure
doERPs(sn,erp,settings); % doERP pipeline
toc % report time to doERPs

