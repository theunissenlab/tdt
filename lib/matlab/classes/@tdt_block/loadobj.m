function b = loadobj(t)

% loadobj for tdt_block class

if isa(t,'tdt_block')
    b = t;
else % Old class definition
    t.starttime = datetime(0);
    t.endtime = datetime(0);
    b = class(t,'tdt_block');
end