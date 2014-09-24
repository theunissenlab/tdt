function [background_rates,spikedata] = cal_background_rate(actxname,tankname,...
    blockname,nstims,ntrials,silence_epocs,channel,sortcode);

% This script gathers spike arrival times for ntrials repeats of nstims
% stimuli
% 'silence_times' must be a 1xnstims cell array, with each cell
% being a 1x1 struct with fields 'start' and 'end' corresponding to the
% start and end times for silences around each stim.

% Calculate some variables
types = fieldnames(silence_epocs);
ntypes = length(types);

% Find start and end times for each silence interval
for jj = 1:ntypes
    silence_times.(types{jj}) = cal_stimlengths(...
        silence_epocs.(types{jj}),nstims,ntrials);
end

% Connect to the server, select tank and block
block_access;

% Loop over ntrials repeats of the stimuli

%==========================================================================
% Loop over all trials, stims, channels, sort codes, and over the start and
% end epocs
% Query tank server for number of spikes in each background epoc and the
% duration of the epoc
%==========================================================================
for this_stim = 1:nstims
    for this_trial = 1:ntrials(this_stim)
        for pp = 1:ntypes
            this_type = types{pp};

            start = silence_times.(this_type){this_stim}.start(this_trial);
            stop = silence_times.(this_type){this_stim}.end(this_trial);
            duration = stop-start;

            % Recover the number of spikes in the channel and
            % sortcode
            nspikes = actxname.ReadEventsV(10000,'Spik',...
                channel,sortcode,start,stop,'ALL');
            spikedata{this_stim}.(this_type).nspikes(this_trial) = nspikes;
            spikedata{this_stim}.(this_type).duration(this_trial) = duration;
        end
    end
end

actxname.ReleaseServer;

%==========================================================================
% Calculate background rates from spike data
%==========================================================================

for this_stim = 1:nstims        
    %Initialize arrays for calculation of background rate
    bkgnd_num = zeros(1,ntrials(this_stim));
    bkgnd_dur = zeros(1,ntrials(this_stim));

    for jj = 1:ntypes
        this_type = types{jj};
        bkgnd_num = bkgnd_num + spikedata{this_stim}.(...
            this_type).nspikes;
        bkgnd_dur = bkgnd_dur + spikedata{this_stim}.(...
            this_type).duration;
    end

    background_rates{this_stim} = bkgnd_num./bkgnd_dur;
end
            