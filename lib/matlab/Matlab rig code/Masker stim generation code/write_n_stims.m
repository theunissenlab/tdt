function write_n_stims(Outfiles,n_stims)

fid = fopen(Outfiles.nstims,'w');
fwrite(fid,n_stims,'int32');
fclose(fid);

end