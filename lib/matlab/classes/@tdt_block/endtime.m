function d = endtime(b)

% Get starttime for a tdt block object from server

global ttank
access(b);

t = ttank.CurBlockStopTime;
d = datetime(ttank.FancyTime(t,'D/O/Y H:M:S.U'));