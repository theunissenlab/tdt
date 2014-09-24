function Make_masker_wav_files_JE(input_directory,n_rand_repeats,...
                               search_args,masker_args,selectivity_args,...
                               call_args,songfilt_args)
                               
%% Save wav files for masker/selectivity protocol

%% Set input defaults

if nargin < 7
    songfilt_args = struct('f_low',250,...
                           'f_high',8000,...
                           'db_att',0);
end

if nargin < 6
   call_args = struct('famcall_n_reps',1,...
                            'strcall_n_reps',1,...
                              'n_strcall',3,...
                              'n_trials',10);
end

if nargin < 5
    selectivity_args = struct('always_n_reps',1,...
                              'new_n_reps',1,...
                              'n_new',3,...
                              'n_trials',10);
end

if nargin < 4
    masker_args = struct('n_trials',10);
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
[Outfiles,Stims,WARNING] = load_protocol(input_directory);
if (WARNING(1)==0)
    disp('WARNING: No files for Srch Protocol');
end
if (WARNING(2)==0)
    disp('WARNING: No files for Mask Protocol, Mask/1/stim can not be empty, put silence wav files if you do not need it');
end
if (WARNING(3)==0)
    disp('WARNING: No files for Selectivity Protocol, Sel/always can not be empty, put silence wav files if you do not need it');
end
if (WARNING(4)==0)
    disp('WARNING: No files for Call Protocol, Call/wavfiles_Familiar_calls can not be empty, put silence wav files if you do not need it');
end

if length(Stims)<4
    return
end

%% Write combined wav files, points and duration files, and protocol

% Write stim.wav and mask.wav files, and points and duration files
Stims = make_wav_files(Outfiles,Stims);
[stim_list,masker_list,Stims] = list_files(Stims);

%% Make sequence files

[n_stims_srch,n_sets_srch] = make_search_sequence(Outfiles,Stims(1),n_rand_repeats,search_args);
[n_stims_mask, n_sets_mask] = make_masker_sequence(Outfiles,Stims(2),n_rand_repeats,masker_args);
[n_stims_sel, n_sets_sel] = make_selectivity_sequence(Outfiles,Stims(3),n_rand_repeats,selectivity_args);
[n_stims_call,n_sets_call] = make_call_sequence(Outfiles,Stims(4),n_rand_repeats,call_args);

%% Write nstims file
n_stims = [n_stims_srch,n_stims_mask,n_stims_sel,n_stims_call];
n_sets = [n_sets_srch,n_sets_mask,n_sets_sel,n_sets_call];
write_n(Outfiles.nstims,n_stims);
write_n(Outfiles.nsets,n_sets);
if (WARNING(3)==1) && (WARNING(5)==0)
    disp('WARNING: No files in Sometimes for Selectivity Protocol, Matlab and TDT run without them, using only Always files');
end
if (WARNING(4)==1) && (WARNING(6)==0)
    disp('WARNING: No files in wavfiles_Stranger_calls for Call Protocol, Matlab and TDT run without them, using only wavfiles_Stranger_calls files');
end
fprintf('The number of different stimuli used in each protocol is:\n Srch:%d\n Mask: %d\n Selectivity: %d\n Call: %d\n',n_stims_srch, n_stims_mask,n_stims_sel,n_stims_call);
fprintf('The number of different sets of stimuli in each protocol is: \n Srch:%d\n Mask: %d\n Selectivity: %d\n Call: %d\n',n_sets_srch,n_sets_mask,n_sets_sel,n_sets_call);
fprintf('DO NOT USE SET VALUES SUPERIOR TO THOSE SPECIFIED ABOVE IN OPEN EX!!!!');
fprintf('These values are written in nSets.f32 and nStims.f32');
fprintf('You can read the content of these files using the command readf32.m under Matlab');
