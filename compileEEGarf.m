function compileEEGarf(sn)
% This function loads in the EEGLAB file that contains the artifact
% rejection indices, and adds them to the segmented eeg file.
%
% sn = subject number
tic % start timing
%% directory information
dRoot = ['where_to_find_data']; % where to find data files
eegFN = '_EEG_SEG_JJF_EB_18_2.mat'; % name of data file (minus subject number)

% specify full name of segmented eeg file, and load
fName = [dRoot,num2str(sn),eegFN]; load(fName);

%load the EEGLab arf file
EEG = pop_loadset('filename',[num2str(sn),'_ArtRejectIndex.set'],'filepath',dRoot);
EEG = eeg_checkset( EEG );

% grab the relevant indices from the EEGLab arf file
arf1 = EEG.reject(:).rejkurt;
arf2 = EEG.reject(:).rejconst;
arf3 = EEG.reject(:).rejthresh;
arf4 = EEG.reject(:).rejjp;
arf5 = EEG.reject(:).rejfreq;
arf_manual = EEG.reject(:).rejmanual;

% check that we save our artifact rejection
if isempty(arf_manual)
    fprintf('No manual artifact rejection detected. Did you remember to save the dataset?')
end

% create an index of good and bad trials after manual artifact rejection
for t =  1:erp.trial.nTrials
    erp.arf.artifactIndCleaned(t) = arf1(t) | arf2(t) | arf3(t) | arf4(t) | arf5(t) | arf_manual(t);
end

% calculate and report summary statistics of artifact rejection
erp.arf.proportion_arfs = sum(erp.arf.artifactIndCleaned) ./ length(erp.arf.artifactIndCleaned);
erp.arf.trials_remaining = length(erp.arf.artifactIndCleaned) - sum(erp.arf.artifactIndCleaned);
fprintf('\nProportion Arfs: %.2f \n',erp.arf.proportion_arfs);
fprintf('Trials Remaing: %d \n',erp.arf.trials_remaining);

% save file with the new artifact rejection information
save(fName,'erp');
clear erp
fprintf('\n File saved! \n');
toc % report elapsed time
