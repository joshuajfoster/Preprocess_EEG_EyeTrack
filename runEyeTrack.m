function runEyeTrack(subs)
%quick loop to import edf files to .mat files
dbstop if error
root = pwd; eyeRoot = [root,'\EyeTrack_Functions\']; addpath(eyeRoot); % add folder with eyetrack functions
arfRoot = [root,'\Artifact_Functions\']; addpath(arfRoot); % add folder with artifact detection functions

%% Directory info
filename = ['JFEB4']; % name of data file (minus subject number)
data_path = ['F:\UC Raw Data\JJF_EB_16_4\EyeTrack\']; % where to find eyetracking data
dRoot = ['F:\UC Artifact Rejection\JJF_EB_16_4\Preprocessed_Data\']; % detination for preprocessed files

%% loop through subjects
for i = 1:length(subs)
    
    %% Print subject number
    sn = subs(i);
    fprintf('Subject:\t%d\n',sn)
    
    %% load in the preprocessing settings.
    % Everything that you'd want to change is specified in the EyeTrack_Settings script
    settings = EyeTrack_Settings;
    
    %% preprocess eye track data and save file (no segmentation)
    fname = [num2str(sn),filename];
    eye = edfmex([data_path,fname,'.edf']); % read in edf file
    
    % check the specified sampling rate is correct
    if settings.sRate ~= eye.RECORDINGS(1).('sample_rate')
        error('specified sampling rate does not match data file.')
    end
    
    % check the specified recording mode is correct
    recordingMode = getRecordingMode(eye);
    if ~strcmp(recordingMode,settings.recordingMode) % if these strings don't match...
        error('specified recording mode does not match data file.')
    end
    
    % save the data file
    save([dRoot,fname,'.mat'],'eye')
   
    %% preprocess eyetracking data and save file
    eyeData = doEyeTracking(eye,settings); 
    eyeData.settings = settings; % save settings to eyeData structure
    save([dRoot,num2str(sn),'_EYE_SEG_',filename,'.mat'],'eyeData')
    
end
