% use this script to normalize and filter songs
% Use this script to read a series of .wav files in a a given path and filter them and
% rescale them using songfilt.m
clear all
close all
%stim_path = 'C:\song_data\CD sans titre (D)\MALES\';
%save_path = 'C:\song_data\filtered_calls_nicholas\MALES\';

stim_path = 'F:\Work\Theunissen\Calls and songs\GrayGray0201_N21Mom\Calls\';
save_path = 'F:\Work\Theunissen\Calls and songs\GrayGray0201_N21Mom\Calls\filtered\';

stim_files = dir(fullfile(stim_path,'*.wav'));

for stim_ind = 1:length(stim_files)
    disp(['Stim num = ', num2str(stim_ind), '  - file name : ',stim_files(stim_ind).name]);
    [song,Fs,bits] = wavread([stim_path, stim_files(stim_ind).name]);
    new_song = songfilt(song, Fs, '','','');
    wavwrite(new_song,Fs,[save_path, stim_files(stim_ind).name]);
end