function runEEG(subs)
%% JJF's wrapper to run to read in and save EEG file, and run ERP preprocessing
dbstop if error
root = pwd; eRoot = [root,'\EEG_Functions\']; addpath(eRoot)

%% load in the preprocessing settings. 
%Everything that you'd want to change is specifed in the EEG_Settings script. 
settings = EEG_Settings;

%% Directory info
filename = ['JJF_EB_16_4']; % name of data file (minus subject number)
data_path = ['F:\UC Raw Data\JJF_EB_16_4\EEG\']; % where to find EEG data
dRoot = ['F:\UC Artifact Rejection\JJF_EB_16_4\Preprocessed_Data\']; % where to save preprocessed files

%% Loop through subjects
for i =1:length(subs)
    %% Print subject number
    sn = subs(i);
    fprintf('Subject:\t%d\n',sn)
        
    %% preprocess EEG data and save file (no segmentation)
    tic
    eeg = doEEG(subs(i),data_path,filename,settings);
    fprintf('saving EEG file.. \n')
    eegName = [dRoot,num2str(subs(i)),'_EEG_',filename,'.mat'];
    eeg.droppedElectrodes = settings.droppedElectrodes; % only save dropped electrodes, other settings apply to segmentation
    save(eegName,'eeg');% note: faster to load file that isn't v7.3 but there is a size limitation
    toc % report time to process EEG data

    %% do ERPs
    tic
    erp = eeg; clear eeg; % pass eeg data to erp structure
    erp = doERPs(erp,settings); % doERP pipeline
    fprintf('saving ERP file.. \n')
    erpName = [dRoot,num2str(subs(i)),'_EEG_SEG_',filename,'.mat'];
    erp.settings = settings; % add settings to erp struct before saving
    save(erpName,'erp'); % note: faster to load file that isn't v7.3 but there is a size limitation
    toc % report time to doERPs
    clear erp
   
end
cd(root)
