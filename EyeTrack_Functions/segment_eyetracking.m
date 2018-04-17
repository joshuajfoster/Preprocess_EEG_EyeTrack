function trial = segment_eyetracking(eyeData,settings)
% segment eye tracker data
%
% Inputs:
% eyeData: struct with relevant eye tracking variables
% settings: settings struct, which specifies segmentation parameters
%
% Outputs:
% trial: structure with segmented data and segmentation parameters
%
% Note: Past versions of this function did not properly handle missing data
% points at the start of the trial. If data points were missing, the first
% available sample was assumed to be the first wanted sample point. So
% instead of there being NaNs at the start of the trial, they ended up at
% the end of the trial. The problem has been corrected in this function.
%
% IMPORTANT FIX: sometimes the recorded time for an event marker
% doesn't line up with the times at which data was sampled. For
% example, when sampling at 500 Hz, we might have data sampled at 1000
% ms, 1002 ms, 1004 ms. However, it's possible that a time-locking
%  message was sent at 1003 ms. In this case, we would try to
% get the time points at 1001 ms, 1003 ms, 1005 ms etc. but these don't
% exist! To deal with this problem, we shift the tWindow index by 1 ms
% if no data was found. This fix isn't necessary for a sampling rate of 1000 Hz. 
% See "fix for when marker time is out of sync with sample points" below

fprintf('segmenting eye tracking data...');
tic

timeLockInd = strcmp(settings.seg.timeLockMessage,eyeData.messages); % index the time-locking message (e.g., 'StimOnset')
trial.timeLockTimes = eyeData.eventTimes(timeLockInd); % times for time-locking messsage
trial.nTrials = sum(timeLockInd); % adds up logical index to get number of trials

% throw an error if no trials were found
if trial.nTrials == 0
    error('Did not find any trials. Did you specify the right event marker in the settings file?')
end

% save times vector for each trial
trial.times = -settings.seg.preTime:eyeData.rateAcq:settings.seg.postTime; % time points in segment
trial.nSamps = length(trial.times); % expected number of samples per segment

% specify start and end times of each segment
trial.startTimes = double(trial.timeLockTimes) - settings.seg.preTime; % start time, ms
trial.endTimes = double(trial.timeLockTimes) + settings.seg.postTime;  % end time, ms

% preallocate matrices for segmented data (all the same size)
trial.gx = nan(trial.nTrials,trial.nSamps); trial.gy = trial.gx; trial.pa = trial.gx;
trial.exist = trial.gx;

% create structs to put data in
trial_exist = trial.exist; 
trial_gx = {};
trial_gy = {};
trial_pa = {};

startTimes = trial.startTimes;
endTimes = trial.endTimes;

% loop through trials and segment data
parfor t = 1:trial.nTrials
    
    % grab the start and end of trial t
    tStart = startTimes(t); tEnd = endTimes(t);
    
    % specify window of interest
    tWindow = tStart:double(eyeData.rateAcq):tEnd; 
    
    % index times of interest with logical
    tWindowInd = ismember(double(eyeData.sampleTimes),tWindow);
    
    % fix for when marker time is out of sync with sample points
    if eyeData.rateAcq == 2
        if sum(tWindowInd) == 0
            tWindow = tWindow-1;
            tWindowInd = ismember(double(eyeData.sampleTimes),tWindow);
        end
    end
    
    % throw an error if sampling rate is less than 500 Hz
    if eyeData.rateAcq > 2
        error('Sampling rate lower than 500 Hz. Have not prepared the fix above for sampling freqs lower than 500 Hz')
    end
    
    % create index of the time points that actually exist in the data (i.e., that were recorded).
    existInd = ismember(tWindow,double(eyeData.sampleTimes)); % FIXED - changed to double
    
    % determine which eye was recorded for trial t
    recordedEye = eyeData.RecordedEye(t);
    
    % grab the relevant segment of data (from the recorded eye)
    trial_gx{t} = eyeData.gx(recordedEye,tWindowInd);
    trial_gy{t} = eyeData.gy(recordedEye,tWindowInd);
    trial_pa{t} = eyeData.pa(recordedEye,tWindowInd);
    
    % save exist to the trial structure to make it easy to check where data is missing
    trial_exist(t,:) = existInd;
    
end

% put trial data into matrices (but only for points where data was actually
% sampled)
trial.exist = logical(trial_exist);
for t = 1:trial.nTrials
trial.gx(t,trial.exist(t,:)) = trial_gx{t};
trial.gy(t,trial.exist(t,:)) = trial_gy{t};
trial.pa(t,trial.exist(t,:)) = trial_pa{t};
end

% plot the missing data to alert experimenter to problems
figure; imagesc(trial.exist);
title('Missing samples (1 = data present, 0 = data missing)')
xlabel('Samples')
ylabel('Trials')
caxis([0 1]) % FIXED - hard code color limit
colorbar

fprintf('\n')
toc


