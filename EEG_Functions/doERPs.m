function erp = doERPs(sub,erp,settings)
% create ERPs (segmentation, artifact rejection etc.)

fprintf('Processing ERPs \n')

% Segment data (including buffer time for time-freq analyses)
erp.trial = segment(erp,settings.seg.codes,settings.seg.preTime,settings.seg.postTime);

% baseline correction
[erp.trial.baselined erp.trial.baselineCorrection] = doBaseline(erp.trial.data,erp.trial.times,settings.seg.baseStart,settings.seg.baseEnd);

% artifact Rejection: mark bad data
erp = runArtRejection(erp,settings);

% remove unwanted data for ERP file
erp.trial = rmfield(erp.trial,'data'); % just keep the baseline corrected data
erp = rmfield(erp,'data'); % ditch unsegmented data (saved in unsegmented data file)
erp = rmfield(erp,'dropped_data'); % ditch unsegmented data for dropped electrodes (saved in unsegmented data file)
erp = rmfield(erp,'eventTimes'); % only relevant to unsegmented data
erp = rmfield(erp,'event'); % only relevant to unsegmented data
erp = rmfield(erp,'eventCodes'); % only relevant to unsegmented data

% save data file
fprintf('saving ERP file.. \n')
erpName = [settings.dir.processed_data_path,num2str(sub),'_EEG_SEG_',settings.dir.raw_filename,'.mat'];
erp.settings = settings; % add settings to erp struct before saving
save(erpName,'erp'); % note: faster to load file that isn't v7.3 but there is a size limitation
