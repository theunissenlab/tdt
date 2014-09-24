function d = starttime(b)

% Get starttime for a tdt block object from server

global ttank
access(b);

t = ttank.CurBlockStartTime;
d = datetime(ttank.FancyTime(t,'D/O/Y H:M:S.U'));