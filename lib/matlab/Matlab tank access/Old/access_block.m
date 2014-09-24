% This script accesses the named block

% Select the block from the tank
if (invoke(ttank,'SelectBlock',blockname) ~=1)
    err = 'error accessing block'
end

% Get epoc information
invoke(ttank,'ClearEpocIndexing');      %Just to be safe
invoke(ttank,'CreateEpocIndexing');     %Epoch indexing must be set before filtering
Sweep_nums = invoke(ttank,'GetEpocsV','Swep',0,0,maxsweep);     
Stim_nums = invoke(ttank,'GetEpocsV','Frq+',0,0,maxsweep);

% Get the number of trials and stimuli
[nstims,ntrials,stim_indices,msg] = stim_trial_numbers(Stim_nums(1,:),errflag);