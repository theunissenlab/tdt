function save_block_spikes(outdir,maxsweep);

% This script reads data from the tank, then saves the spikes as a .mat
% file

%========================================================================
% Get the data out of the tank
%========================================================================

global Fs
errflag = 0;

% Get the trial numbers
[nstims,ntrials,stim_indices] = stim_trial_numbers(Stim_nums(1,:),errflag);

% Get the spiketimes
spike_extract_loop;     %Get the unshuffled spiketimes from the server
get_stimlengths;        %Get the lengths, start and end times for each trial
zspikedata = zero_spiketimes(spikedata,stim_times);     %Ref. spiketimes for each trial to trial start

% Create spikerasters and PSTH for all stims
for jj = 1:nstims
    trial_dur = ceil(Fs*stim_times{jj}.length);
    spikeraster{jj} = spiketimes2raster(...
        zspikedata{jj}.spiketimes,trial_dur,Fs);
    psth{jj} = mean(spikeraster{jj});
end


%========================================================================
% Save output data
%========================================================================

fiatdir(outdir);

% Write the output .mat files
% n.b. Matlab7 does data compression equivalent to the 'sparse' function,
% so saving the entire spike raster takes up no more space than the
% spiketimes would

for jj = 1:nstims
    spikefile(jj).matname = fullfile(outdir,strcat('spike',num2str(jj),'.mat'));
    spikes = spikeraster{jj};
    save(spikefile(jj).matname,'spikes');
end

%EOF