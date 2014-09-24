function n = sort_names(b)

% Retrieve the names of any OpenSorter sorts

global ttank

ev_code = spike_store_name(b);
sn = 'temp';
n = {};
idx = 0;

access(b);

while ~isempty(sn)
    sn = ttank.GetSortName(ev_code,idx);
    idx = idx + 1;
    n{idx} = sn;
end

n = n(1:end-1);

ttank.ReleaseServer