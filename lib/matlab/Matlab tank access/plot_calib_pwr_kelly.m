% use this script to plot the power spectrum of a wave file

clear all;
addpath C:\matlab\classes\
addpath C:\matlab\'Matlab tank access'\
myTank = 'vacuum_calib';
myBlock = 'Block-3';
save_path = 'C:\Documents and Settings\Sepehr\My Documents\MATLAB\mic_calibration_data\white_noise_tests\';

% create the TTank object
TTX = actxcontrol('TTank.X');

% connect to the server
TTX.ConnectServer('Local', 'Me');

% Open the tank
TTX.OpenTank(myTank, 'R');

% select the desired block
TTX.SelectBlock(myBlock);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the waveform in that block
wave = TTX.ReadWavesV('Wave');

% channel 1 is the input to the microphone
mic_input_exp   = wave(:,1);
% fsamp = 97656.25; 
fsamp = 24414.0625;
 
 % take seconds 1 to 3
mic_input_exp = mic_input_exp(fix(1*fsamp):fix(4*fsamp));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close the tank
TTX.CloseTank
% release the server
TTX.ReleaseServer

% Make a figure of power spectrum using the overlap and average method by Welch.
% Note that the periodogram method does not work with variable windows.

figure(3);
nwindow = 1024;
Hs = spectrum.welch('Hann', nwindow, 50);
Hpsd = psd(Hs,mic_input_exp,'Fs',fsamp, 'NFFT', nwindow*2);

% Calibrate it
% The 130.4 number was obtained in TDT using the calibration using the
% SPLMeter RPV code.

powerlin = Hpsd.data.*power(10, 130.4/10);
powerdb = 10*log10(powerlin);

plot(Hpsd.Frequencies, powerdb);
xlabel('Freq Hz');
ylabel('Power dB SPL/Hz');
title(sprintf('Total Pow %.2f dB SPL', 10*log10(Hpsd.Frequencies(2).*sum(powerlin))));

