function eye = edf2mat(edf_dir,edf_fname,output_dir)
% converts the .edf file to a .mat file and saves this. Also
% passes 'eye' struct forward for further processing. 
%
% Inputs:
% edf_dir: location of .edf file
% edf_fname: name of edf file (without .edf suffix)
% output_dir: location to save .mat file
%
% Outputs:
% eye: structure with all eye tracking data
% saves 'eye' to the
%
% JJF, 4.3.2018

fprintf('converting .edf file to .mat file...');
fprintf('\n')
tStart = tic;

% full path to file
full_file_path = [edf_dir,edf_fname,'.edf'];

% check that file exists
if ~exist(full_file_path)
    error(['Cannot find the file at ',full_file_path])
end

% read in edf file
eye = edfmex(full_file_path); 

% save the data file
fprintf('\n')
fprintf('saving .mat file...');
save([output_dir,edf_fname,'.mat'],'eye')

tEnd = toc(tStart);
fprintf('\n')
fprintf('done: %d minutes and %f seconds\n', floor(tEnd/60), rem(tEnd,60));
