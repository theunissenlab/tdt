function plot_stimresp(stim,spikes,freqs,tsmooth)

%========================================================================
% Modification of FET's plot_dump1.m script
% This function plots a spectrogram of the input arguments, a raster plot
% of the spikes, and a smoothed psth
%
% RCM 11/9/05
%========================================================================

%========================================================================
% Set some variables
%========================================================================

% Default smoothing window for the psth
if ~exist('tsmooth','var')
    tsmooth = 31;
end

% Default frequency axis
if ((exist('freqs') ~=1)|isempty(freqs))
    freqs = [250,8000,250];
end

% Frequency names used in FET's old script
f_low = freqs(1);
f_high = freqs(2);
f_width = freqs(3);

% Compute some useful variables
ntrials = size(spikes,1);
f= f_low+f_width/2:f_width:f_high;
tstim = size(stim,2);
tspike = size(spikes,2);
tend = tspike;
start = ceil(tsmooth/2);        % For plotting the smoothed psth
stop = floor(tsmooth/2);        % ditto

%========================================================================
% Plot a spectrogram of the stimulus
%========================================================================

h=figure;
set(h,'PaperPosition',[0.25 2.5 3.75 8]);
t=1:tstim;
maxstim = max(max(stim));
minstim = min(min(stim));

subplot(3,1,1);
imagesc(t,f,stim);
%imagesc(t,f,-stim);
%colormap(bone);
axis([1 tend f_low f_high]);
axis xy;
%caxis([-0.95*(maxstim-minstim)-minstim -0.78*(maxstim-minstim)-minstim]);

%========================================================================
% Plot a raster of the spikes
%========================================================================

t=1:tspike;
if ( ntrials > 50 ) 
	nplot=50
else
	nplot = ntrials;
end
for i=1:nplot
	subplot('position',[0.13 0.66-i*(0.3/nplot) 0.775 (1-0.05)*0.3/nplot]);
	hold;
	for j=1:tspike
		if (spikes(i,j) == 1 )
			plot([t(j) t(j)],[0 1],'k');
		end
	end
	axis([1 tend 0 1]);
	axis off;
end

%========================================================================
% Plot a psth smoothed by twindow
%========================================================================

subplot(3,1,3)
wind1 = hanning(tsmooth)/sum(hanning(tsmooth));
spikeavg = 1000.0*mean(spikes);
svagsm=conv(spikeavg,wind1);
%plot(t,svagsm(16:length(svagsm)-15),'k');
plot(t,svagsm(start:end-stop),'k');
axis([1 tend 0 max(svagsm)])