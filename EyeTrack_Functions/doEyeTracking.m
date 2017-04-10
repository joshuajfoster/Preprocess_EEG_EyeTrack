function eyeData = doEyeTracking(eye,settings)
% preprocess the eye tracking data. This function , segments data, performs
% artifact rejection, and outputs a n
%
% Inputs:
% eye: eye structure with all eye tracking data
% settings: settings structure with eye tracking settings specified

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

% get distance to eye tracker if using remote mode, otherwise store vector of nans
if strcmp(settings.recordingMode,'RemoteMode_Monocular') | strcmp(settings.recordingMode,'RemoteMode_Binocular')
    eyeData.dist = (double((eye.FSAMPLE(:).hdata(3,:))))./100; % 3rd row is distance, divide by 100 to scale to cm
else
    eyeData.dist = nan(size(eyeData.sampleTimes)); % same size as eyeData.sampleTimes
end

%% Segment data
eyeData.trial = segment_eyetracking(eyeData,settings); 

%% calculate eye position in degrees of vis angle from fixation

% if data collected in remote mode
if strcmp(settings.recordingMode,'RemoteMode_Monocular') | strcmp(settings.recordingMode,'RemoteMode_Binocular')
    
    % check that settings.cam2screenDist exists, then use it!
    if isfield(settings,'cam2screenDist')
        cam2screenDist = settings.cam2screenDist;
    else % otherwise estimate it from viewing dist and head2cam dist
        cam2screenDist = approx_cam2screenDist(settings.viewDist,eyeData.dist);
    end
    
    % calculate degrees of visual angle
    [eyeData.trial.xDeg,eyeData.trial.yDeg] = pix2deg_remoteMode(eyeData.trial.gx,eyeData.trial.gy,eyeData.trial.dist,...
                                                cam2screenDist,settings.monitor.xPixels,settings.monitor.yPixels,settings.monitor.pxSize);
end

% if data collected with the chin rest...
if strcmp(settings.recordingMode,'ChinRest_Monocular') | strcmp(settings.recordingMode,'ChinRest_Binocular')
    
    % calculate degrees of visual angle
    [eyeData.trial.xDeg,eyeData.trial.yDeg] = pix2deg_chinRest(eyeData.trial.gx,eyeData.trial.gy,...
                                                settings.monitor.xPixels,settings.monitor.yPixels,settings.monitor.pxSize,settings.viewDist);
end


%% Artifact rejection: mark bad data

% mark bad data based on eyelink parser
[eyeData.arf.parserBlinks, eyeData.arf.parserSaccs] = markParserArtifacts(eyeData);

% run our own check for artifacts
[eyeData.arf.missingPupil, eyeData.arf.saccadeX, eyeData.arf.saccadeY] = runArtRejection_EyeTrack(eyeData,settings);

% print artifact summary
fprintf(sprintf('Parser Blink Rate: %.2f \n',sum(eyeData.arf.parserBlinks)./length(eyeData.arf.parserBlinks)))
fprintf(sprintf('Parser Saccade Rate: %.2f \n',sum(eyeData.arf.parserSaccs)./length(eyeData.arf.parserSaccs)))
fprintf(sprintf('Calculated nonsensical position vals: %.2f \n',sum(eyeData.arf.missingPupil)./length(eyeData.arf.missingPupil)))
fprintf(sprintf('Calculated horizontal saccades: %.2f \n',sum(eyeData.arf.saccadeX)./length(eyeData.arf.saccadeX)))
fprintf(sprintf('Calculated vertical saccades: %.2f \n',sum(eyeData.arf.saccadeY)./length(eyeData.arf.saccadeY)))

%% Remove continuos data from eyeData structure
eyeData = rmfield(eyeData,'gx');
eyeData = rmfield(eyeData,'gy');
eyeData = rmfield(eyeData,'hx');
eyeData = rmfield(eyeData,'hy');
eyeData = rmfield(eyeData,'pa');
eyeData = rmfield(eyeData,'dist');
