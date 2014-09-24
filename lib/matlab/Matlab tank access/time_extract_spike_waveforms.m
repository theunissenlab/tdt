function stims = time_extract_spike_waveforms(actxname,tankname,...
    blockname,nstims,ntrials,stim_times);

% This script gathers spike arrival times for ntrials repeats of nstims
% stimuli

% Default to gather spikes from all channels, all sort codes
if ~exist('channels','var')
    channels = 0;
end
if ~exist('sortcode','var')
    sortcodes = 0;
end

% Compute a few variables
nchannels = length(channels);
nsortcodes = length(sortcodes);

% Connect to the server, select tank and block
block_access;

% Removed because I'm not doing epoc filtering RCM 2/27/06
%% Define some constants
%StimCode = actxname.StringToEvCode('Frq+');
%SweepCode = actxname.StringToEvCode('Swep');

% Loop over ntrials repeats of the stimuli
for jj = 1:ntrials
    %start_sweep = nstims*(jj-1) +1 ;     %Offset for each block of stimuli
    %stop_sweep = start_sweep + nstims -1;    
    
    % For each trial, loop over all stimuli
    for kk = 1:nstims
        start_time = stim_times{kk}.start(jj);
        stop_time = stim_times{kk}.end(jj);
        
        % For each stim loop over all channels and sortcodes
        for mm = 1:nchannels
            for nn = 1:nsortcodes

                %% Filter for spikes only from occurrence jj of stim kk
                %actxname.SetFilter(StimCode,69,stim_indices(kk),0);
                %actxname.SetFilter(SweepCode,73,start_sweep,stop_sweep);

                % Recover the spike arrival times for the stimulus
                %nspikes = actxname.ReadEventsV(10000,'Spik',1,0,0,0,'FILTERED');
                nspikes = actxname.ReadEventsV(10000,'Spik',...
                    channels(nn),sortcodes(mm),start_time,stop_time,'ALL');
                spikedata{kk}.nspikes(jj) = nspikes;
                spikedata{kk}.spiketimes{jj} = actxname.ParseEvInfoV(0,nspikes,6);

                %% Clear the filters for next sweep
                %actxname.ResetFilters;
            end
        end
    end
end

actxname.ReleaseServer;