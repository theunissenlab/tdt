function maxsweep = num_sweeps(stimset)

% This is necessary for now to set the number of stimuli; in future, the
% block data should have *something* about this

if strncmpi(stimset,'STRF1',5)
    maxsweep = 50;
elseif strncmpi(stimset,'STRF2',5)
    maxsweep = 40;
else
    maxsweep = 50;
end