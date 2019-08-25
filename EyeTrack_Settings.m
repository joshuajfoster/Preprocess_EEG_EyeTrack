function settings = EyeTrack_Settings
% This function specifies the eye tracking settings that the preprocessing
% functions call on. 

fprintf('loading eye tracking settings... \n')

%% operating system
settings.os = 'mac'; % 'mac' or 'windows'

%% Directory information
settings.dir.raw_filename = ['JFEB7']; % name of data file (minus subject number)
settings.dir.raw_data_path = ['/Foster/Archived Data/N2pc_cueing/Raw Data/Exp1/EyeTrack/']; % where to find eyetracking data
settings.dir.processed_data_path = ['/Foster/Archived Data/N2pc_cueing/ResegmentTest/']; % detination for preprocessed files

%% General setup

% eye tracker settings
settings.sRate = 1000; % sampling rate (Hz)
settings.rateAcq = 1000/settings.sRate; % 500 Hz = 2 ms rateAcq
settings.recordingMode = 'ChinRest_Monocular'; % 'RemoteMode_Monocular', 'RemoteMode_Binocular', 'ChinRest_Monocular', 'ChinRest_Binocular'

%% all the stuff below is for segmentation

% key distances
% settings.cam2screenDist % distance from monitor to eye tracker, if recorded
settings.viewDist = 75; % viewing distance (cm)

% monitor details
settings.monitor.xPixels = 1920;
settings.monitor.yPixels = 1080;
settings.monitor.pxSize = 0.0277; % 53.2 cm wide/1920 pixels

%% segmentation settings
settings.seg.timeLockMessage = 'CueOnset'; % message for time locking
settings.seg.timeOffset = 8; % note: this shold match the timeOffset param in EEG_Settings
settings.seg.preTime = 300;  % pre-stimulus end of segment, absolute value (ms)
settings.seg.postTime = 1200; % post-stimulus end of segment, absolute value (ms)
settings.seg.bl_start = -300; % start of baseline (e.g. -200 for 200 ms pre stimulus)
settings.seg.bl_end = 0;     % end of basline
