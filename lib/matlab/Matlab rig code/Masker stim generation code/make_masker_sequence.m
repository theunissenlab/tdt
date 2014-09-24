function [n_mask, n_sets] = make_masker_sequence(Outfiles,Mask,n_rand_repeats,args)

%%

n_sets = length(Mask.sets);
sequences = cell(1,n_sets);

n_mask = 0;
for jj = 1:n_sets
    set = Mask.sets(jj);
    sequences{jj} = masker_random_sequence({set.stim_indices,...,
                                            set.mask_indices},...
                                            args.n_trials,...
                                            n_rand_repeats);
n_mask = n_mask + length(sequences{jj})/n_rand_repeats/args.n_trials;
end

full_sequence = horzcat(sequences{:});

%% Write stim sequence file
fid = fopen(Outfiles.maskstimseq,'w');
fwrite(fid,full_sequence(1,:),'int32');
fclose(fid);

%% Write masker sequence file
fid = fopen(Outfiles.maskseq,'w');
fwrite(fid,full_sequence(2,:),'int32');
fclose(fid);