function settings = EyeTrack_Settings
% This function specifies the eye tracking settings that the preprocessing
% functions call on. 

fprintf('loading eye tracking settings... \n')

%% Eye tracker settings
settings.sRate = 500; % sampling rate (Hz)
settings.rateAcq = 1000/settings.sRate; % 500 Hz = 2 ms rateAcq
settings.recordingMode = 'RemoteMode_Monocular'; % 'RemoteMode_Monocular', 'RemoteMode_Binocular', 'ChinRest_Monocular', 'ChinRest_Binocular'


settings.viewDist = 100; % viewing distance (cm)


% REVIEW
% IF chin-rest mode, indicate distnce from the EYE to the SCREEN (in cm)
eyeData.DistanceToScreen = 73.8; % Measured on 9/21/16 - Don't move eyetracker from tape!
% IF remote mode, indicate distance from CAMERA to SCREEN (in cm) (distance
% from eye to camera is recorded in the data file and we will use that.
eyeData.DistanceToCamera = 37.6; % Measured on 9/21/16 - Don't move eyetracker from tape!

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

