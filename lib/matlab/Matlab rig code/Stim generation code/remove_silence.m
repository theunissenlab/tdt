% use this script to remove the silence periods
clear all
close all
% Data path
stim_path = 'C:\song_data\RG3_calls\RG3_songs\unfiltered\';

% Save path
save_path = 'C:\song_data\RG3_calls\RG3_songs\filtered\';

%do you want to oversee the silence removal process?
oversee=0;

stim_files = dir(fullfile(stim_path,'*.wav'));
files_revisit = {};

% load up the .wav files
for stim_ind = 1:length(stim_files)
    
    disp(['Stim num = ', num2str(stim_ind), '  - file name : ',stim_files(stim_ind).name]);
    [y,Fs,nbits] = wavread([stim_path, stim_files(stim_ind).name]);
    figure(10); clf
    title(stim_files(stim_ind).name);
    hold on;
    xax=1/Fs:1/Fs:numel(y)/Fs;
    plot(xax,y');

    %number of consecutive zeros - 50ms (times sampling rate)
    n = 0.050*Fs;
    half_n=round(n/2);
    
    %robert added
    y2=y;
    %set all the zero points equal to 1000
    y2(y==0)=1000;
    %convolve the mic channel with a square pulse 
    y_conv=conv(y2,1000*ones(1,n))/(1000*n);
    y_conv=y_conv(half_n:end-half_n);
    %find a consecutive period of zeros of length n
    start_ind=find(y_conv==1000,1,'first')-half_n;
    plot(y);
    
    if isempty(start_ind) %if there's no silent period
        newy=y;
        disp('There was no silent period!');
    else %if there is a silent period
        newy = y(1:start_ind);
        hold on;
        plot([0 start_ind/Fs start_ind/Fs length(y)/Fs], [0 0 max(y) max(y)], 'r');
    end
    %/robert added
    
%     for i = n+1:nzeros
%         test(i-n) = ind_zero(i)-ind_zero(i-n) - n;
%     end
%     
%     % plot the silence period to check
%     start_ind = min(find(test `== 0));

    if oversee %if you want to check each wav file
    % ask the user to approve removal of the silence period
    reply = input('Do you want to save? Y/N [Y]: ', 's');
    else %if you don't want to check each wav file
        reply='Y';
    end
    
    if strcmpi(reply, 'y')
       % save the new .wav file
       % before saving the shortened version of the file, apply songfilt to the files
       new_song = songfilt(newy, Fs, '','','');
       wavwrite(new_song,Fs,[save_path, stim_files(stim_ind).name]);       
    else
       % save the files the files that don't match 
       files_revisit{end+1} = stim_files(stim_ind).name; 
    end

end % for each .wav file

