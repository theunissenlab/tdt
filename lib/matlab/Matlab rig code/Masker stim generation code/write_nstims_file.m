function write_nstims_file(Outfiles,Stims,selectivity_args);

ntypes = 3;
n_stims = zeros(1,ntypes);
n_masks = 0;

%% Compute nstims for each set
% Do search sequence
set_idx = 1;
Stim = Stims(set_idx);
n_sets = length(Stim.sets);
for jj = 1:n_sets
    this_n_stims = length(Stim.sets(jj).stims);
    if n_stims(set_idx) == 0
        n_stims(set_idx) = this_n_stims;
    elseif n_stims(set_idx) ~= this_n_stims
        error('All sets from a stim group must have the same number of stims')
    end
end

% Do mask sequence
set_idx = 2;
Stim = Stims(set_idx);
n_sets = length(Stim.sets);
for jj = 1:n_sets
    this_n_stims = length(Stim.sets(jj).stims);
    this_n_masks = length(Stim.sets(jj).maskers);
    
    if n_stims(set_idx) == 0
        n_stims(set_idx) = this_n_stims;
    elseif n_stims(set_idx) ~= this_n_stims
        error('All sets from a stim group must have the same number of stims')
    end
    
    if n_masks == 0
        n_masks = this_n_masks;
    elseif n_masks ~= this_n_masks
        error('All sets from a stim group must have the same number of maskers')
    end
end

n_stims(set_idx) = 3 * this_n_stims;

% Do selectivity sequence
set_idx = 3;
Stim = Stims(set_idx);

n_always = length(Stim.sets(1).stims);
n_new = selectivity_args.n_new;

n_stims(set_idx) = selectivity_args.always_n_reps * n_always + selectivity_args.new_n_reps * n_new;

%% Write output file

fid = fopen(Outfiles.nstims,'w');
fwrite(fid,n_stims,'int32');
fclose(fid);
end