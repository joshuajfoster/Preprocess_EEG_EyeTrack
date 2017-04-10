function [missingPupil,saccadeX, saccadeY] = runArtRejection_EyeTrack(eyeData,settings)
% run a secondary check for bad eye tracking data
%
% Inputs:
% trial structure
% settings structure with the step function settings
%
% Outputs
% missingPupil: vector of trials with missing pupil (non-sensical gaze coordinates)
% saccade: vector of trials with saccades detected with step function

% preallocate vectors
missingPupil = nan(1,eyeData.trial.nTrials); saccadeX = missingPupil; saccadeY = missingPupil;

% loop through trials
for t = 1:eyeData.trial.nTrials
    
    %% grab gaze data for current trial
    xGaze = eyeData.trial.gx(t,:);
    yGaze = eyeData.trial.gy(t,:);
    xDeg = eyeData.trial.xDeg(t,:);
    yDeg = eyeData.trial.yDeg(t,:);
    
    %% mark trials where the eye tracker lost the pupil (e.g. blinks)
    
    [mpx, mpy] = checkForMissingPupil(xGaze,yGaze);
    missingPupil(t) = art_detect(mpx) | art_detect(mpy); % mark if missing pupil in x or y data
        
    %% run step function as a second check for saccades
       
    % check xgaze
    stepX = art_step(xDeg,eyeData.rateAcq,settings.arf.stepSize,settings.arf.winSize,settings.arf.maxDeg);
    saccadeX(t) = art_detect(stepX);
    
    % check ygaze
    stepY = art_step(yDeg,eyeData.rateAcq,settings.arf.stepSize,settings.arf.winSize,settings.arf.maxDeg);
    saccadeY(t) = art_detect(stepY);
    
end

% covert to logicals
saccadeX = logical(saccadeX);
saccadeY = logical(saccadeY);
missingPupil = logical(missingPupil);






