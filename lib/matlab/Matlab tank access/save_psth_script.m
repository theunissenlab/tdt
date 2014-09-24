% This script computes the PSTH for each stim and saves it to a .mat file
% n.b. Matlab7 does data compression equivalent to the 'sparse' function,
% so saving the entire spike raster takes up no more space than the
% spiketimes would

for jj = 1:nstims
    trial_dur = ceil(Fs*stim_times{jj}.length);
    spikeraster{jj} = spiketimes2raster(...
        zspikedata{jj}.spiketimes,trial_dur,Fs);
    psth{jj} = mean(spikeraster{jj});
    spikefile(jj).matname = fullfile(outdir,strcat('spike',num2str(jj),'.mat'));
    spikes = spikeraster{jj};
    save(spikefile(jj).matname,'spikes','ntrials');
end