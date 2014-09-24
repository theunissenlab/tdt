function dlm_opensorter(b,out_dir,file_pattern,verbose)

% Extract opensorter spike sort data

global ttank

if nargin < 4
    verbose = 0;
end

if nargin < 3
    file_pattern = [b.name ' %s spikes.txt'];
end

%% Get all sort names for this block

sortnames = sort_names(b);
n_sorts = length(sortnames);

for jj = 1:n_sorts

    sortname = sortnames{jj};
    spikefilename = fullfile(out_dir,sprintf(file_pattern,sortname));

    if verbose
        disp(sprintf('\t\tSaving OpenSorter spike sort to file %s...',spikefilename))
    end

    % Get spikes and save
    block_spikes = spikes(b,sortname);
    dlmfile(block_spikes,spikefilename);
    clear block_spikes
    if verbose
        disp(sprintf('\t\t\tdone'))
    end
end