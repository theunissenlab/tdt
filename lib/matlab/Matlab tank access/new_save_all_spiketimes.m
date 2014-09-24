% This is the main script for extracting spike arrival times from a tank.
% It will save all the useful spiketime files for a given tank number.

%========================================================================
% Access the tank on the tank server
%========================================================================

% Create the ActiveX control
Open_TTank;

% Get the tank names
[tanknames,ntanks] = get_tanknames(ttank);

% For now, just access tank #4, yg0101
%tanknum = 2;
tankname = tanknames{tanknum}.name;

%========================================================================
% Some useful variables
%========================================================================

% Define the output directory according to cal_data convention
outpath = 'C:\Documents and Settings\Latemodel\My Documents\Grad School\Theunissen Lab\data files\';
errflag = 0;    %Skip blocks with uneven trial numbers
birdname = tankname;
Fs = 1000;

global birdname Fs

%========================================================================
% Extract data from each block
%========================================================================

% Get the blocknames from the server
[blocknames,nblocks] = get_blocknames(ttank,tankname);

% This will index only the good blocks
goodblocknum = 1;

% Loop over all blocknames
for blocknum = 1:nblocks
    if strncmpi(blocknames{blocknum}.name,'cell',4)   %Make sure this is actually a cell
        
        % Parse and save the blockname
        blockname = blocknames{blocknum}.name;
        [cellname,depth,stimset] = parse_blockname(blockname);
        goodblocks(goodblocknum).blockidx = blocknum;
        goodblocks(goodblocknum).cellname = cellname;
        goodblocks(goodblocknum).depth = depth;
        goodblocks(goodblocknum).stimset = stimset;
        maxsweep = num_sweeps(stimset);         %This is a hack to tell us how many sweeps to expect
        
        % Show what block is being processed
        disp(sprintf('Now processing cell %s depth %s %s',cellname,depth,stimset));
        
        % Access the block and get the epoc data
        % 'msg' is an error flag to tell us if each stim has the same
        % number of trials
        [nstims,ntrials,msg,stim_indices,stim_epocs,silence_epocs] = ...
            get_blockdata(ttank,tankname,blockname,maxsweep);
        
        %% Get spikes from server and zero them
        %stim_times = cal_stimlengths(stim_epocs,nstims,ntrials);        %Get the lengths, start and end times for each trial           
        
        % Save the spikes from the block
        % (but only if all stims have the same number of trials)
        if isempty(msg)
            
            % Create output directory
            outdir = fullfile(outpath,birdname,cellname,stimset,filesep);
            fiatdir(outdir);
            
            % Sort the trials by stimulus and record start/end time for
            % each trial. 
            stim_times = cal_stimlengths(stim_epocs,nstims,ntrials);        %Get the lengths, start and end times for each trial           

            % Get spikes from server and zero them
            %spikedata = extract_spikes(ttank,tankname,blockname,...      %Get spikes off server
            %    nstims,ntrials,stim_indices);
            spikedata = time_extract_spikes(ttank,tankname,blockname,...      %Get spikes off server, using times instead of TTank filtering
                nstims,ntrials,stim_times);
            
            % Get background rate data from server
            [background_rates,spikedata] = cal_background_rates(actxname,tankname,...
                blockname,nstims,ntrials,silence_epocs,channels,sortcodes);

            zspikedata = zero_spiketimes(spikedata,stim_times);     %Ref. spiketimes for each trial to trial start
            save_psth_script;
        else
            disp(sprintf('Skipping this block because %s',msg));
        end
        
        goodblocknum = goodblocknum+1;
    end
end

release(ttank);