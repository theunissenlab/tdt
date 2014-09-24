function spikeraster = spiketimes2raster(spiketimes,trial_dur,Fs)

%=====================================================================
% This function takes inputs of spike times in cell format (each cell
% being one trial) and transforms them into spike counts in bins of
% width 1/Fs, returned as a raster matrix with each row being one
% trial and each column being one time bin.
%
% Some possible issues:
% 1. The first timepoint is t=0, not t=1/Fs
% 2. The last timepoint is at ceil(trial_dur*Fs), not round(trial_dur*Fs)
% 3. trial_dur is given in a basis of 1/Fs
%=====================================================================

ntrials = length(spiketimes);

%Create a blank matrix for the raster   
bins = (1:trial_dur)/Fs;
spikeraster = zeros(ntrials,trial_dur);

%Create a matrix of arrival times

for jj = 1:ntrials
    spikeraster(jj,:) = hist(spiketimes{jj},bins);
end