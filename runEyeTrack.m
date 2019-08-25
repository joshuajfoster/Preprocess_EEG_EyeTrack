function runEyeTrack(sn)
%quick loop to import edf files to .mat files
dbstop if error
root = pwd; eyeRoot = [root,'/EyeTrack_Functions/']; addpath(eyeRoot); % add folder with eyetrack functions
arfRoot = [root,'/Artifact_Functions/']; addpath(arfRoot); % add folder with artifact detection functions

%% Print subject number
fprintf('Subject:\t%d\n',sn)

%% load in the preprocessing settings.
% Everything that you'd want to change is specified in the EyeTrack_Settings script
settings = EyeTrack_Settings;

%% load eye tracking data

% if on windows, you load .edf and convert to a .mat file
if strcmp(settings.os,'windows')
    edf_name = [num2str(sn),settings.dir.raw_filename];
    eye = edf2mat(settings.dir.raw_data_path,edf_name,settings.dir.processed_data_path);
end

% if on a mac, you must have already convered .edf to a .mat
if strcmp(settings.os,'mac')
    edf_name = [num2str(sn),settings.dir.raw_filename,'.mat'];
    load([settings.dir.raw_data_path,edf_name]);
end

%% preprocess eyetracking data and save file
eyeData = doEyeTracking(eye,settings);

%% artifact rejection
arfSettings = EyeTrack_ArtRejectSettings;
eyeData = runArtRejection_EyeTrack(eyeData,arfSettings); 

eyeData.settings = settings; % save settings to eyeData structure
save([settings.dir.processed_data_path,num2str(sn),'_EYE_SEG_',settings.dir.raw_filename,'.mat'],'eyeData')