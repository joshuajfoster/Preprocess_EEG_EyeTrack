function settings = EEG_Settings
% This function specifies the settings that the preprocessing functions call on.

fprintf('loading settings... \n')

settings.droppedElectrodes = {'Fp1','Fp2'}; % electrodes to remove

%% directory info
settings.dir.raw_filename = ['JJF_EB_16_7']; % name of data file (minus subject number)
settings.dir.raw_data_path = ['/Foster/Archived Data/N2pc_cueing/Raw Data/Exp1/EEG/']; % where to find EEG data
settings.dir.processed_data_path = ['/Foster/Archived Data/N2pc_cueing/ResegmentTest/']; % where to save preprocessed files

%% segmentation settings

settings.seg.codes = [51]; % vector of all event codes of interest.
settings.seg.timeOffset = 8; % often there is a small, fixel delay from the 
% event code to the stimulus onset. This param allows you to correct that 
% (e.g. set to 10 if stim trak lagged marker by 10 ms). 

% Timing for artifact rejection (times should be ABSOLUTE VALUES) 
settings.seg.arfPreTime =  300; % msec prior to timelock (e.g., 300 is 300 ms prior to time-locking event)
settings.seg.arfPostTime = 1200; % msec post timelock

% Timing stuff for building waveforms (times should be absolute values) 
settings.seg.preTime = settings.seg.arfPreTime+500; % msecs prior to timelock built in extra 500ms for time freq analyses
settings.seg.postTime = settings.seg.arfPostTime+500; % msecs post timelock

% Window for baselining (time should be NEGATIVE IF PRE-=TIMELOCKING
settings.seg.baseStart = -300;  %%% if using the whole time period, just use -settings.preTime
settings.seg.baseEnd = 0; 

%% artifact rejection settings

% Noise threshold for artifact rejection
settings.arf.noiseThr = 120; % microvolts (default = 120)
settings.arf.noiseWin = 15; % ms (short so the peak-to-peak algorithm is selective for high-freq noise)
settings.arf.noiseStep = 15; % ms no need to check more than every 50 ms for noise

% Threshold for drift
settings.arf.driftThr = 40; %microvolts (default = 40)

% Step function settings for channel drop out (main cap channels sometimes
% have step functions when they suddenly drop out! 
% do a wide window length to avoid catching alpha!! 
settings.arf.dropoutThr = 60; % microvolts (default = 60)
settings.arf.dropoutWin = 250; %ms 
settings.arf.dropoutStep = 20; % ms

% Step function settings for blink rejection
settings.arf.blinkWin = 150; % ms (default = 150)
settings.arf.blinkStep = 10; % ms
settings.arf.blinkThr = 50; % microvolts

% Step function settings for horizontal eye movements 
settings.arf.eMoveThr = 20; % microvolts (default = 20)
settings.arf.eMoveWin = 100; % ms 
settings.arf.eMoveStep = 10; % ms

% Settings for block rejection
settings.arf.blockWin = 100; % ms
settings.arf.blockStep = 50; % ms
settings.arf.blockX = 60; % ms
settings.arf.blockY = 0.5; % microvolts
