function recordingMode = getRecordingMode(eye)
% get recording mode from eye.FEVENT. Check that it matches what was
% specified in the settings file. Throw an error if the recording mode
% changed during the session. 
%
% Input:
% eye structure
%
% Output:
% recordingMode = string describing recording mode

% access messages
messages = {eye.FEVENT(:).message};

% set logicals for each mode to false
rm_m = 0; rm_b = 0; cr_m = 0; cr_b = 0;

% check which recording mode messages are present
if sum(strcmp(messages,'ELCLCFG RTABLER')) > 0
   recordingMode = 'RemoteMode_Monocular'; 
   rm_m = 1; % set logical to true
end

if sum(strcmp(messages,'ELCLCFG RBTABLER')) > 0
   recordingMode = 'RemoteMode_Binocular'; 
   rm_b = 1; % set logical to true
end

if sum(strcmp(messages,'ELCLCFG MTABLER')) > 0
   recordingMode = 'ChinRest_Monocular'; 
   cr_m = 1; % set logical to true
end

if sum(strcmp(messages,'ELCLCFG BTABLER')) > 0
   recordingMode = 'ChinRest_Binocular'; 
   cr_b = 1; % set logical to true
end

% sum logicals (if the sum exceeds 1, then the recording mode changed!)
recordingModeCheck = rm_m + rm_b + cr_m + cr_b;

% throw an error if the recording mode changed during session
if recordingModeCheck ~= 1
    error('the recording mode changed during the experimental session')
end


