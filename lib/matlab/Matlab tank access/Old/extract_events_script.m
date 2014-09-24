% This script extracts spike times from the tank

% Specify tank # and block # to use
if ~exist('tanknum')
    tanknum = 2;
end
if ~exist('blocknum')
    blocknum = 3;
end

% Allow a maximum sweep number to be specified, defaulting to 50
if exist('maxsweep') ~=1
    maxsweep = 50;
end

Fs = 1000;

%===================================================================
% Access server and open specified tank and block
%===================================================================

% Connect to server
tank_access;

% Open tank specified by tanknum
[tanknames,ntanks] = get_tanknames(ttank);
tankname = tanknames{tanknum}.name;
if (invoke(ttank,'OpenTank',tankname,'R') ~=1)
    err = 'error opening tank'
end

% Open the block specified by blocknum
[blocknames,nblocks] = get_blocknames(ttank);
blockname = blocknames{blocknum}.name;
if (invoke(ttank,'SelectBlock',blockname) ~=1)
    err = 'error accessing block'
end

%===================================================================
% Extract all spikes for a given stimulus
%===================================================================

% Set the stimulus number to filter on
stimnum = 2;

% Filter the block for spikes to one stimulus
invoke(ttank,'ClearEpocIndexing');      %Just to be safe
invoke(ttank,'CreateEpocIndexing');     %Epoch indexing must be set before filtering
Sweep_nums = invoke(ttank,'GetEpocsV','Swep',0,0,maxsweep);
Stim_nums = invoke(ttank,'GetEpocsV','Frq+',0,0,maxsweep);

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

%===================================================================
% Close connection
%===================================================================

invoke(ttank,'ReleaseServer');