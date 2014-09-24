% Check if data in a block matches previous data for the same cell

% Check if depth matches previous block
depth_match = isequal(depth,cell_data(cell_idx).depth);
if ~depth_match
    msg = strvcat(msg,'Depth does not match previous block');
end

% Check if cell name matches previous block
name_match = strcmpi(cell_data(cell_idx).cellname,cellname);
if ~name_match
    msg = strvcat(msg,'Name does not match previous block');
end

% Check that the channels for this block match the previous ones
existing_channels = [cell_data(cell_idx).channel.index];
channel_match = isequal(existing_channels,channels);
if ~channel_match
    msg = strvcat(msg,...
        'Sort codes for this block do not match codes for previous block');
end

% Get sortcodes for each channel
for channel_idx = 1:nchannels
    channel = channels(channel_idx);
    [sortcodes,nsortcodes,msg2] = get_sortcodes(ttank,tankname,blockname,...
        min_spikes);
    sortcode_match(channel_idx) = isequal(sortcodes,...
        cell_data(cell_idx).channel(channel_idx).sortcodes);
    msg1 = strvcat(msg1,msg2);
end

% Check that the sort codes for each channel match the previous one
if ~all(sortcode_match)
    msg =strvcat(msg,...
        'Sort codes for this block do not match codes for previous block');
end