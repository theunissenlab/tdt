function write_n(outfile,n_var)

fid = fopen(outfile,'w');
fwrite(fid,n_var,'int32');
fclose(fid);

end