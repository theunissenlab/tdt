function e = epoc_names(b)

% Retrieve all epoc names for a block

global ttank
access(b);

% Look up epoc names
max_n_epocs = 1000;
e = cell(1,max_n_epocs);
for jj = 1:max_n_epocs
    e{jj} = ttank.GetEpocCode(jj-1);
    if isempty(e{jj})
        ttank.ReleaseServer;
        break
    end
end

e = {e{1:jj-1}};