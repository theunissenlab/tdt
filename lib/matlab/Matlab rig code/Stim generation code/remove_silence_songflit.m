% use this script to remove the silence periods
clear all
close all
% Data path
stim_path = 'C:\song_data\CD sans titre (D)\FEMELLES\';

% Save path
save_path = 'C:\song_data\RG3_songs_unfiltered\';


stim_files = dir(fullfile(stim_path,'*.wav'));
files_revisit = {};

% load up the .wav files

for stim_ind = 1:length(stim_files)
    
    disp(['Stim num = ', num2str(stim_ind), '  - file name : ',stim_files(stim_ind).name]);
    [y,fs,nbits] = wavread([stim_path, stim_files(stim_ind).name]);
    figure(10); clf
    title(stim_files(stim_ind).name);
    hold on;
    plot(y);
    %break
    ind_zero = find(y == 0);
    nzeros = length(ind_zero);

    n = 4; % number of consecutive zeros - 1
    start_ind = length(y);
    for i = n+1:nzeros
        check_con_zeros = ind_zero(i)-ind_zero(i-n) - n;
        if (check_con_zeros == 0)
            start_ind = i-n;
            break;
        end
    end
    
    if start_ind==length(y); %if 4 consecutive zeros never appear
        newy=y; %use the entire length of the sound as the new sound
        disp('No silence found!');
    else
        newy = y(1:ind_zero(start_ind));
%     % plot the silence period to check
%     hold on;
%     plot([0 ind_zero(start_ind) ind_zero(start_ind) length(y)], [0 0 max(y) max(y)], 'r');

    end
    
%     % ask the user to approve removal of the silence period
%     reply = input('Do you want to save? Y/N [Y]: ', 's');
    reply='y';
    if strcmpi(reply, 'y')
       % save the new .wav file
       % before saving the shortened version of the file, please apply
       % songfilt to the files
       new_song = songfilt(newy, fs, '','','');
       wavwrite(new_song,fs,[save_path, stim_files(stim_ind).name]);       
    else
       % save the files the files that don't match 
       files_revisit{end+1} = stim_files(stim_ind).name; 
    end
%     pause;
    
end % for each .wav file


