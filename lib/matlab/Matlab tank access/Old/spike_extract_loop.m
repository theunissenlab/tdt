function spikedata = extract_spikes(actxname,tankname,blockname,nstims,...
    ntrials);

% This script gathers spike arrival times for ntrials repeats of nstims
% stimuli

% Connect to the server, select tank and block
block_access;

% Define some constants
StimCode = ttank.StringToEvCode('Frq+');
SweepCode = ttank.StringToEvCode('Swep');

% Loop over ntrials repeats of the stimuli
for jj = 1:ntrials
    start_sweep = nstims*(jj-1) +1 ;     %Offset for each block of stimuli
    stop_sweep = start_sweep + nstims -1;
    
    % For each trial, loop over all stimuli
    for kk = 1:nstims
        
        % Filter for spikes only from occurrence jj of stim kk
        ttank.SetFilter(StimCode,69,stim_indices(kk),0);
        ttank.SetFilter(SweepCode,73,start_sweep,stop_sweep);

        % Recover the spike arrival times for the stimulus
        nspikes = ttank.ReadEventsV(10000,'Spik',1,0,0,0,'FILTERED');
        spikedata{kk}.nspikes(jj) = nspikes;
        spikedata{kk}.spiketimes{jj} = ttank.ParseEvInfoV(0,nspikes,6);
        
        % Clear the filters for next sweep
        ttank.ResetFilters;
    end
end

ttank.ReleaseServer;