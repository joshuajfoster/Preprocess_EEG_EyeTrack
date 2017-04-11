function settings = EEG_Settings
% This function specifies the settings that the preprocessing functions call on.

fprintf('loading settings... \n')

settings.droppedElectrodes = {'Fp1','Fp2'}; % electrodes to remove

%% directory info
settings.dir.raw_filename = ['JJF_EB_16_7']; % name of data file (minus subject number)
settings.dir.raw_data_path = ['F:\UC Raw Data\JJF_EB_16_7\EEG\']; % where to find EEG data
settings.dir.processed_data_path = ['F:\UC Artifact Rejection\JJF_EB_16_4\Preprocessed_Data\']; % where to save preprocessed files

%% segmentation settings

settings.seg.codes = [51]; % vector of all event codes of interest.

% Timing for artifact rejection (times should be ABSOLUTE VALUES) 
settings.seg.arfPreTime = 300; % msec prior to timelock
settings.seg.arfPostTime = 1300; % msec post timelock (600 ms after array onset)

% Timing stuff for building waveforms (times should be absolute values) 
settings.seg.preTime = settings.seg.arfPreTime+500; % msecs prior to timelock built in extra 500ms for time freq analyses
settings.seg.postTime = settings.seg.arfPostTime+500; % msecs post timelock

% Window for baselining (time should be NEGATIVE IF PRE-=TIMELOCKING
settings.seg.baseStart = -300;  %%% if using the whole time period, just use -settings.preTime
settings.seg.baseEnd = 0; 

%% artifact rejection settings

% Noise threshold for artifact rejection
settings.arf.noiseThr = 150; % microvolts
settings.arf.noiseWin = 15; % ms (short so the peak-to-peak algorithm is selective for high-freq noise)
settings.arf.noiseStep = 50; % ms no need to check more than every 50 ms for noise

% Threshold for drift
settings.arf.driftThr = 50; %microvolts

% Step function settings for channel drop out (main cap channels sometimes
% have step functions when they suddenly drop out! 
% do a wide window length to avoid catching alpha!! 
settings.arf.dropoutWin = 250; %ms
settings.arf.dropoutStep = 20; % ms
settings.arf.dropoutThr = 60; % microvolts

% Step function settings for blink rejection
settings.arf.blinkWin = 150; % ms
settings.arf.blinkStep = 10; % ms
settings.arf.blinkThr = 50; % microvolts

% Step function settings for horizontal eye movements 
settings.arf.eMoveWin = 100; % ms
settings.arf.eMoveStep = 10; % ms
settings.arf.eMoveThr = 20; %microvolts

% Settings for block rejection
settings.arf.blockWin = 100; % ms
settings.arf.blockStep = 50; % ms
settings.arf.blockX = 60; % ms
settings.arf.blockY = 1; % microvolts
