function n = get_spike_store_name(b)

% Return all OpenSorter sort names

possible_store_names = {'Spik','Snip','EA__'};
store_names = snip_names(b);
n = 'temp';

for jj = 1:length(store_names)
    hits = strcmp(store_names{jj},possible_store_names);
    if sum(hits) == 1
        n = store_names{jj};
        return
    end
end
error('No spike stores found')