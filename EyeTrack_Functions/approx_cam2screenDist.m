function [cam2screenDist] = approx_cam2screenDist(viewDist,head2camDist)
% if eyetracker-to-monitor distance wasn't measured, we can estimate it
% based on the viewing distance (subject's eye to monitor) and the
% head-to-eye tracker distance at the start of the session. That's what
% this function does!
%
% Inputs:
% viewDist: the viewing distance (i.e., monitor to subjects eyes, in cm)
% head2camDist: the vector of distances from eye tracker to subject's head
%
% Output:
% cam2screenDist: the estimated distance of the eye tracker to the monitor

% take the first 1000 sample of the 
head2cam = head2camDist(1:1000);

% check that nothing funny happened during these initial distance
% measurements by calculating the standard deviation. 
sd = std(head2cam);

% if the sd is greater than 1 cm, throw an error because their might be a
% problem
if sd > 1
    error('Looks like something funny happened during the first 1000 samples')
end

% if there are no problems, calculate the mean head2cam dist
initial_head2cam = mean(head2cam);

% estimate cam2screen dist by subtracing head2cam from total viewDist
cam2screenDist = viewDist - initial_head2cam;

end

