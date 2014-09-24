% This script makes the .wav stimfiles for the experiment.
% It takes two groups of file for input: files for searching,
% and files for STRFing

%===============================================================
% Input and output file handling
%===============================================================

% The routine gets the files from two subdirectories of the pwd
nStimSets = 2;

% The STRF files are found in directory 'STRF1'
Stims(1).dir = fullfile(pwd,'STRF1');
Stims(1).name = 'STRF1';
Stims(1).randomtype = 1;
Stims(1).stimset = 1;

% The search files are found in directory 'srch'
Stims(2).dir = fullfile(pwd,'srch');
Stims(2).name = 'srch';
Stims(2).randomtype = 0;
Stims(2).stimset = 0;

% Go to these directories and get the files
nfiles = 0;
for jj = 1:nStimSets
    Stims(jj).files = dir(Stims(jj).dir);
    Stims(jj).nfiles = length(Stims(jj).files)-2;
    Stims(jj).hashfile = fullfile(pwd,strcat(Stims(jj).name,'seqhash.f32'));
    nfiles = nfiles + Stims(jj).nfiles;
end
    
% The routine writes out to the following files:
Outfile.filenames = fullfile(pwd,'stimfilenames.txt');
Outfile.wav = fullfile(pwd,'stim.wav');
Outfile.wavpts = fullfile(pwd,'WavPts.txt');
Outfile.wavptsstart = fullfile(pwd,'WavPtsStart.txt');

%===============================================================
% Read in wav files, resample and save.
%===============================================================

wavfile=[];
pts = [];

% Read each wav, change the sampling frequency to the rate
% used by the TDT program (24414.0625 Hz), get the length of each wav,
% and put all the waves together one after the other in one file.
for jj = 1:nStimSets
    for kk=3:Stims(jj).nfiles+2
        [y,Fs,bits] = wavread(fullfile(Stims(jj).dir,Stims(jj).files(kk).name));
        [p,q] = rat(24414.0625/Fs,0.0000001);
        samplerate = p/q*Fs;
        y = resample(y,p,q);
        maxnew = max(y);
        minnew = min(y);
        pts = [pts,size(y,1)];
        wavfile=cat(1,wavfile,y);
        
        fprintf('%s\n', Stims(jj).files(kk).name)
        if maxnew > 1.0 | minnew < -1.0
            fprintf('Clipping: Max = %5.2f Min = %5.2f  \r', maxnew, minnew) 
        end
    end
end

%In the TDT program the buffer for the combined wav file
%must be at least as big as wavsize
wavsize=size(wavfile,1);
fprintf('\r Size of the combined wav file is %u \n \r', wavsize);

%Write the combined wav file and clear up some memory
wavwrite(wavfile,samplerate,bits,Outfile.wav);
clear wavfile y;

%===============================================================
% Generate files to reference the position of each individual
% stimulus within the big wav file.
% The first value in each file is just a dummy value so that the
% TDT code can access data for the first file at buffer index 1.
%===============================================================

% Write the size of each stimulus to the WavPts file.

[fid,message] = fopen(Outfile.wavpts,'w');
    for ifiles=1:nfiles
        if ifiles == 1
            fprintf (fid, '%s\n', 'Dummy');
            fprintf (fid, '%u\n', pts(:,ifiles));
        else
         fprintf (fid, '%u\n', pts(:,ifiles));
        end
    end 
fclose(fid);         

% Write start point of each stimuls to the WavPtsStart file.

[fid,message] = fopen(Outfile.wavptsstart,'w');
WavPtsStart = 0;
for ifiles=1:nfiles 
    if ifiles == 1
        fprintf (fid, '%s\n', 'Dummy');
        fprintf (fid, '%u\n', WavPtsStart);
    else
        WavPtsStart = WavPtsStart + pts(:,(ifiles-1));  
        fprintf (fid, '%u\n', WavPtsStart);
    end
end 
fclose(fid); 

%===============================================================
% Write file with pathname for each wav starting with wav 1
%===============================================================

[fid,message] = fopen(Outfile.filenames,'w');
for jj=1:nStimSets
    for kk = 1:Stims(jj).nfiles
        fprintf (fid,'%s\n',fullfile(Stims(jj).dir,...
            Stims(jj).files(kk).name));
    end
end 
fclose(fid);

%===============================================================
% Generate hash tables for each set of stims
%===============================================================

nrepeats = 500;         %How many times to repeat each stim
offset = 0;             %Offset will be used to put stims in order

for jj = 1:nStimSets
    if Stims(jj).randomtype == 0        %Totally random string of stims
        [fid,message] = fopen(Stims(jj).hashfile,'w');
        hash = offset + ceil(Stims(jj).nfiles*rand(1,Stims(jj).nfiles*nrepeats));
        fwrite(fid,hash,'float32');
        fclose(fid);
    elseif Stims(jj).randomtype == 1    %All stims in nrepeats trials
        hash_sequence(Stims(jj).hashfile,Stims(jj).nfiles,nrepeats,offset);
    end
    
    %Increment offset for the next set
    offset = offset + Stims(jj).nfiles;
end