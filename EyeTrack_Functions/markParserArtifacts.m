function [parserBlinks parserSaccs parserTimes] = markParserArtifacts(eyeData)
% check the segmented portions of data for blinks and saccades detected by
% the EyeLink parser.
%
% Input:
% eyeData: complete eye data structure
%
% Outputs:
% parserBlinks: index of trials with parser-detected blinks
% parserSaccs: index of trials with parser-detected saccades
% parserTimes: structure with the exact times of all events (optional)

% grab relevant codestrings
blinkStartInd = strcmp('STARTBLINK ',eyeData.codestrings); %space here is necessary
blinkEndInd = strcmp('ENDBLINK',eyeData.codestrings);
saccStartInd = strcmp('STARTSACC',eyeData.codestrings);
saccEndInd = strcmp('ENDSACC',eyeData.codestrings);

% grab the times for events of interest, save to arf structure
parserTimes.blinkStart = eyeData.eventTimes(blinkStartInd); % times for blink start, and so on...
parserTimes.blinkEnd = eyeData.eventTimes(blinkEndInd);
parserTimes.saccStart = eyeData.eventTimes(saccStartInd);
parserTimes.saccEnd = eyeData.eventTimes(saccEndInd);

nTrials = eyeData.trial.nTrials;

% preallocate matrices for detected saccades and blinks
rejBlMat = zeros(1,nTrials);
rejSaccMat = zeros(1,nTrials);

% loop through trials and check whether they contained artifacts
for t = 1:nTrials
    
    % get trial start and trial end
    tStart = eyeData.trial.startTimes(t);
    tEnd = eyeData.trial.endTimes(t);
    tWindow = tStart:tEnd;
    
    % was there a blink during the trial?
    if sum(ismember(tWindow,parserTimes.blinkStart))>0 | sum(ismember(tWindow,parserTimes.blinkEnd))>0
        rejBlMat(t) = 1;
    end
    
    % was there a saccade during the trial?
    if sum(ismember(tWindow,parserTimes.saccStart))>0 | sum(ismember(tWindow,parserTimes.saccEnd))>0
        rejSaccMat(t) = 1;
    end
    
end

parserBlinks = logical(rejBlMat); % logical of if there were blinks
parserSaccs = logical(rejSaccMat); % logical of if there were saccades



