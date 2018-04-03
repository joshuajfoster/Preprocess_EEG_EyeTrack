function eyeData = runArtRejection_EyeTrack(eyeData,arfSettings)
% run check for eye artifacts
%
% Inputs:
% trial structure
% arf settings structure with the step function settings
%
% Outputs
% missingPupil: vector of trials with missing pupil (non-sensical gaze coordinates)
% saccade: vector of trials with saccades detected with 2d step function
% outsideWindow: vector of trials marking trials where eye tracking out of bounds

fprintf('checking for artifacts...')

% preallocate vectors
missingPupil = nan(1,eyeData.trial.nTrials); saccade = missingPupil; outsideWindow = missingPupil; 

% loop through trials
for t = 1:eyeData.trial.nTrials
    
    %% grab gaze data for current trial
    xGaze = eyeData.trial.gx(t,:);
    yGaze = eyeData.trial.gy(t,:);
    xDeg = eyeData.trial.xDeg(t,:);
    yDeg = eyeData.trial.yDeg(t,:);
    
    % check for missing pupil (e.g. blinks)
    [mpx, mpy] = checkForMissingPupil(xGaze,yGaze);
    missingPupil(t) = art_detect(mpx) | art_detect(mpy); % mark if missing pupil in x or y data
        
    % check for saccades
    saccade_trial = art_step_gazecoords(xDeg,yDeg,eyeData.rateAcq,arfSettings.stepSize,arfSettings.winSize,arfSettings.maxDeg);
    saccade(t) = art_detect(saccade_trial);
    
    % check that eye tracking is inside acceptable window
    outsideWindow_trial = art_gazeDevFromFix(eyeData.trial.xDeg_bl(t,:),eyeData.trial.yDeg_bl(t,:),arfSettings.window);
    outsideWindow(t) = art_detect(outsideWindow_trial);
    
end

eyeData.arf.arfSettings = arfSettings; 

% covert to logicals
eyeData.arf.missingPupil = logical(missingPupil);
eyeData.arf.saccade = logical(saccade);
eyeData.arf.outsideWindow = logical(outsideWindow);

% mark trials with any kind of artifact
eyeData.arf.allArtifacts = (eyeData.arf.missingPupil | eyeData.arf.saccade | eyeData.arf.outsideWindow);

% print artifact summary
fprintf('\n')
fprintf(sprintf('Missing pupil: %.2f \n',100*sum(eyeData.arf.missingPupil)./length(eyeData.arf.missingPupil)));
fprintf(sprintf('Saccades: %.2f \n',100*sum(eyeData.arf.saccade)./length(eyeData.arf.saccade)))
fprintf(sprintf('Eyes out of bounds: %.2f \n',100*sum(eyeData.arf.outsideWindow)./length(eyeData.arf.outsideWindow)))
fprintf(sprintf('Total: %.2f \n',100*sum(eyeData.arf.allArtifacts)./length(eyeData.arf.allArtifacts)))
