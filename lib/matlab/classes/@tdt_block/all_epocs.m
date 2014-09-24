function e = all_epocs(b)

% Retrieve all epoc names for a block

global ttank

enames = epoc_names(b);
n_epocs = length(enames);
e = cell(size(enames));

% Get data for all epocs
access(b);
for jj = 1:n_epocs
    e{jj} = epocs(b,enames{jj});
end