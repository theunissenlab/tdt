% This script makes the .wav stimfiles for the experiment.
% It runs for the 
   
data_files = { ...
      'C:/Sounds/fMRI sounds/grijs3_chain1_eq.wav' ...
      'C:/Sounds/fMRI sounds/grijs3_chain1_eq_rand.wav' ...
      'C:/Sounds/fMRI sounds/grijs3_chain1_eq_rev.wav' ...
      'C:/Sounds/fMRI sounds/grijs3_chain1_eq_ripple.wav' ...
      'C:/Sounds/fMRI sounds/noise.wav' ...
};



save_cd = pwd;
NumberOfFiles=0;

nfiles = length(data_files);
wavfile=[];

%Read each wav, change the sampling frequency to the rate
%used by the TDT program (24414.0625 Hz), get the length of each wav,
%and put all the waves together one after the other in one file.

for ifiles=1:nfiles
  
    [y,Fs,bits] = wavread(data_files{ifiles});
    [p,q] = rat(24414.0625/Fs,0.0000001);
    samplerate = p/q*Fs;
    y = resample(y,p,q);
    maxnew = max(y);
    minnew = min(y);  
    pts(:,ifiles) = size(y,1);
    wavfile=cat(1,wavfile,y);
         
    fprintf('%s\n', data_files{ifiles})
    if maxnew > 1.0 | minnew < -1.0
        fprintf('Clipping: Max = %5.2f Min = %5.2f  \r', maxnew, minnew) 
    end
    
    NumberOfFiles = NumberOfFiles + 1;  
end 
    
    fprintf('\r %u Wav Files \n', NumberOfFiles)

   %Write the size of each stimulus to the WavPts file.
   %The first value is just a dummy value.
   %I did that to save a processing step in the TDT program
   %that would have had to say go to value Wav#-1 instead of
   %just go to Wav# (which is how it is now).
    
   [fid,message] = fopen('C:/STIMS/WavPtsNew.txt','w');
    for ifiles=1:nfiles
        if ifiles == 1
            fprintf (fid, '%u\n', nfiles);
            fprintf (fid, '%u\n', pts(:,ifiles));
        else
         fprintf (fid, '%u\n', pts(:,ifiles));
        end
    end 
            fclose(fid);         
            
   %Write start point of each stimuls to the WavPtsStart file.
   %The first value is just a dummy value.
   %I did that to save a processing step in the TDT program
   %that would have had to say go to value Wav#-1 instead of
   %just go to Wav# (which is how it is now).
   
    [fid,message] = fopen('C:/STIMS/WavPtsStartNew.txt','w');
    WavPtsStart = 0;
    for ifiles=1:nfiles 
        if ifiles == 1
            fprintf (fid, '%u\n', nfiles);
            fprintf (fid, '%u\n', WavPtsStart);
        else
         WavPtsStart = WavPtsStart + pts(:,(ifiles-1));  
         fprintf (fid, '%u\n', WavPtsStart);
        end
    end 
            fclose(fid); 
    
   %Write file containing wav# for each wav.
   %This file will be used by (       ) to generate 500 trials
   %of each wav in pseuodo-random order (each stimulus must be played
   %for Trial X before any stimulus can be played for Trial X+1.
   %Currently things are set up in the TDT program for a max
   %of 100 stimuli by 500 Trials (50,000 Trials total).
   
    [fid,message] = fopen('C:/STIMS/Wav#.txt','w');
    for ifiles=1:nfiles 
         fprintf (fid, '%u\n', ifiles);
    end 
            fclose(fid);       
    %Write file with pathname for each wav starting with wav 1
    
    [fid,message] = fopen('C:/STIMS/WavPath.txt','w');
    for ifiles=1:nfiles 
         fprintf (fid, '%s\n', data_files{ifiles});
    end 
            fclose(fid);        
                   
            
    %In the TDT program the buffer for the combined wav file
    %must be at least as big as wavsize
    
    wavsize=size(wavfile,1);
    fprintf('\r Size of the combined wav file is %u \n \r', wavsize);
    
    %Writing the combined wav file
    
    wavwrite(wavfile,samplerate,bits,'C:/STIMS/test.wav');
    
   

cd(save_cd)

