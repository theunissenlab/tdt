function file_list = write_wav_file(file_name,file_list,file_prefix,...
                                    songfilt_args)

%% Write one .wav file from the files in file_list
% Includes resampling, rescaling, and writes index files as well.

%% Defaults & preprocessing

% Number of files
nfiles = length(file_list);

% Initialize vector for lengths
wav_points = zeros(1,nfiles);

% Initialize cell array for wav data
wav_data = cell(1,nfiles);

% Exact sampling frequency for the TDT
Fout = tdt25k;

% Directory to save the resampled, gated wavfiles
wav_outdir = 'wavfiles';

% Apply 10ms cosine ramp to apply to each end of the stims
ramp_dur = 10e-3;

% Directory for individual output files
[outpath,outfile,outext] = fileparts(file_name);
wav_path = fullfile(outpath,wav_outdir);
fiatdir(wav_path);

% Prefix for individual output files
if nargin < 3
    file_prefix = outfile;
end

if nargin < 4
    songfilt_args.f_low = 250;
    songfilt_args.f_high = 8000;
    songfilt_args.db_att = 0;
end

%% Read in all files

for jj = 1:nfiles
    
    % Read in file and display name
    infilename = file_list(jj).name;
    [path,filename,fileext] = fileparts(infilename);
    direc = regexp(path, '/' , 'split');
    directory = direc{end};
    TF=strcmp (directory,'wavfiles_Familiar_calls') || strcmp(directory,'wavefiles_Stranger_calls');
    
    [y,Fin,bits] = wavread(infilename);
    
    if TF~=1 %this step has already been done on calls in...
        %wavfiles_Familiar_call by running Process_wav_files_call.m
        
        %if y is a stereo file->converts to mono
        if length(y(1,:))>1
            y = (y(:,1)+ y(:,2))/2;
        end
        y = songfilt(y,Fin,songfilt_args.f_low,songfilt_args.f_high,...
                 songfilt_args.db_att);
        disp('running songfilt on');
        disp(infilename);

        % Resample
        [p,q] = rat(Fout/Fin,0.0000001);
        y = resample(y,p,q);        %Resample to TDT sampling rate (24.4140625kHz)
        
        % Apply 10ms cosine ramp to each end
        y = cosramp(y,ramp_dur * Fout);

        % Alert if there is any clipping
        maxnew = max(y);
        minnew = min(y);
        if (maxnew > 1.0) || (minnew < -1.0)
            disp(sprintf('Clipping: Max = %5.2f Min = %5.2f  \r',...
            maxnew,minnew));
        end
    end
    
    

    % Write file and metadata to Stims structure
    wav_data{jj} = y;
    wav_points(jj) = size(y,1);
    file_list(jj).md5 = file_md5hash(infilename);
    
    % Write individual stims to output dir
    wav_outfile = fullfile(wav_path,sprintf('%s%d.wav',file_prefix,jj));
    wavwrite(y,Fout,bits,wav_outfile);
    file_list(jj).out_name = wav_outfile;
    file_list(jj).out_md5 = file_md5hash(wav_outfile);
end

%% Write outputs

% Write combined .wav file
wav = vertcat(wav_data{:});
if length(wav) < 1
    wav = zeros(100,1);
end
wavwrite(wav,Fout,file_name);

% Write points file
file_lengths = [0 wav_points];
lengthfilename = fullfile(outpath,[outfile,'Pts.f32']);
fid = fopen(lengthfilename,'w');
fwrite(fid,file_lengths,'int32');
fclose(fid);

% Write starting points file
file_starts = [0 0 cumsum(wav_points(1:end-1))];
startsfilename = fullfile(outpath,[outfile,'PtsStart.f32']);
fid = fopen(startsfilename,'w');
fwrite(fid,file_starts,'int32');
fclose(fid);
