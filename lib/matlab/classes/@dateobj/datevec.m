function dv = datevec(d)

% Convert datetime object to MATLAB datevec vector

dv = [d.year d.month d.day 0 0 0];