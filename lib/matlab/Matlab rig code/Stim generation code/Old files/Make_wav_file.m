% This script makes the .wav stimfiles for the experiment.
% It takes two groups of file for input: files for searching,
% and files for STRFing

%===============================================================
% Input and output file handling
%===============================================================

% The routine gets the files from two subdirectories of the pwd
%nStimSets = 4;

clear Stims;

% The search files are found in directory 'srch'
Stims(1).dir = fullfile(pwd,'srch');
Stims(1).name = 'srch';
Stims(1).randomtype = 0;
Stims(1).stimset = 0;

% The STRF1 files are found in directory 'STRF1'
Stims(2).dir = fullfile(pwd,'STRF1');
Stims(2).name = 'STRF1';
Stims(2).randomtype = 1;
Stims(2).stimset = 1;

% The STRF2 files are found in directory 'STRF2'
Stims(3).dir = fullfile(pwd,'STRF2');
Stims(3).name = 'STRF2';
Stims(3).randomtype = 1;
Stims(3).stimset = 1;

% The STRF3 files are found in directory 'STRF3'
Stims(4).dir = fullfile(pwd,'STRF3');
Stims(4).name = 'STRF3';
Stims(4).randomtype = 1;
Stims(4).stimset = 1;

% Check how many stimulus sets there actually are
nStim_Sets = 0;
if exist('srch','dir')
    nStim_Sets = nStim_Sets + 1;
end

for jj = 1:3
    if exist(['STRF' num2str(jj)],'dir')
        nStim_Sets = nStim_Sets + 1;
    end
end

nStimSets = 2;
% Go to these directories and get the files
nfiles = 0;
for jj = 1:nStimSets
    Stims(jj).files = dir(Stims(jj).dir);
    Stims(jj).nfiles = length(Stims(jj).files)-2;
    Stims(jj).hashfile = fullfile(pwd,strcat(Stims(jj).name,'seqhash.f32'));
    nfiles = nfiles + Stims(jj).nfiles;
end
    
% The routine writes output to the following files:
Outfile.filenames = fullfile(pwd,'stimfilenames.txt');
Outfile.wav = fullfile(pwd,'stim.wav');
Outfile.wavpts = fullfile(pwd,'WavPts.txt');
Outfile.wavptsstart = fullfile(pwd,'WavPtsStart.txt');
Outfile.nstims = fullfile(pwd,'nStims.F32');

%===============================================================
% Read in wav files, resample and save.
%===============================================================

wavfile=[];
pts = [];
StimSet_nStims =[];

% Read each wav, change the sampling frequency to the rate
% used by the TDT program (24414.0625 Hz), get the length of each wav,
% and put all the waves together one after the other in one file.
% Set RMS levels to 0.3
for jj = 1:nStimSets
    for kk=3:Stims(jj).nfiles+2
        [y,Fs,bits] = wavread(fullfile(Stims(jj).dir,Stims(jj).files(kk).name));
        [p,q] = rat(24414.0625/Fs,0.0000001);
        samplerate = p/q*Fs;
        y = resample(y,p,q);        %Downsample to 24.424kHz
        rmslev = std(y);            %Compute RMS level
        y = 0.05*y/rmslev;          %Rescale so RMS is 0.05 of max (i.e. 1)
        
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

% Write the number of files in each stimulus set to the nStims file.

fid = fopen(Outfile.nstims,'w');
fwrite(fid,StimSet_nStims,'float32');
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

% If there are less than 3 STRF sets, we will need hash files named
% appropriately to make the TDT system happy

if nStimSets < 4
    for jj = 1+nStimSets:4
        Stims(jj).hashfile = fullfile(pwd,strcat(Stims(jj).name,'seqhash.f32'));
        copyfile(Stims(2).hashfile,Stims(jj).hashfile);
    end
end