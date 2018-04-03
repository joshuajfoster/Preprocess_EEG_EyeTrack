function eyeData = doEyeTracking(eye,settings)
% preprocess the eye tracking data. This function , segments data, performs
% artifact rejection, and outputs a n
%
% Inputs:
% eye: eye structure with all eye tracking data
% settings: settings structure with eye tracking settings specified

%% check that  eye tracker settings match what is specified in settings file

% check the specified sampling rate is correct
if settings.sRate ~= eye.RECORDINGS(1).('sample_rate')
    error('specified sampling rate does not match data file.')
end

% check the specified recording mode is correct
recordingMode = getRecordingMode(eye);
if ~strcmp(recordingMode,settings.recordingMode) % if these strings don't match...
    error('specified recording mode does not match data file.')
end

%% Grab the relevant data from the eye stucture

% sampling rate
eyeData.sRate = getSamplingRate(eye);
eyeData.rateAcq = 1000./eyeData.sRate; % calculate rate of data acquisition (ms)

% message and codestrings
eyeData.messages = {eye.FEVENT(:).message}; % grab messages sent from PsychToolbox
eyeData.codestrings = {eye.FEVENT(:).codestring}; % grab codestrings (includes STARTSACC,ENDSACC,STARTFIX,ENDFIX,STARTBLINK,ENDBLINK among other things)
eyeData.eventTimes = [eye.FEVENT(:).sttime]; % when events occured

% which eye was recorded on each trial
RecordedEyeVec = [eye.RECORDINGS(:).('eye')]; % the eye that was tracked (left or right)
RecordedEyeIdx = [1:2:length(RecordedEyeVec)]; % RECORDINGS taken at start and end of each trial, only grab the starts (i.e. odd entries)
eyeData.RecordedEye=RecordedEyeVec(RecordedEyeIdx);

% eye tracking data
eyeData.sampleTimes = [eye.FSAMPLE(:).time]; % the times at which data was sampled
eyeData.gx = [eye.FSAMPLE(:).gx]; % gaze referenced x coords
eyeData.gy = [eye.FSAMPLE(:).gy]; % gaze referenced y coords
eyeData.hx = [eye.FSAMPLE(:).hx]; % head referenced x coords
eyeData.hy = [eye.FSAMPLE(:).hy]; % head referenced y coords
eyeData.pa = [eye.FSAMPLE(:).pa]; % head referenced pupil size / area

%% Segment data
eyeData.trial = segment_eyetracking(eyeData,settings); 

%% calculate eye position in degrees of vis angle from fixation

% if data collected with the chin rest...
if strcmp(settings.recordingMode,'ChinRest_Monocular') | strcmp(settings.recordingMode,'ChinRest_Binocular')
    
    % calculate degrees of visual angle
    [eyeData.trial.xDeg,eyeData.trial.yDeg] = pix2deg_chinRest(eyeData.trial.gx,eyeData.trial.gy,...
                                                settings.monitor.xPixels,settings.monitor.yPixels,settings.monitor.pxSize,settings.viewDist);
else
    errror('Do not use remote mode. It sucks!')
end

%% do baseline corection
eyeData.trial.xDeg_bl = doBaseline_EyeTrack(eyeData.trial.xDeg,eyeData.trial.times,settings.seg.bl_start,settings.seg.bl_end);
eyeData.trial.yDeg_bl = doBaseline_EyeTrack(eyeData.trial.yDeg,eyeData.trial.times,settings.seg.bl_start,settings.seg.bl_end);

%% Remove continuos data from eyeData structure
eyeData = rmfield(eyeData,'gx');
eyeData = rmfield(eyeData,'gy');
eyeData = rmfield(eyeData,'hx');
eyeData = rmfield(eyeData,'hy');
eyeData = rmfield(eyeData,'pa');
