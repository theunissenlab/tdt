%clear all
%close all

addpath C:\matlab\classes\
addpath C:\matlab\'Matlab tank access'\

myTank = 'microphone_calib';

myBlock = 'final_calib_test_perc_mic'; % use this for all frequencies
% myBlock = 'freq_test52'; % use thius for 1 kHz tone

%First instantiate a variable for the ActiveX wrapper interface
%Open_TTank;
t = tank(myTank);
% access_tank(t);
%ttank.OpenTank(myTank,'R');
tbks = tdt_blocks(t)

% create a block object
tblocks = tdt_block(myBlock,t);
% create epocs opbject from the Freq and Pwr_ data/value pair
freq = epocs(tblocks,'Freq');
spl = epocs(tblocks,'Pwr_');
freq_values = freq.value;
spl_values = spl.value;
freq_range = unique(freq_values); 

spl_ave = [];
std_error = [];

for i=1:length(freq_range)
    freq_ind = find(freq_values == freq_range(i));
    spl_ave(end+1) = mean(spl_values((freq_ind)));
    std_error(end+1) = std(spl_values((freq_ind)));
end

figure; 
errorbar(freq_range, spl_ave, std_error);
xlim([0 max(freq.value)+100]);
ylim([min(spl_ave)-1  max(round(spl_ave))+1]);
xlabel('Frequency (Hz)')
ylabel('dB SPL');
title('SPL vs. Freq for precision mic');

% close the tank
ttank.CloseTank
% release the server
ttank.ReleaseServer

%close all