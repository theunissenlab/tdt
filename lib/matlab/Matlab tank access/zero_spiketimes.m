function zeroed_spikedata = zero_spiketimes(spikedata,stim_times)

%===================================================================
% This function uses the data in stim_times to get the zero times
% for each trial (stim_times is a cell array with each cell being
% one trial, and data field 'start' containing a vector of the start
% times for each trial).
%===================================================================

nstims = length(spikedata);
ntrials = length(spikedata{1}.spiketimes);
zeroed_spikedata = spikedata;

for jj = 1:nstims
    for kk = 1:ntrials
        zeroed_spikedata{jj}.spiketimes{kk} = spikedata{jj}.spiketimes{kk}...
            -stim_times{jj}.start(kk);
    end
end