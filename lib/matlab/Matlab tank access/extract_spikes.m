function spikedata = extract_spikes(actxname,tankname,blockname,nstims,...
    ntrials,stim_indices);

% This script gathers spike arrival times for ntrials repeats of nstims
% stimuli

% Connect to the server, select tank and block
block_access;

% Define some constants
StimCode = actxname.StringToEvCode('Frq+');
SweepCode = actxname.StringToEvCode('Swep');

% Loop over ntrials repeats of the stimuli
for jj = 1:ntrials
    start_sweep = nstims*(jj-1) +1 ;     %Offset for each block of stimuli
    stop_sweep = start_sweep + nstims -1;
    
    % For each trial, loop over all stimuli
    for kk = 1:nstims
        
        % Filter for spikes only from occurrence jj of stim kk
        actxname.SetFilter(StimCode,69,stim_indices(kk),0);
        actxname.SetFilter(SweepCode,73,start_sweep,stop_sweep);

        % Recover the spike arrival times for the stimulus
        nspikes = actxname.ReadEventsV(10000,'Spik',1,0,0,0,'FILTERED');
        spikedata{kk}.nspikes(jj) = nspikes;
        spikedata{kk}.spiketimes{jj} = actxname.ParseEvInfoV(0,nspikes,6);
        
        % Clear the filters for next sweep
        actxname.ResetFilters;
    end
end

actxname.ReleaseServer;