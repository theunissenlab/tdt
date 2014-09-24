function [n_stims,n_sets] = make_search_sequence(Outfiles,Srch,n_rand_repeats,args)

%% Write a sequence for search files

set = Srch.sets(1);
n_sets = length(Srch.sets);

sequence = random_sequence(set.stim_indices,args.n_trials,n_rand_repeats);
fid = fopen(Outfiles.searchseq,'w');
fwrite(fid,sequence,'int32');
fclose(fid);

n_stims = length(set.stim_indices);
