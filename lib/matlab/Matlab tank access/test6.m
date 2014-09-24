% test get_background_rate

cell_idx = 21;
Ccell = cell_data(cell_idx);

unit_idx = 2;
unit = Ccell.unit(unit_idx);

channel = unit.channel;
sortcode = unit.sortcode;

nblocks = Ccell.nblocks;

for block_idx = 1:nblocks
    block = Ccell.block(block_idx);

    tankname = block.tankname;
    blockname = block.name;
    
    stim_indices = stim_indices_from_db(Ccell,block_idx);
    ntrials = [Ccell.stim(stim_indices).ntrials];
    
    % old hack to get nsweeps
    stimset = Ccell.stimset(block_idx).name;
    maxsweep = num_sweeps(stimset);
    
    [nstims,foo,foobar,fubar,stim_epocs,silence_epocs] = ...
        get_blockdata(actxname,tankname,blockname,maxsweep);
    clear foo foobar fubar
    
    background_rates = cal_background_rate(actxname,tankname,...
        blockname,nstims,ntrials,silence_epocs,channel,sortcode);
    
    for stim_idx = 1:nstims
        this_stim = stim_indices(stim_idx);
        unit.spike.background{this_stim} = background_rates{stim_idx};
    end
        
end 