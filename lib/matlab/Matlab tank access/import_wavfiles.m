% Script to read a .wav file and convert it to a spectrogram

% Default to using stimulus #1
%if ~exist(stimnum)
%    stimnum = 1;
%end

% For the rig, something should go here to read the .wav filename from the
% file

% Instead, let's read in from a directory on my laptop where I've saved
% them
stimdir = 'C:\Documents and Settings\Latemodel\My Documents\Grad School\Theunissen lab\Stims\fMRI stims\STRF1';
wavfiles = dir(fullfile(stimdir,'*.wav'));
nfiles = length(wavfiles);

% Read in the wav files, convert to spectrograms, and save them
for jj = 1:nfiles
    [wavfiles(jj).path,wavfiles(jj).stimname] = fileparts(wavfiles(jj).name);
    
    filename = fullfile(stimdir,wavfiles(jj).name);
    disp(sprintf('Reading file %s',wavfiles(jj).name));
    [wav,Fs] = wavread(filename);
    
    disp('Calculating spectrum')
    [outSpectrum,stim_length] = wav2spectrogram(wav,Fs);
    
    filename = fullfile(stimdir,strcat(wavfiles(jj).stimname,'.mat'));
    wavfiles(jj).specfilename = strcat(wavfiles(jj).stimname,'.mat');
    disp(sprintf('Writing file %s',wavfiles(jj).specfilename));
    save(filename,'outSpectrum','stim_length');
    clear wav Fs outSpectrum stim_length
end

