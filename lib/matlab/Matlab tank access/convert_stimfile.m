function convert_stimfile(stim_dir,stim_file,wavptsstart_file)

%

starts_filename = fullfile(stim_dir,wavptsstart_file);
stim_filename = fullfile(stim_dir,stim_file);

starts = dlmread(starts_filename,',',1,0);
nstims = length(starts);

[wav,fs] = wavread(stim_filename);
% Kludge to generate an end index for the last file
starts(nstims+1) = length(wav);

for stim_idx = 1:nstims
    out_file = sprintf('stim%i.wav',stim_idx);
    outfilename = fullfile(stim_dir,out_file);
    start = starts(stim_idx)+1;
    stop = starts(stim_idx+1);
    wavwrite(wav(start:stop),fs,outfilename);
end
    