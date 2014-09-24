clear all
close all
addpath C:\matlab\classes\
addpath C:\matlab\'Matlab tank access'\
myTank = 'mic_calib_white_noise';
myBlock = 'wn_mic_calib_exp_filt_elimtest4';
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
spkr_output_exp = wave(:,2);
fsamp = 24414.06; 
 
 % take the first 4 seconds
mic_input_exp = mic_input_exp(1:fix(4*fsamp));
spkr_output_exp = spkr_output_exp(1:fix(4*fsamp));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save white_noise_exp_mic.mat   mic_input_exp    spkr_output_exp

% close the tank
TTX.CloseTank
% release the server
TTX.ReleaseServer

%close all

% Make a figure
% 1. First plot the waveforms
figure(10);
npts = length(mic_input_exp);
tpts = 0:npts-1;
tpts = tpts./fsamp;
rmsinput = std(mic_input_exp);
plot(tpts, mic_input_exp./rmsinput);

hold on;
rmsoutput = std(spkr_output_exp);
plot(tpts, spkr_output_exp./rmsoutput, 'r');
hold off;
title('Waveforms for experimental mic');
xlabel('time (sec)');
ylabel('Amp. (V)');



% 2. transfer function
% Now the tf estimate
h = figure(11);
tfestimate(mic_input_exp,spkr_output_exp,2048,[],[],fsamp);
title('Transfer function for new experimental mic');
saveas(h,[save_path,'tf_wn_exp_mic'], 'fig');
saveas(h,[save_path,'tf_wn_exp_mic'], 'pdf');
saveas(h,[save_path,'tf_wn_exp_mic'], 'eps');

% 3. coherence
h = figure(12);
mscohere(mic_input_exp,spkr_output_exp,2048,[],[],fsamp);
title('Coherence function for new experimental mic');
saveas(h,[save_path,'coh_wn_exp_mic'], 'fig');
saveas(h,[save_path,'coh_wn_exp_mic'], 'pdf');
saveas(h,[save_path,'coh_wn_exp_mic'], 'eps');

% 4. cross-correlation
h = figure(15);
[c lags] = xcorr(mic_input_exp,spkr_output_exp, fix(0.1*fsamp));
plot(lags/fsamp, c);
title('Cross-correlation functiopn for new experimental mic');
saveas(h,[save_path,'xcorr_wn_exp_mic'], 'fig');
saveas(h,[save_path,'xcorr_wn_exp_mic'], 'pdf');
saveas(h,[save_path,'xcorr_wn_exp_mic'], 'eps');