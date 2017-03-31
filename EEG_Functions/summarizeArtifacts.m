function artifacts = summarizeArtifacts(artifactMatrix)
% create artifact marker that codes the presence of absence of artifacts
% 1 = there was an artifact at one of more (inspected) electrodes
% 0 = there were no artifacts at any electrode
%
% Inputs:
% artMatrix: matrix of artifacts (electrodes x trials)
% where: 0 = clean, 1 = artifact, nan = not checked
%
% Output:
% artifacts: vector (nTrials long) indicating which trials contains
% artifacts (at any electrode that was inspected)

artSum = squeeze(nansum(artifactMatrix,1));
nn = 0;
artifacts = ~ismember(artSum,nn);

end

