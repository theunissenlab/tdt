function spikedata = new_time_extract_stim_spikes(actxname,tankname,...
    blockname,ntrials,stim_times,channel,sortcode,get_waveforms)

% Gathers spike arrival times for ntrials repeats of one stimulus
% Updated to return waveforms as well RCM 9/20/06

%==========================================================================
% Initialize some variables
%==========================================================================

% Default to gather spikes from all channels, all sort codes
if ~exist('channel','var')
    channel = 0;
end
if ~exist('sortcode','var')
    sortcode = 0;
end
if ~exist('get_waveforms','var')
    get_waveforms = 0;
end

%==========================================================================
% Initialize some variables
%==========================================================================

% If the waveform data is not requested, the tank server will run better
% if passed the option parameter "NODATA" so that it doesn't load up the
% data
if get_waveforms
    retrieval_options = 'ALL';
else
    retrieval_options = 'ALL,NODATA';
end


% Connect to the server, select tank and block
block_access;

% Loop over ntrials repeats of the stimuli
for jj = 1:ntrials
    %start_sweep = nstims*(jj-1) +1 ;     %Offset for each block of stimuli
    %stop_sweep = start_sweep + nstims -1;    
    
    start_time = stim_times.start(jj);
    stop_time = stim_times.end(jj);

    % Recover the spike arrival times for the stimulus
    %nspikes = actxname.ReadEventsV(10000,'Spik',1,0,0,0,'FILTERED');
    nspikes = actxname.ReadEventsV(10000,'Spik',channel,sortcode,...
        start_time,stop_time,retrieval_options);
    spikedata.nspikes(jj) = nspikes;
    spikedata.spiketimes{jj} = actxname.ParseEvInfoV(0,nspikes,6);
    if get_waveforms
        spikedata.waveforms{jj} = actxname.ParseEvV(0,nspikes);
    end

    % Clear the filters for next sweep
    actxname.ResetFilters;
end

actxname.ReleaseServer;