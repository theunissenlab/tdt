function write_protocol_file(file_name,stim_list,stim_group);

%% Write a digested protocol file from the lists

% Open file
fid = fopen(file_name,'a');

% Write data for each file
for jj = 1:length(stim_list)
    f = stim_list(jj);
    fprintf(fid,'%s\t',f.name);
    fprintf(fid,'%s\t',f.md5);
    fprintf(fid,'%s\t',stim_group);
    fprintf(fid,'%0.0f\t',jj);
    fprintf(fid,'%s\t',f.out_name);
    fprintf(fid,'%s\n',f.out_md5);
end

fclose(fid);