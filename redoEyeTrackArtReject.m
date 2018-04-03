function redoEyeTrackArtReject(sn)
% allows you to rerun the artifact rejection procedure without resegmenting
% the eye  tracking data.

dbstop if error
root = pwd; eyeRoot = [root,'\EyeTrack_Functions\']; addpath(eyeRoot); % add folder with eyetrack functions
arfRoot = [root,'\Artifact_Functions\']; addpath(arfRoot); % add folder with artifact detection functions

%% load in the segmented eye tracking file

% load segmented eye tracking file
settings = EyeTrack_Settings; 
load([settings.dir.processed_data_path,num2str(sn),'_EYE_SEG_',settings.dir.raw_filename,'.mat'])

% run artifact rejection procedure
arfSettings = EyeTrack_ArtRejectSettings; 
eyeData = runArtRejection_EyeTrack(eyeData,arfSettings); 

% save file again. 
save([settings.dir.processed_data_path,num2str(sn),'_EYE_SEG_',settings.dir.raw_filename,'.mat'],'eyeData')