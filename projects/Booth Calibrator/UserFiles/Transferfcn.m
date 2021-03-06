% Script to read in calibration data generated by BoothCal

% Some useful constants
Fs = 24414.0625;    %RP2.1 sampling rate of "26kHz"
in_filename = 'in4.f32';
out_filename = 'out4.f32';

% Read in the input and output data
infid = fopen(in_filename);
outfid = fopen(out_filename);
[input,countin] = fread(infid,inf,'float32');
[output,countout] = fread(outfid,inf,'float32');
fclose(infid);
fclose(outfid);

% Compute a transfer function
[Tio,freqs] = tfe(input,output,[],Fs);

% Convert the results to more useful scales, on roughly 200Hz - 8kHz
%lowf = find(freqs < 200,1,'last');
%highf = find(freqs >8000,1,'first');
lowf = 3; highf = 85;
plotfreqs = freqs(lowf:highf);
MagTf = 20*log10(abs(Tio(lowf:highf)));
PhsTf = unwrap(angle(Tio(lowf:highf)));


% Compute the group lag
[lag,bint,lagless] = regress(PhsTf,plotfreqs);
lagms = -lag*1000;

% Compute the spectral range and rms
RngTf = range(MagTf);
%RmsTf = norm(MagTf)/sqrt(length(MagTf));

% Output the results
figure;plot(plotfreqs,180*lagless/pi);
xlabel('Frequency (Hz)');ylabel('Phase (degrees)');
title('Phase Response');

figure;plot(plotfreqs,MagTf);
xlabel('Frequency (Hz)');ylabel('|H| (dB)');
title('Frequency Response');

disp(sprintf('Lag is %f ms',lagms));
disp(sprintf('Response varies by %f dB',RngTf));
%disp(sprintf('Response RMS is %f dB',RmsTf));