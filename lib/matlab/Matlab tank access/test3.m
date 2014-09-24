% Test the add_block_to_db script

cell_data = [];

for jj = 2:nblocks
    blockname = blocknames{jj}.name;
    
    % For the first cell, start fresh
    try
        [cell_data,msg] = add_block_to_db(cell_data,tankname,blockname);
    catch
        err = lasterror;
        %disp(err.message);
    end
end