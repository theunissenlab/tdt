clear all
close all

addpath C:\matlab\classes\
addpath C:\matlab\'Matlab tank access'\

myTank = 'micro_calib_exp_mic';

myBlock = 'freq_exp_mic_test1'; % use this for all frequencies
%myBlock = 'test_freq_250_1000_test'; % use this for 1kHz test

%First instantiate a variable for the ActiveX wrapper interface
Open_TTank;
t = tank(myTank);
access_tank(t);
ttank.OpenTank(myTank,'R');

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
title('SPL vs. Freq for experimental mic');

% close the tank
ttank.CloseTank

% release the server
ttank.ReleaseServer

%close all