function waveforms_file(s,filename)

% Export spike waveforms to a .f32 file

fid = fopen(filename,'w');
fwrite(fid,[s(:).waveform],'float32');
fclose(fid);