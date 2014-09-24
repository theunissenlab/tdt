function [msg,epocs] = check_all_timestamps(epocs,epoc_names)

% Check for any corrupt timestamp data.
% This function does so by comparing all epoc timestamps to be used.
% 'epocs' is a 4 x n_epocs x n_epoc_names. Here n_epocs is the total number
% of presentations of a stimulus, and n_epoc_names is the number of epocs
% per stimulus trial (e.g, 3 for a prestimulus silence, a stimulus
% presentation, and a poststimulus silence).
%
% This checks two criteria for correctness: first, that the stim
% number is the same for all epocs in a trial; second, that all of the
% timestamps progress logically within a trial; third, that the starting
% and ending timestamps of each trial progress logically.
%
% Currently, this function only excises epocs with corrupt data. Future
% versions may attempt to fix the data.
% 10/13/06 RCM

msg = '';
if ~exist('epoc_name','var')
    epoc_names = {'Pre+','Frq+','Pos+'};
end

%==========================================================================
% Check that the stimulus numbers are the same within each trial.
% Return a list of trials for which this is not the case.
%==========================================================================

epoc_stim_numbers = squeeze(epocs(1,:,:))';
stimnumber_match = ~diff(epoc_stim_numbers,1,1);
all_stimnumber_match = all(stimnumber_match,1);
if ~all(all_stimnumber_match)
    msg = strvcat(msg,'There are errors in the epoc indexing');
end

% For now, just remove the bad epocs
epocs = epocs(:,all_stimnumber_match,:);

%==========================================================================
% Check that all timestamps proceed correctly
%==========================================================================

% Create a matrix with all times for each epoc
n_epocs = size(epocs,3);
n_trials = size(epocs,2);
all_times = zeros(n_epocs,n_trials);
for epoc_idx = 1:n_epocs
    start = 2*epoc_idx-1;
    stop = start+1;
    all_times(start:stop,:) = epocs(2:3,:,epoc_idx);
end

% Check that the timestamps for each epoc progress in order
time_offset = diff(all_times(:));
n_timesteps = 2*n_epocs-1;
times_ordered = time_offset >=0;
bad_indices = find(~times_ordered);
if any(bad_indices)
    msg = strvcat(msg,'There are timestamp sequence errors');
end
%bad_timesteps = rem(bad_indices,n_timesteps);
%bad_epocs = (bad_indices-bad_timesteps)/n_timesteps;
bad_epocs = ceil(bad_indices/(2*n_epocs));

% For now, just remove the bad epocs
epocs(:,bad_epocs,:) = [];

%% Correct the bad timestamps
%n_bad_timestamps = length(bad_indices);
%for error_idx = 1:n_bad_timestamps
%    bad_timestep = bad_timesteps(error_idx);
%    bad_epoc = bad_epocs(error_idx);
%    
%    % Collect neighboring timestamps
%    start = bad_timestep;
%    if bad_timestep < 2*n_epocs-1
%        stop = bad_timestep+1
%    else
