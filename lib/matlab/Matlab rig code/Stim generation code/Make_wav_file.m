% This script makes the .wav stimfiles for the experiment.
% It takes two groups of file for input: files for searching,
% and files for STRFing
%
% Modified 3/7/07 RCM:
%   Fixed nstims off-by-two error
%
% Modified 7/23/09 RCM:
% 	Added stub for intracellular hash sequence generation
%	Trying to change the dir() call to be more sensible by requiring file
%		names to be of form '*.wav'

input_dir = pwd;
%===============================================================
% Input and output file handling
%===============================================================

[Outfile,Stims] = load_protocol(input_dir);

%=============================================================================
% Check how many stimulus sets there actually are
%=============================================================================

nStimSets = 0;

for stim_idx = 1:len(Stims)
    if exist(Stims(stim_idx).dir,'dir')
        nStimSets = nStimSets + 1;
    end
end

%=============================================================================
% Fetch the file names for these protocols
%=============================================================================

% Go to these directories and get the files
% Modified 7/23/09 to eliminate the n+2 dir problem RCM
nfiles = 0;
for jj = 1:nStimSets
    Stims(jj).files = dir(fullfile(Stims(jj).dir,'*.wav'));
    Stims(jj).nfiles = length(Stims(jj).files);
    Stims(jj).hashfile = fullfile(pwd,strcat(Stims(jj).name,'seqhash.f32'));
    nfiles = nfiles + Stims(jj).nfiles;
end

%===============================================================
% Read in wav files, resample and save.
%===============================================================

[wavfile,pts,StimSet_nStims] = load_wavs(Stims);

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
    %elseif Stims(jj).randomtype == 2	%Intracellular style, some stims repeated more
    	%hash_sequence2(Stims(jj).hashfile,Stims(jj).nfiles,nrepeats,offset)
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