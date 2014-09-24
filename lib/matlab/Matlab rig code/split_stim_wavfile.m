function split_stim_wavfile(input_directory)
% Split big TDT stim.wav file into individual .wav files

%% Create filenames and check that they exist

% Create filenames
stimfile = fullfile(input_directory,'stim.wav');
startsfile = fullfile(input_directory,'WavPtsStart.txt');
ptsfile = fullfile(input_directory,'WavPts.txt');

% Check for existence
if ~exist(stimfile)
    error('file %s does not exist',stimfile)
end
if ~exist(startsfile)
    error('file %s does not exist',startsfile)
end
if ~exist(ptsfile)
    error('file %s does not exist',ptsfile)
end

%% Read data from files

% Read wav file
[y,fs,nbits] = wavread(stimfile);

% Read points files but skip first line
wav_starts = dlmread(startsfile,'\n',1,0);
wav_pts = dlmread(ptsfile,'\n',1,0);

% Sanity check
nfiles = length(wav_starts);
if length(wav_pts) ~= nfiles
    error('length of wav_pts and wav_pts_start files is not the same')
end

%% Chop the file up

% Create output directory
out_dir = fullfile(input_directory,'wavfiles');
mkdir(out_dir);
for jj = 1:nfiles
    
    % Create the output filename
    outfile_name = fullfile(out_dir,sprintf('stim%d.wav',jj));
    
    % Get range in the big file
    this_wav = [1:wav_pts(jj)] + wav_starts(jj);
    
    % Write this chunk to a wavfile
    wavwrite(y(this_wav),fs,nbits,outfile_name);
end