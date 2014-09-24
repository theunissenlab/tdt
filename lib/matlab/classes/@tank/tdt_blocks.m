function blocks = tdt_blocks(t)

% Get all blocks for one tank

global ttank;

max_nblocks = 200;
blocks = cell(1,max_nblocks);
access(t);
ttank.QueryBlockName(0);

for jj = 1:max_nblocks
    % N.b. the current documentation states that QueryBlockName is
    % zero-based; this does not appear to be true
    % 7/27/09 RCM
    blockname = ttank.QueryBlockName(jj);
    if isempty(blockname)
        break
    else
        blocks{jj} = tdt_block(blockname,t);
        %blocks{jj} = ttank_times(blocks{jj});
    end
end
blocks = [blocks(1:jj-1)];

% Moved this out of the main loop 7/27/09 RCM
% It was causing problems with ttank.QueryBlockName; it looks like said
% function needs to be called sequentially from zero without any other
% calls being made to the server.
for jj = 1:length(blocks)
    blocks{jj} = ttank_times(blocks{jj});
end