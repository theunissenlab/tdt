% This script reads data from the tank, then saves the spikes as a .mat
% file

% Set my default tank and block, yg0101 cell 4 STRF1
tanknum = 4;
blocknum = 6;

% Get the data out of the tank
errflag = 0;
extract_events_script;

% Define and create the output directory according to cal_data convention
outpath = 'C:\Documents and Settings\Latemodel\My Documents\Grad School\Theunissen Lab\data files\';
birdname = tankname;

%I need to write this function... for now just use filler value
%[cellnum,stimset] = parse_blockname(blockname);
cellname = '4_A';
stimset = 'STRF1';

outdir = fullfile(outpath,birdname,cellname,stimset,filesep);
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

% For now, good housekeeping demands releasing the activex server
release(ttank);