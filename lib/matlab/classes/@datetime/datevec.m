function dv = datevec(dt)

% Convert datetime object to MATLAB datevec vector

dv = [dt.dateobj.year dt.dateobj.month dt.dateobj.day dt.timeobj.hour ...
    dt.timeobj.minute dt.timeobj.second];