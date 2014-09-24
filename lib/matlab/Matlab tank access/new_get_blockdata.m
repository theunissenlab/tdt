function [nstims,ntrials,msg,stim_indices,stim_epocs,silence_epocs] = ...
    get_blockdata(actxname,tankname,blockname,maxsweep);

%==========================================================================
% Get times for all stimuli in a block from the tank server
% 'nstims' is the number of different stimuli, determined from the stim
% index (epoc "Frq+")in the tank.
% 'ntrials' is 1xnstims vector with the number of repeats for each stimulus
% stim_indices is a 1xnstims vector with the stim indices for each stimulus
% (as they appear in the tank).
% 'stim_epocs' is the timestamp data for the stimuli, in the format
% returned by the tank server command 'GetEpocsV': a 4-row array, with one
% column for each trial, in order. Row 1 is the stim index as it appears in
% the tank; row 2 is the timestamp of the start of the trial; row 3 is the
% timestamp of the end of the trial; row 4 is the filter status, and is not
% used here.
% 'silence_epocs' is a struct with 2 fields: 'pre', and 'post'. Each
% contains an array in the same format as 'stim_epocs', but containing the
% times for the silent periods immediately preceding and following the
% stimulus presentation, respectively.
% 'msg' returns descriptive error messages.
%
% Added "fix_stim_epocs" functionality 9/25/06 RCM
% Obsoleted "maxsweep" functionality 10/26/06 RCM
%==========================================================================

% Obsoleted 'maxsweep' function because it is no longer needed and was
% causing function to miss records for larger stimsets
% n.b. leaving the argument in the function call for backwards
% compatibility
maxsweep = 1000;

% Connect to the server, select tank and block
block_access;

% Get epoc information
actxname.ClearEpocIndexing;      %Just to be safe
actxname.CreateEpocIndexing;     %Epoch indexing must be set before filtering
% sweep_epocs = actxname.GetEpocsV('Swep',0,0,maxsweep);     
stim_epocs = actxname.GetEpocsV('Frq+',0,0,maxsweep);
silence_epocs.pre = actxname.GetEpocsV('Pre+',0,0,maxsweep);
silence_epocs.post = actxname.GetEpocsV('Pos+',0,0,maxsweep);
msg = check_timestamps(stim_epocs,'Frq+');     %Check that epoc timestamps are sensible
msg = strvcat(msg,check_timestamps(silence_epocs.pre,'Pre+'));
msg = strvcat(msg,check_timestamps(silence_epocs.post,'Pos+'));
actxname.ReleaseServer;

if msg
    [stim_epocs,silence_epocs] = fix_stim_epocs(stim_epocs,...
        silence_epocs,actxname,blockname,tankname);
end

% Compute the number of trials and stimuli
stim_numbers = stim_epocs(1,:);          %stim numbers are in first row of stim_epocs
[nstims,ntrials,stim_indices,msg1] = stim_trial_numbers(stim_numbers,0);
% [nstims,ntrials,stim_indices,msg2] = stim_trial_numbers(stim_epocs(1,:),0);

% Removed this block to streamline error handling RCM 2/27/06
%% Create an error message, giving msg1 priority
%if isempty(msg1)
%    if isempty(msg2)
%        msg = '';
%    else
%        msg = msg2;
%    end
%else
%    msg = msg1;
%end

msg = strvcat(msg,msg1);