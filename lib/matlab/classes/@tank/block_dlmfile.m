function block_dlmfile(t,out_dir,verbose)

% Save block metadata for all blocks in a tank to file

global ttank

if nargin < 3
    verbose = false;
end

%% Retrieve info for all blocks
blocks = tdt_blocks(t);
nblocks = length(blocks);
blockdata = cell(nblocks,4);

%% Display tank name
if verbose
    disp(sprintf('%s:',t.name));
end

%% Retrieve the start and end time for each block and save to file
fiatdir([out_dir filesep]);
outfilename = fullfile(out_dir,'blocks.txt');
fid = fopen(outfilename,'w');

for jj = 1:nblocks
    b = blocks{jj};
    fprintf(fid,'%s\t%s\t%s\t%s\n',t.name,b.name,...
        strrep(sql_str(b.starttime),'''',''),...
        strrep(sql_str(b.endtime),'''',''));
end

% %% Write data to file
% 
% for jj = 1:nblocks
%     fprintf(fid,'%s\t%s\t%s\t%s\n',blockdata{jj,:});
% end