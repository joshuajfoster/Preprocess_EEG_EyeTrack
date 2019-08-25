function runEyeTrack(sn)
%quick loop to import edf files to .mat files
dbstop if error
root = pwd; eyeRoot = [root,'\EyeTrack_Functions\']; addpath(eyeRoot); % add folder with eyetrack functions
arfRoot = [root,'\Artifact_Functions\']; addpath(arfRoot); % add folder with artifact detection functions

%% Print subject number
fprintf('Subject:\t%d\n',sn)

%% load in the preprocessing settings.
% Everything that you'd want to change is specified in the EyeTrack_Settings script
settings = EyeTrack_Settings;

%% convert the edf file to a mat file (and save)
edf_name = [num2str(sn),settings.dir.raw_filename];
eye = edf2mat(settings.dir.raw_data_path,edf_name,settings.dir.processed_data_path);

%% preprocess eyetracking data and save file
eyeData = doEyeTracking(eye,settings);

%% artifact rejection
arfSettings = EyeTrack_ArtRejectSettings;
eyeData = runArtRejection_EyeTrack(eyeData,arfSettings); 

eyeData.settings = settings; % save settings to eyeData structure
save([settings.dir.processed_data_path,num2str(sn),'_EYE_SEG_',settings.dir.raw_filename,'.mat'],'eyeData')