% Script to check if the block contains good data

% Get cell data to check
[cellname,depth,stimset,notes] = parse_blockname(blockname);
[channels,nchannels,msg2] = get_channels(ttank,tankname,blockname,...
    min_spikes);
msg1 = strvcat(msg1,msg2);

% Check that the block contains good data
maxsweep = num_sweeps(stimset);     % Use the old hack to tell us how many sweeps to expect
[nstims,ntrials,msg2,stim_indices] = new_get_blockdata(ttank,tankname,blockname,maxsweep);
msg = strvcat(msg,msg2);