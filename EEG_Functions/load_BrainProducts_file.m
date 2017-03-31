function eeg = load_BrainProducts_file(data_path,filename)

fprintf('Importing Data\n');

%% Read the header file
CONF = readbvconf(data_path, filename); %channel info etc.
%% load in the EEG file
[EEG, com]=pop_loadbv(data_path, filename);  % requires EEG lab.
%% Rename things so we have them to use later!!
EEGdata = EEG.data;
eeg.data = EEGdata; % changed from eeg to erp to match josh's naming schema
eeg.srate = EEG.srate;
eeg.nChans = size(EEGdata,1); % Number of Channels
eeg.nArfChans = size(EEGdata,1) - 1; % don't count the stim trak as a channel to artifact reject ! 
eeg.pnts = size(EEGdata,2); % number of overall sample data points
eeg.rateAcq = 1000/EEG.srate; % 2 ms= Rate of Data Acquisition
eeg.event = struct( 'type', { EEG.event.type }, 'latency', {EEG.event.latency});
eeg.eventTimes = round(cell2mat({eeg.event.latency})); % Event Times

eeg.headerInfo = CONF.comment;

for c = 1:eeg.nChans % loop through channels and get labels and coordintates % JJF: I added this
    
    % grab channel labels
    label = strsplit(CONF.channelinfos{c},',');
    eeg.chanLabels{c} = label{1};
       
    % grab channel coordinates
    coordinates = strsplit(CONF.coordinates{c},',');
    eeg.chanCoordinates{c} = [str2double(coordinates{1}) str2double(coordinates{2}) str2double(coordinates{3})];

end                            
