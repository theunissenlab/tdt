function [nstims,ntrials,stim_indices,msg] = stim_trial_numbers(...
    stim_index_sequence,errflag,ntrials);

%========================================================================
% This function finds the number of stimuli, indices of the stimuli, and
% number of trials for each. If of the stims have the same number of
% trials, it returns the number of stimuli, number of trials, and an
% ordered list of unique stimulus indices.
%========================================================================

% Errflag defaults to 0 (no error returned)
if ~exist('errflag')
    errflag = 0;
end

% Initialize some variables

msg = '';
stim_indices = unique(stim_index_sequence);
nstims = length(stim_indices);
trials = zeros(1,nstims);

for jj = 1:nstims
    trials(jj) = length(find(stim_index_sequence == stim_indices(jj)));
end

%==========================================================================
% Error checking: check to see whether all trials have the appropriate
% number of repeats. If they don't, errflag determines whether the routine
% generates a warning (errflag = 0) or an error (errflag ~=0).
%==========================================================================

% Check that all stimuli have the same number of repeats
if std(trials)
    msg = sprintf('Not all stimuli have the same number of repeats\n');
    if errflag
        error(msg);
    else
        warning(msg);
    end
    
    if exist('ntrials')
        msg = sprintf('Not all stimuli have %.0f repeats\n',ntrials);
        if errflag
            error(msg);
        else
            warning(msg);
        end

    end
    
    ntrials = trials;
    
else
    ntrials = mean(trials);
end

% For now, generate an error if there is only one trial of data
if ntrials == 1
    msg = sprintf('There is only one repeat\n');
    if errflag
        error(msg);
    else
        warning(msg);
    end
end

% Generate an error if there are no trials -- sometimes a block can be
% generated that will return an empty 1x1 array for stim_epocs; this will
% set ntrials to 0.
if ntrials == 0
    msg = sprintf('There is no data in this block\n');
    if errflag
        error(msg);
    else
        warning(msg);
    end
end