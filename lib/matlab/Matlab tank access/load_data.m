% Script to plot the spikes from files

stimfiledir = 'C:\Documents and Settings\Latemodel\My Documents\Grad School\Theunissen lab\Stims\fMRI stims\STRF1';
stimfiles = dir(fullfile(stimfiledir,'*.mat'));

spikefiledir = pwd;
spikefiles = dir(fullfile(spikefiledir,'spike*.mat'));

nfiles = length(stimfiles);

if nfiles-length(spikefiles)
    disp(sprintf('There are %.0u stim files and %.0u spike files. Exiting.',nfiles,length(stimfiles)));
end

for jj = 1:nfiles
    load(spikefiles(jj).name);
    load(stimfiles(jj).name);
    figure;
    plot_TDT(outSpectrum,spikes,[],twindow);
end