function [block_already_in_db,block_index] = check_db_for_block(cell_data,tankname,...
    blockname)

% Check if a block is already in the database

ncells = length(cell_data);

% Get a list of all block/tank name pairs
existing_blocknames = {};
existing_tanknames = {};
for cell_idx = 1:ncells
    nblocks = cell_data(cell_idx).nblocks;
    existing_blocknames = vertcat(existing_blocknames,...
        {cell_data(cell_idx).block.name}');
    existing_tanknames = vertcat(existing_tanknames,...
        {cell_data(cell_idx).block.name}');
end

blockname_match = strcmp(existing_blocknames,blockname);
tankname_match = strcmp(existing_tanknames,tankname);
match = blockname_match & tankname_match;

block_already_in_db = any(match);
block_index = find(match);