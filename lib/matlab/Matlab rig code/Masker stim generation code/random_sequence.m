function sequence = random_sequence(stim_numbers,n_trials,n_rand_repeats)

% Put randperm.m on the path
randpath = fullfile(toolboxdir('matlab'),'randfun');
addpath(randpath);

n_stims = length(stim_numbers);
sequence = zeros(1,n_trials * n_stims * n_rand_repeats);

for jj = 1:n_rand_repeats
    for kk = 1:n_trials
        order = randperm(n_stims);
        output_range = (jj-1)*n_trials*n_stims +...
            (kk-1)*n_stims + [1:n_stims];
        sequence(output_range) = stim_numbers(order);
    end
end