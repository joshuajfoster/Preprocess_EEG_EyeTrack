function erp = runArtRejection(erp,settings)
% runs artifact detection scripts

%% grab relevant info from erp and settings structures so that we can effectively parfor

nTrials = erp.trial.nTrials;
chanLabels = erp.chanLabels;
nChans = erp.nChans;
chanInd = 1:nChans;
rateAcq = erp.rateAcq;

% Preallocate matrices 
mark_blockingFull = nan(nChans,nTrials);
mark_noiseFull = nan(nChans,nTrials);
mark_driftFull = nan(nChans,nTrials);
mark_dropoutFull = nan(nChans,nTrials);

erp.arf.blink = nan(1,nTrials);
erp.arf.eMove = nan(1,nTrials);
erp.arf.artifactInd = nan(1,nTrials);

% grab arf settings
noiseThr = settings.arf.noiseThr;
noiseWin = settings.arf.noiseWin;
noiseStep = settings.arf.noiseStep;
driftThr = settings.arf.driftThr;
dropoutWin = settings.arf.dropoutWin;
dropoutStep = settings.arf.dropoutStep;
dropoutThr = settings.arf.dropoutThr;
blinkWin = settings.arf.blinkWin;
blinkStep = settings.arf.blinkStep; 
blinkThr = settings.arf.blinkThr; 
eMoveWin = settings.arf.eMoveWin; 
eMoveStep = settings.arf.eMoveStep; 
eMoveThr = settings.arf.eMoveThr; 
blockStep = settings.arf.blockStep;
blockWin = settings.arf.blockWin;
blockX = settings.arf.blockX;
blockY = settings.arf.blockY;

%% loop through channels and check for artifacts
fprintf('checking scalp channels for artifacts... \n');tic

for i = 1:nChans
    
    % grab data the portion of the segment to apply artifact rejection
    arf_tois = ismember(erp.trial.times,-settings.seg.arfPreTime:settings.seg.arfPostTime);
    chanDat = squeeze(erp.trial.baselined(:,i,arf_tois));
    
    parfor t = 1:nTrials

        % get raw time-series for the trial and electrode
        rawTS = chanDat(t,:);
        
        % check for blocking in all channels except StimTrak
        checkChannel = ~ismember(chanLabels,'StimTrak');  % specify names of channels to skip
        if checkChannel(i)        
            block = art_block(rawTS,rateAcq,blockStep,blockWin,blockX,blockY);
            mark_blockingFull(i,t) = art_detect(block);
        end
        
        % check for noise in all scalp channels
        checkChannel = ~ismember(chanLabels,{'HEOG','VEOG','StimTrak'}); % specify names of channels to skip        
        if checkChannel(i)
            noise = art_ppa(rawTS,rateAcq,noiseStep,noiseWin,noiseThr);
            mark_noiseFull(i,t) = art_detect(noise);
        end
        
        % check for extreme drift in all scalp channles 
        checkChannel = ~ismember(chanLabels,{'HEOG','VEOG','StimTrak'}); % specify names of channels to skip        
        if checkChannel(i)
             drift = art_drift(rawTS,rateAcq,driftThr);
             mark_driftFull(i,t) = art_detect(drift);
%              dev_from_bl = art_dev_from_baseline(rawTS,80);
%              mark_driftFull(i,t) = art_detect(dev_from_bl);
        end

        % check for extreme channel drop out (step function) in all scalp channles
        checkChannel = ~ismember(chanLabels,{'HEOG','VEOG','StimTrak'}); % specify names of channels to skip
        if checkChannel(i)
            dropout = art_step(rawTS,rateAcq,dropoutStep,dropoutWin,dropoutThr);
            mark_dropoutFull(i,t) = art_detect(dropout);
        end
        
    end
end

% put everything back outside of the parfor loop
erp.arf.blockingFull = mark_blockingFull;
erp.arf.noiseFull = mark_noiseFull;
erp.arf.driftFull = mark_driftFull;
erp.arf.dropoutFull = mark_dropoutFull;
toc

%% Check for blinks
fprintf('checking for blinks... \n');tic
mark = nan(1,nTrials);
veogDat = squeeze(erp.trial.data(:,ismember(chanLabels,'VEOG'),arf_tois));
parfor t = 1:nTrials
    rawTS = veogDat(t,:);
    % Check for blinks using step function
    blink = art_step(rawTS,rateAcq,blinkStep,blinkWin,blinkThr);
    mark(t) = art_detect(blink);
end
erp.arf.blink = logical(mark);

%% check for eye movements
fprintf('checking for eye movements... \n');tic
mark = nan(1,nTrials);
heogDat = squeeze(erp.trial.data(:,ismember(chanLabels,'HEOG'),arf_tois));
% check for horizontal eye movements 
parfor t = 1:nTrials
        rawTS = heogDat(t,:);
        % check for eye movements using step function
        eMoveH = art_step(rawTS,rateAcq,eMoveStep,eMoveWin,eMoveThr);     
        mark(t) = art_detect(eMoveH);  
end
erp.arf.eMove = logical(mark);


%% create a vector each trials as having an artifact or not
erp.arf.noise = summarizeArtifacts(erp.arf.noiseFull);
erp.arf.blocking = summarizeArtifacts(erp.arf.blockingFull);
erp.arf.drift = summarizeArtifacts(erp.arf.driftFull);
erp.arf.dropout = summarizeArtifacts(erp.arf.dropoutFull);

%% loop through trials and create an index of all artifacts
for t = 1:nTrials
    erp.arf.artifactInd(t) = erp.arf.blocking(t) | erp.arf.noise(t) | erp.arf.blink(t) | erp.arf.drift(t) | erp.arf.dropout(t);
end
erp.arf.artifactInd = logical(erp.arf.artifactInd); 

% note: not including eye movements here because it false alarms too often
% (e.g. gets tripped by oscillations)

%% save rejection statistics
erp.arf.totalArtProp = (sum(sum(erp.arf.artifactInd))/(nTrials)).*100; % not counting eye movements
erp.arf.blockingProp = (sum(sum(erp.arf.blocking))/(nTrials)).*100;
erp.arf.noiseProp = (sum(sum(erp.arf.noise))/(nTrials)).*100;
erp.arf.blinkProp =  (sum(sum(erp.arf.blink))/(nTrials)).*100;
erp.arf.eMoveProp = (sum(sum(erp.arf.eMove))/(nTrials)).*100;
erp.arf.driftProp =  (sum(sum(erp.arf.drift))/(nTrials)).*100;
erp.arf.dropoutProp =  (sum(sum(erp.arf.dropout))/(nTrials)).*100;

% print proportion of trials lost due to each kind of artifact.
fprintf('%d \tPercent trials rejected (total) \n', round(erp.arf.totalArtProp));
fprintf('%d \tPercent noise \n', round(erp.arf.noiseProp));
fprintf('%d \tPercent drift \n', round(erp.arf.driftProp));
fprintf('%d \tPercent chan dropout \n', round(erp.arf.dropoutProp));
fprintf('%d \tPercent blocking \n', round(erp.arf.blockingProp));
fprintf('%d \tPercent blinks \n', round(erp.arf.blinkProp));
% fprintf('%d \tPercent eye movements \n', round(erp.arf.eMoveProp));

% plot the proportion of bad trials for each electrode
plotRejectRates(erp);

end
