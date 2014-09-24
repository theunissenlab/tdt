function dlm_opensorter(t,out_dir,verbose)

% Save all opensorter sorts for a block

global ttank

if nargin < 3
    verbose = 0;
end

%% Set up

% Retrieve info for all blocks
blocks = tdt_blocks(t);
nblocks = length(blocks);

% Display tank name
if verbose
    disp(sprintf('%s:',t.name));
end

% Make directory
fiatdir([out_dir filesep]);

%% Extract spikes
for jj = 1:nblocks
    b = blocks{jj};
    if verbose
        disp(sprintf('\t%s',b.name));
    end
    
    file_pattern = [b.name ' %s spikes.txt'];
    dlm_opensorter(b,out_dir,file_pattern,verbose);
end