function SamplingRate = getSamplingRate(eye)
% get sampling rate from eye.RECORDINGS. Check that sampling rate didn't
% change throughout the experiment.

sRate = [eye.RECORDINGS(:).('sample_rate')];

% throw an error if the sampling rate changed during the expeirment
if length(unique(sRate)) > 1
    error('The sampling rate changed during the experiment.')
end
    
SamplingRate = sRate(1); % just want one value that reflects the entire session


