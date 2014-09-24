function [nstims,ntrials,stim_indices,stim_epocs,msg] = get_blockdata(actxname,...
    tankname,blockname,maxsweep);

% Connect to the server, select tank and block
block_access;

% Get epoc information
actxname.ClearEpocIndexing;      %Just to be safe
actxname.CreateEpocIndexing;     %Epoch indexing must be set before filtering
sweep_epocs = actxname.GetEpocsV('Swep',0,0,maxsweep);     
stim_epocs = actxname.GetEpocsV('Frq+',0,0,maxsweep);
msg1 = check_timestamps(stim_epocs);     %Check that epoc timestamps are sensible
actxname.ReleaseServer;

% Compute the number of trials and stimuli
[nstims,ntrials,stim_indices,msg2] = stim_trial_numbers(stim_epocs(1,:),0);

% Create an error message, giving msg1 priority
if isempty(msg1)
    if isempty(msg2)
        msg = '';
    else
        msg = msg2;
    end
else
    msg = msg1;
end