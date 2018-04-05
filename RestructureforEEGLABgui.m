function RestructureforEEGLABgui(sn,eyeTrack)
% Script to restructure EEG data from(Trials,chans,timepoints) to (Chans,Timepoints,Trials) for plotting with the EEG Lab plot function
% This script also concatenates the EEG data and Eye tracking data (if we have it forthe subject) 
% along with the logical indices from our automated artifact rejection procedures.
%
% Inputs:
% sn = subject number
% eyeTrack: 1 = usable eye tracking, 0 = no eye tracking, or eye tracking unusable
%
%The script saves 2 files:
%1. A restructured .mat file (subj#_restruct_for_arf).
%2. An EEG lab file for manual marking (subj#MarkingComplete.set and .fdt

dbstop if error

%% Directory info
dir = ['X:/Team Josh/JJF_EB_18_2/Artifact Rejection/Preprocessed_data/'];
eyeFilename = '_EYE_SEG_JF18_2'; % e.g. '_EYE_SEG_JF3.mat'
eegFilename = '_EEG_SEG_JJF_EB_18_2'; % e.g., _EEG_SEG_JJF_17_3.mat'

% name of restructured file to be saved
rName = [dir,num2str(sn),'_restruct_for_arf.mat'];

%% abort if a restructured file already exists
if exist(rName)
    disp('A restructured file already exists. It is time to move on!')
    return
end

%% load eeg data file
fprintf('Load eeg data... ')

% load eeg data
tic; load([dir,num2str(sn),eegFilename]); toc;

% index time points of interest
startTime = -erp.settings.seg.arfPreTime;
endTime = erp.settings.seg.arfPostTime;
arfWindow = ismember(erp.trial.times,startTime:endTime);

% get sampling rate
eeg_srate = erp.srate;

% get dimensions of data
nSampsEEG = sum(arfWindow);
nTrialsEEG = erp.trial.nTrials;
nEEGchans = erp.nChans;

% grab eeg data of interest
tmpeeg = erp.trial.baselined(:,:,arfWindow);


%% load eye tracking data (if available)
if eyeTrack
    
    load([dir,num2str(sn),eyeFilename]);
    
    % grab eye position in degrees of vis ang from fixation, multiply by 16
    % to covert to microvolts
    microV_H = eyeData.trial.xDeg_bl.*16; % horizontal gaze position
    microV_V = eyeData.trial.yDeg_bl.*16; % vertical gaze posiion
    
    % get sampling rate
    eye_srate = eyeData.sRate;
    
    % get dimensions of data
    nTrialsEye = eyeData.trial.nTrials;
    
    if nTrialsEye ~=nTrialsEEG
        disp('number of trials do not match across eye tracking and eeg files')
        return
    end
    
else % otherwise, set microV variables to nans
    
    microV_H = nan(nTrialsEEG,nSampsEEG);
    microV_V = nan(nTrialsEEG,nSampsEEG);
    
end

%% ensure the sampling rates match for eyetracking and eeg data

% only do this if eye tracking exists.
if eyeTrack
    
    % if eye tracking sampling is faster than eeg, downsample eye tracking
    if eye_srate > eeg_srate
        % downsample eye tracking data
        downsamp = eye_srate/eeg_srate;
        microV_H = microV_H(:,1:downsamp:end);
        microV_V = microV_V(:,1:downsamp:end);
        fprintf('EyeTrack sampled faster than EEG, downsampled eye tracking')
    end
    
    % if eeg sampling is faster than eye tracking, downsample eeg
    if eeg_srate > eye_srate
        % downsample eeg data
        downsamp = eeg_srate/eye_srate;
        tmpeeg = tmpeeg(:,:,1:downsamp:end);
        fprintf('EEG sampled faster than EyeTrack, downsampled EEG')
    end
    
    if eye_srate == eeg_srate
        fprintf('EEG and eye tracking sampling rates matched')
    end
    
    newEEGSamps = size(tmpeeg,3);
    newEyeSamps = size(microV_H,2);
    
    if newEEGSamps ~= newEyeSamps
        error('did not successfully match sampling rates of eeg and eye tracking')
    end
    
    nSamps = newEEGSamps;
    
else % otherwise just get nSamps for EEG
    
   nSamps = nSampsEEG;
   
end
%% restructure the data so it's compatible with EEGLab

nExtraChans = 6; % 2 for eyetracker and 4 for fixation lines
nChans = nEEGchans + nExtraChans;

% preallocate the restructured matrix
restructured = nan(nChans,nSamps,nTrialsEEG);

% put EEG data into restructured matrix
for ch = 1:nEEGchans
    for tr = 1:nTrialsEEG
        restructured(ch,:,tr) = squeeze(tmpeeg(tr,ch,:));
    end
end

% amount to shift by
HEOGShift = 100;
HEyeShift = 200;
VEOGShift = -200;
VEyeShift = -100;
StimTrackShift = 400;

% add eye tracking to restructured matrix     
for tr = 1:nTrialsEEG
    % add eye tracking
    restructured(nChans-5,:,tr) = microV_H(tr,:);
    restructured(nChans-4,:,tr) = microV_V(tr,:);  
    % add baseline lines
    restructured(nChans-3,:,tr) = HEOGShift;
    restructured(nChans-2,:,tr) = HEyeShift;   
    restructured(nChans-1,:,tr) = VEOGShift;
    restructured(nChans,:,tr) = VEyeShift;
end

% shift the position of the eye track, eog, and stim track so it's visible on the butterfly plot
restructured(nChans-8,:,:) = restructured(nChans-8,:,:)+HEOGShift; %shift heog
restructured(nChans-7,:,:) = restructured(nChans-7,:,:)+VEOGShift; %shift veog
restructured(nChans-6,:,:) = restructured(nChans-6,:,:)+StimTrackShift; %shift stim track to top
restructured(nChans-5,:,:) = restructured(nChans-5,:,:)+HEyeShift; %shift horizontal eye track
restructured(nChans-4,:,:) = restructured(nChans-4,:,:)+VEyeShift; %shift vertical eye track

%% save the data to the restructured file
save(rName,'restructured')


%% import data into EEGLab format

% srate = sampling rate, pnts = number of samples, xmin = start of epoch (e.g., -0.3 for -300 ms)
EEG = pop_importdata('dataformat','matlab','nbchan',nChans,'data',rName,'srate',erp.srate,'pnts',nSamps,'xmin',startTime/1000);
EEG = eeg_checkset( EEG );

%% import auto rejection information to the EEGLab file

if eyeTrack == 1 % eyetracking data!
    
    % BLUE: noise
    EEG.reject(:).rejkurt = erp.arf.noise;
    % GREEN: drift in EEG
    EEG.reject(:).rejconst = erp.arf.drift;
    % LIME GREEN: blinks, blocking, or dropout
    EEG.reject(:).rejthresh = (erp.arf.blocking | erp.arf.blink | erp.arf.dropout); % make all 0s and 1s again
    % RED: EyeTrack saccades
    EEG.reject(:).rejjp = eyeData.arf.saccade;
    % PINK: EyeTrack - gaze outside of window of interest or missing pupil
    EEG.reject(:).rejfreq = (eyeData.arf.outsideWindow | eyeData.arf.missingPupil);

else % no eyetracking data
    
    % BLUE: blocking, noise, or dropout
    EEG.reject(:).rejkurt = erp.arf.noise;
    % GREEN: drift
    EEG.reject(:).rejconst = erp.arf.drift;
    % LIME GREEN: blinks, blocking, or dropout
    EEG.reject(:).rejthresh = (erp.arf.blocking | erp.arf.blink | erp.arf.dropout); % make all 0s and 1s again
    % RED: EyeTrack saccades
    EEG.reject(:).rejjp = erp.arf.eMove;
    % PINK/PURPLE: not assigned
%     EEG.reject(:).rejfreq = erp.arf.eMove;
      
end

%% Save .set file with the artifact markers
EEG = eeg_checkset(EEG);
ename = [num2str(sn),'_ArtRejectIndex'];
EEG = pop_saveset( EEG,'filename',ename,'filepath',dir);

