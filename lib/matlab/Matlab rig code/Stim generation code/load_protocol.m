function [Outfile,Stims] = load_protocol_dir(input_dir)

% The routine gets the files from two subdirectories of the input_dir
%nStimSets = 4;

clear Stims;

% The search files are found in directory 'srch'
Stims(1).dir = fullfile(input_dir,'srch');
Stims(1).name = 'srch';
Stims(1).randomtype = 0;
Stims(1).stimset = 0;

% The STRF1 files are found in directory 'STRF1'
Stims(2).dir = fullfile(input_dir,'P1');
Stims(2).name = 'P1';
Stims(2).randomtype = 1;
Stims(2).stimset = 1;

% The STRF2 files are found in directory 'STRF2'
Stims(3).dir = fullfile(input_dir,'P2');
Stims(3).name = 'P2';
Stims(3).randomtype = 1;
Stims(3).stimset = 1;

% The STRF3 files are found in directory 'STRF3'
Stims(4).dir = fullfile(input_dir,'P3');
Stims(4).name = 'P3';
Stims(4).randomtype = 1;
Stims(4).stimset = 1;

% The routine writes output to the following files:
Outfile.filenames = fullfile(input_dir,'stimfilenames.txt');
Outfile.wav = fullfile(input_dir,'stim.wav');
Outfile.wavpts = fullfile(input_dir,'WavPts.txt');
Outfile.wavptsstart = fullfile(input_dir,'WavPtsStart.txt');
Outfile.nstims = fullfile(input_dir,'nStims.F32');