[wavfile,pts,StimSet_nStims] = load_wavs(Stims,nStimSets);

% Read in wav data from Stims data structure

wavfile=[];
pts = [];
StimSet_nStims =[];

% Read each wav, change the sampling frequency to the rate
% used by the TDT program (24414.0625 Hz), get the length of each wav,
% and put all the waves together one after the other in one file.
% Set RMS levels to 0.3
for jj = 1:nStimSets
    for kk=1:Stims(jj).nfiles
        [y,Fs,bits] = wavread(fullfile(Stims(jj).dir,Stims(jj).files(kk).name));
        rms_start = std(y);
        [p,q] = rat(24414.0625/Fs,0.0000001);
        samplerate = p/q*Fs;
        y = resample(y,p,q);        %Downsample to 24.424kHz
        rmslev = std(y);            %Compute RMS level
%        y = 0.05*y/rmslev;          %Rescale so RMS is 0.05 of max (i.e. 1)
        y = y*(rms_start/rmslev);
        
        % In songfilt we fit 3 rms (but with silence deleted) rms in +- 1 but
        % channing fitted 20 rms in +-1 - the next line would make it from
        % frederic liberal way to channing conservative way of looking at
        % things...
        y = y*3/20; 
        if max(abs(y)) > 1
            y = y/(max(abs(y))*1.01);
            disp(['Rescaled stimulus "' Stims(jj).files(kk).name '" since it had too high an amplitude when resampled and scaled.']);
        end
        maxnew = max(y);
        minnew = min(y);
        pts = [pts,size(y,1)];
        wavfile=cat(1,wavfile,y);
        
        fprintf('%s\n', Stims(jj).files(kk).name)
        if maxnew > 1.0 | minnew < -1.0
            fprintf('Clipping: Max = %5.2f Min = %5.2f  \r', maxnew, minnew) 
        end
    end
    StimSet_nStims = [StimSet_nStims,Stims(jj).nfiles];
end

% Append duplicate entries to StimSet_nStims so that it has entries for
% duplicated protocols to fill the buffer
n_duplicate_stimsets = 4-nStimSets;
StimSet_nStims = [StimSet_nStims,repmat(StimSet_nStims(2),1,n_duplicate_stimsets)];

%In the TDT program the buffer for the combined wav file
%must be at least as big as wavsize
wavsize=size(wavfile,1);
fprintf('\r Size of the combined wav file is %u \n \r', wavsize);

%Write the combined wav file and clear up some memory
wavwrite(wavfile,samplerate,bits,Outfile.wav);
clear wavfile y;