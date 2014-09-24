function [n_call,n_sets] = make_call_sequence(Outfiles,Call,n_rand_repeats,args)

%%write sequence for call files
l_sets = length(Call.sets);
if l_sets>1
    familiar = Call.sets(1);
    stranger = Call.sets(2);
    n_sets = floor(length(stranger.stim_indices)/args.n_strcall);
    set_seqs = cell(1,n_sets);

    for set_idx = 1:n_sets
        % Get indices for stranger stims
        str = stranger.stim_indices((set_idx -1) * args.n_strcall + (1:args.n_strcall));
    
        % Combine new and always indices for each trial
        indices = [repmat(familiar.stim_indices,1,args.familiar_n_reps),...
               repmat(str,1,args.strcall_n_reps)];
    
        % Make random sequences for this
        set_seqs{set_idx} = random_sequence(indices,args.n_trials,n_rand_repeats);
    end
    n_call = length(indices);
    sequence = horzcat(set_seqs{:});
else
    familiar = Call.sets(1);
    sequence = random_sequence(familiar.stim_indices,args.n_trials,n_rand_repeats);
    n_call = length(familiar.stim_indices);
    n_sets = l_sets;
end

%% Write to file

fid = fopen(Outfiles.callseq,'w');
fwrite(fid,sequence,'int32');
fclose(fid);

