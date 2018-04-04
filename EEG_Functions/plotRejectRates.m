function plotRejectRates(erp)

% index scalp channels
idx = ~ismember(erp.chanLabels,{'HEOG','VEOG','StimTrak'});

%% total rejection rates for each electrode
scalp_arts = (erp.arf.blockingFull(idx,:) | erp.arf.noiseFull(idx,:) | erp.arf.driftFull(idx,:) | erp.arf.dropoutFull(idx,:));
nChans = size(scalp_arts,1);
nTrials = size(scalp_arts,2);

% add a row for the total number of rejected trials (i.e., any one
% electrode is bad)
any_chan_bad = sum(scalp_arts);
any_chan_bad(any_chan_bad>1) = 1; % reset to 1 if more than one chan bad
total_rej = sum(any_chan_bad); 

% enames = erp.chanLabels(idx);
rej = 100*sum(scalp_arts')/nTrials;
rej(nChans+1) = 100*(total_rej/nTrials);

% plot summary
set(gcf, 'Position', [100, 100, 800, 800])
subplot(3,1,1);
bar(rej(1:nChans))
hold on;
bar(nChans+1,rej(nChans+1),'r')
ylim([0 30])
xlim([0 nChans+2])
ylabel('Percent rejected')
xlabel('Electrode number')
xticks(1:nChans)
title('All Artifacts')

%% noise rejection rates for each electrode
scalp_arts = erp.arf.noiseFull(idx,:);
nChans = size(scalp_arts,1);
nTrials = size(scalp_arts,2);

% add a row for the total number of rejected trials (i.e., any one
% electrode is bad)
any_chan_bad = sum(scalp_arts);
any_chan_bad(any_chan_bad>1) = 1; % reset to 1 if more than one chan bad
total_rej = sum(any_chan_bad); 

% enames = erp.chanLabels(idx);
rej = 100*sum(scalp_arts')/nTrials;
rej(nChans+1) = 100*(total_rej/nTrials);

% plot summary
subplot(3,1,2);
bar(rej(1:nChans))
hold on;
bar(nChans+1,rej(nChans+1),'r')
ylim([0 30])
xlim([0 nChans+2])
ylabel('Percent rejected')
xlabel('Electrode number')
xticks(1:nChans)
title('Noise')

%% drift rejection rates for each electrode
scalp_arts = erp.arf.driftFull(idx,:);
nChans = size(scalp_arts,1);
nTrials = size(scalp_arts,2);

% add a row for the total number of rejected trials (i.e., any one
% electrode is bad)
any_chan_bad = sum(scalp_arts);
any_chan_bad(any_chan_bad>1) = 1; % reset to 1 if more than one chan bad
total_rej = sum(any_chan_bad); 

% enames = erp.chanLabels(idx);
rej = 100*sum(scalp_arts')/nTrials;
rej(nChans+1) = 100*(total_rej/nTrials);

% plot summary
subplot(3,1,3);
bar(rej(1:nChans))
hold on;
bar(nChans+1,rej(nChans+1),'r')
ylim([0 30])
xlim([0 nChans+2])
ylabel('Percent rejected')
xlabel('Electrode number')
xticks(1:nChans)
title('Drifts')

%% print electrode list
erp.chanLabels(idx)'
