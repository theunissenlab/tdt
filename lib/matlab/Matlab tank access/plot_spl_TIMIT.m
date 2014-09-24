% use this script to plot the power spectrum of a wave file

clear all;
addpath C:\matlab\classes\
addpath C:\matlab\'Matlab tank access'\
myTank = 'C:\TDT\OpenEx\Tanks\EcogTIMIT';


BlockNames = {'OldThinkPadRed', 'OldThinkPadTIMITBlue',...
                'NewDellTIMITRed', 'NewDellTIMITBlue', ...
                'NewThinkPadTIMITRed', 'NewThinkPadTIMITBlue' };


% create the TTank object
TTX = actxcontrol('TTank.X');

% connect to the server
TTX.ConnectServer('Local', 'Me');

% Open the tank
TTX.OpenTank(myTank, 'R');

% Loop through Blocks
nblocks = length(BlockNames);

for i=1:nblocks
    if (i == 4) 
        continue;
    end
% select the desired block
TTX.SelectBlock(BlockNames{i});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read the waveform in that block
wave = TTX.ReadWavesV('Wave');

% channel 1 is the input to the microphone
mic_input_exp   = wave(:,1);
SPL_Level = wave(:,2);
fsamp = 24414.0625;
 
figure(i+1);
tval = 1:length(wave);
tval = tval./fsamp;

subplot(2,1,1);
plot(tval, wave(:,1));
title(BlockNames{i});
subplot(2,1,2);
avgpower = mean(wave(find(wave(:,2)>65),2));
plot(tval, wave(:,2));
title(sprintf('Avg Power = %.2f dB SPL', avgpower));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close the tank
TTX.CloseTank
% release the server
TTX.ReleaseServer

% Make a figure of power spectrum using the overlap and average method by Welch.
% Note that the periodogram method does not work with variable windows.



