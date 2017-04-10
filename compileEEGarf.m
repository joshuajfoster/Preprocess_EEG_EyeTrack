function compileEEGarf(sn)
% This function loads in the EEGLAB file that contains the artifact
% rejection indices, and adds them to the segmented eeg file.
%
% sn = subject number
tic % start timing
%% directory information
dRoot = ['F:\UC Artifact Rejection\JJF_EB_16_4\Preprocessed_Data\']; % where to find data files
eegFN = '_EEG_SEG_JJF_EB_16_4.mat'; % name of data file (minus subject number)

% specify full name of segmented eeg file, and load
fName = [dRoot,num2str(sn),eegFN]; load(fName);

%load the EEGLab arf file
EEG = pop_loadset('filename',[num2str(sn),'_ArtRejectIndex.set'],'filepath',dRoot);
EEG = eeg_checkset( EEG );

% grab the relevant indices from the EEGLab arf file
erp.arf.m_blockingNoiseDropout = EEG.reject(:).rejkurt;
erp.arf.m_drift = EEG.reject(:).rejconst;
erp.arf.m_blink = EEG.reject(:).rejthresh;
erp.arf.m_saccade_eyetrack = EEG.reject(:).rejjp;
erp.arf.m_saccade_heog = EEG.reject(:).rejfreq;
erp.arf.manual = EEG.reject(:).rejmanual;

% check that we save our artifact rejection
if isempty(erp.arf.manual)
    fprintf('No manual artifact rejection detected. Did you remember to save the dataset?')
end

% create an index of good and bad trials after manual artifact rejection
for t =  1:erp.trial.nTrials
    erp.arf.artifactIndCleaned(t) = erp.arf.m_blockingNoiseDropout(t) | erp.arf.m_drift(t) | erp.arf.m_blink(t) | erp.arf.m_saccade_heog(t) | erp.arf.m_saccade_eyetrack(t) | erp.arf.manual(t);
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
