function [Stims,stim_list,masker_list] = make_wav_files(Outfiles,Stims,...
                                                        songfilt_args)
                                                        
% Defaults for songfilt arguments
if nargin < 3
    songfilt_args.f_low = 250;
    songfilt_args.f_high = 8000;
    songfilt_args.db_att = 0;
end

% Compile stims and maskers into lists
[stim_list,masker_list,Stims] = list_files(Stims);

% Write lists to wav files and index files
[outdir,stim_prefix,wavext] = fileparts(Outfiles.stimwav);
stim_list = write_wav_file(Outfiles.stimwav,stim_list,stim_prefix,...
                           songfilt_args);

[outdir,mask_prefix,wavext] = fileparts(Outfiles.maskwav);
masker_list = write_wav_file(Outfiles.maskwav,masker_list,mask_prefix,...
                             songfilt_args);

% Write protocol file
write_protocol_file(Outfiles.protocol,stim_list,'stim');
write_protocol_file(Outfiles.protocol,masker_list,'masker');