function settings = EyeTrack_Settings
% This function specifies the eye tracking settings that the preprocessing
% functions call on. 

fprintf('loading eye tracking settings... \n')

%% Directory information
settings.dir.raw_filename = ['JFEB4']; % name of data file (minus subject number)
settings.dir.raw_data_path = ['F:\UC Raw Data\JJF_EB_16_4\EyeTrack\']; % where to find eyetracking data
settings.dir.processed_data_path = ['F:\UC Artifact Rejection\JJF_EB_16_4\Preprocessed_Data\']; % detination for preprocessed files

%% General setup

% eye tracker settings
settings.sRate = 500; % sampling rate (Hz)
settings.rateAcq = 1000/settings.sRate; % 500 Hz = 2 ms rateAcq
settings.recordingMode = 'RemoteMode_Monocular'; % 'RemoteMode_Monocular', 'RemoteMode_Binocular', 'ChinRest_Monocular', 'ChinRest_Binocular'

% key distances
% settings.cam2screenDist % distance from monitor to eye tracker, if recorded
settings.viewDist = 100; % viewing distance (cm)

% monitor details
settings.monitor.xPixels = 1920;
settings.monitor.yPixels = 1024;
settings.monitor.pxSize = 0.0275;

%% segmentation settings
settings.seg.timeLockMessage = 'SampleOnset'; % message for time locking
settings.seg.preTime = 300;  % pre-stimulus end of segment, absolute value (ms)
settings.seg.postTime = 2400; % post-stimulus end of segment, absolute value (ms)

%% artifact rejection settings

% for doing our artifact rejection
settings.arf.winSize = 80; % ms --- size of sliding window that is looking for saccades
settings.arf.stepSize = 10;  % ms ---- how much the window moves by 
settings.arf.maxDeg = .5; % degrees of visual angle! if it's bigger than this reject it 

