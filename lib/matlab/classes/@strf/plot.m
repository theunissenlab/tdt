function H = plot(h)
%% PLOT function for strf

%% Load data from files
% Load from strf file
strf_data = load(h.file,'strf');
[nb,nt] = size(strf_data.strf);

% load from params file
f = load(h.paramsfile,'initialFreq','endFreq');
a = load(h.paramsfile,'ampsamprate');

% Sometimes ampsamprate is missing from params file; if so, use 1kHz
if length(fieldnames(a)) < 1
    a.ampsamprate = 1000;
end

%% Compute plot parameter
% Color axis
maxC = max(max(strf_data.strf));
minC = min(min(strf_data.strf));
absC = max(abs(minC),abs(maxC));

% Time axis
t = -(nt-1)/2:(nt-1)/2;
t = t*ceil(1000/a.ampsamprate);

% Frequency axis
fstep = (f.endFreq - f.initialFreq)/nb;
faxis = f.initialFreq:fstep:f.endFreq;

%% Plot
H = imagesc(t,faxis/1000,strf_data.strf,[-absC absC]);
axis xy;
xlabel('Time (ms)');
ylabel('Frequency (kHz)');
title('STRF');