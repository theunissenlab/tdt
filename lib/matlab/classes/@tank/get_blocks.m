function blocks = get_blocks(tank)

% Get all blocks for one tank

global ttank;
[blocknames,nblocks] = get_blocknames(ttank,tank.tankname);
blocks = cell(1,nblocks};

for jj = 1:nblocks
    