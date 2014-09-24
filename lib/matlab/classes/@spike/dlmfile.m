function dlmfile(s,filename,delimiter)

% Export epocs to a tab-delimited text file

%% Defaults
if nargin < 3
    delimiter = '\t';
end

%% Preallocate text-file output
n_spikes = length([s(:).time]);
out_data = zeros(n_spikes,4);

%% Save text file
out_data(:,1) = [s(:).time];
out_data(:,2) = [s(:).channel];
out_data(:,3) = [1:n_spikes];
out_data(:,4) = [s(:).sortcode];
%dlmwrite(filename,out_data,'delimiter',delimiter,'precision','%.8f')
fid = fopen(filename,'w');
fwrite(fid,sprintf('%.8f\t%d\t%d\t%d\n',out_data'));
fclose(fid);