function [n_sel,n_sets] = make_selectivity_sequence(Outfiles,Sel,n_rand_repeats,args);

%%
l_sets = length(Sel.sets);
if l_sets>1
    always = Sel.sets(1);
    sometimes = Sel.sets(2);

    n_sets = floor(length(sometimes.stim_indices)/args.n_new);
    set_seqs = cell(1,n_sets);

    for set_idx = 1:n_sets
        % Get indices for new stims
        new = sometimes.stim_indices((set_idx -1) * args.n_new + (1:args.n_new));
    
        % Combine new and always indices for each trial
        indices = [repmat(always.stim_indices,1,args.always_n_reps),...
               repmat(new,1,args.new_n_reps)];
    
        % Make random sequences for this
        set_seqs{set_idx} = random_sequence(indices,args.n_trials,n_rand_repeats);
    end

    n_sel = length(indices);
    sequence = horzcat(set_seqs{:});
else
    always = Call.sets(1);
    sequence = random_sequence(always.stim_indices,args.n_trials,n_rand_repeats);
    n_sel = length(always.stim_indices);
    n_sets = l_sets;
end

%% Write to file

fid = fopen(Outfiles.selseq,'w');
fwrite(fid,sequence,'int32');
fclose(fid);