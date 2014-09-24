% Script to plot the spikes from files

stimfiledir = 'C:\Documents and Settings\Latemodel\My Documents\Grad School\Theunissen lab\Stims\fMRI stims\STRF1';
stimfiles = dir(fullfile(stimfiledir,'*.mat'));

spikefiledir = pwd;
spikefiles = dir(fullfile(spikefiledir,'spike*.mat'));

nfiles = length(stimfiles);

freqs = [250 8000 250];

if nfiles-length(spikefiles)
    disp(sprintf('There are %.0u stim files and %.0u spike files. Exiting.',nfiles,length(stimfiles)));
end

for jj = 1:nfiles
    load(fullfile(spikefiledir,spikefiles(jj).name));
    load(fullfile(stimfiledir,stimfiles(jj).name));
    plot_TDT(outSpectrum,spikes(:,2:end-2),freqs,twindow);
end