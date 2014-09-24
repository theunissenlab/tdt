function [spikes_out,channels_out,sortcodes_out] = online_sort(spikes_in)

% Separate spikes by sortcode

% Get all channels and sortcodes
channels = unique([spikes_in.channel]);
nchannels = length(channels);
sortcodes = unique([spikes_in.sortcode]);
nsortcodes = length(sortcodes);

% Preallocate output variables
spikes_out = cell(nchannels,nsortcodes);
channels_out = cell(size(spikes_out));
sortcodes_out = cell(size(spikes_out));

% Segregate the spikes
for jj = 1:nchannels
    this_ch = [spikes_in.channel] == channels(jj);
    for kk = 1:nsortcodes
        this_sc = [spikes_in.sortcode] == sortcodes(kk);
        if any(this_ch & this_sc)
            spikes_out{jj,kk} = spikes_in(this_ch & this_sc);
            channels_out{jj,kk} = channels(jj);
            sortcodes_out{jj,kk} = sortcodes(kk);
        end
    end
end

spikes_out = [spikes_out(:)];
channels_out = [channels_out{:}];
sortcodes_out = [sortcodes_out{:}];