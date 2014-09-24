function make_masker_wav_files(input_directory,n_rand_repeats,...
                               search_args,masker_args,selectivity_args,...
                               songfilt_args)
                               
%% Save wav files for masker/selectivity protocol

%% Set input defaults

if nargin < 6
    songfilt_args = struct('f_low',250,...
                           'f_high',8000,...
                           'db_att',0);
end

if nargin < 5
    selectivity_args = struct('always_n_reps',1,...
                              'new_n_reps',1,...
                              'n_new',3,...
                              'n_trials',10);
end

if nargin < 4
    masker_args = struct('n_trials',4);
end

if nargin < 3
    search_args = struct('n_trials',10); % N.b. this number is only for generating the random sequence
end

if nargin < 2
    n_rand_repeats = 1000;
end

if nargin < 1
    input_directory = pwd;
end

%% Get protocol from input directory

% Find stim files and sets
[Outfiles,Stims] = load_protocol(input_directory);

%% Write combined wav files, points and duration files, and protocol

% Write stim.wav and mask.wav files, and points and duration files
Stims = make_wav_files(Outfiles,Stims);
[stim_list,masker_list,Stims] = list_files(Stims);

%% Make sequence files

n_srch = make_search_sequence(Outfiles,Stims(1),n_rand_repeats,search_args);
n_mask = make_masker_sequence(Outfiles,Stims(2),n_rand_repeats,masker_args);
n_sel = make_selectivity_sequence(Outfiles,Stims(3),n_rand_repeats,selectivity_args);

%% Write nstims file
n_stims = [n_srch,n_mask,n_sel];
write_n_stims(Outfiles,n_stims);