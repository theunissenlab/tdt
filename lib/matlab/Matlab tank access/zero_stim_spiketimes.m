function zeroed_spikedata = zero_stim_spiketimes(spikedata,stim_times)

%===================================================================
% This function uses the data in stim_times to get the zero times
% for each trial (stim_times is a cell array with each cell being
% one trial, and data field 'start' containing a vector of the start
% times for each trial).
%===================================================================

ntrials = length(spikedata.spiketimes);
zeroed_spikedata = spikedata;

for kk = 1:ntrials
    zeroed_spikedata.spiketimes{kk} = spikedata.spiketimes{kk}...
        -stim_times.start(kk);
end