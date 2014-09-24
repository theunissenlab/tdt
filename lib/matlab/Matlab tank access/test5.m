% Test script #5

% Define the unit and stim to get data from
cell_idx = 19;
unit_idx = 2;
stim_idx = 3;

% Pull up subsets of the database to work with
Ccell = cell_data(cell_idx);
unit = Ccell.unit(unit_idx);
stim = Ccell.stim(stim_idx);

% Find the block number and name
block_idx = stim.block;
block = Ccell.block(block_idx);

% Find stim number for block
stim_number = stim.stim_idx;

% Pull up block
tankname = block.tankname;
blockname = block.name;

% Old hack to get maxsweep
stimset = stim.stimset;
maxsweep = num_sweeps(stimset);

[nstims,ntrials,msg,stim_indices,stim_epocs,silence_epocs] = ...
    get_blockdata(actxname,tankname,blockname,maxsweep);
[stim_times,msg] = cal_stim_times(stim_epocs,stim_number);