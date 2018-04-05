function arfSettings = EyeTrack_ArtRejectSettings
% This function specifies the eye tracking settings that the artifact
% rejection settings

%% artifact rejection settings

% for doing our artifact rejection
arfSettings.winSize = 60; % ms --- size of sliding window that is looking for saccades
arfSettings.stepSize = 10;  % ms ---- how much the window moves by 

% degrees of visual angle! if it's bigger than this, reject it 
arfSettings.maxDeg = .5; % default = 0.5

% degrees of visual angle. Max acceptable distance of (baselined) gaze from fixation
arfSettings.window = 1.2; % default = 1.0