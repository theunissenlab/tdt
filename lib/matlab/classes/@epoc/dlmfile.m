function dlmfile(e,filename,delimiter)

% Export epocs to a tab-delimited text file

if nargin < 3
    delimiter = '\t';
end

n_epocs = length(e(:).value);
out_data = zeros(n_epocs,3);
% dlmwrite(filename,reshape(e(:).value,n_epocs,1),...
%     'delimiter',delimiter,'precision','.0f');
% dlmwrite(filename,reshape(e(:).starttime,n_epocs,1),'-append',...
%     'delimiter',delimiter,'precision','%.8f','coffset',1);
% dlmwrite(filename,reshape(e(:).endtime,n_epocs,1),'-append',...
%     'delimiter',delimiter,'precision','%.8f','coffset',2);

out_data(:,1) = [e(:).value];
out_data(:,2) = [e(:).starttime];
out_data(:,3) = [e(:).endtime];
dlmwrite(filename,out_data,'delimiter',delimiter,'precision','%.8f')