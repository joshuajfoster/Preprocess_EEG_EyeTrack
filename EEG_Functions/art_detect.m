function mark = art_detect(seg)
% check whether segment contains artifacts, marks bad segments with 1 and
% good segments with 0.

if sum(seg) > 0
    mark = 1;
else
    mark = 0;
end
    
