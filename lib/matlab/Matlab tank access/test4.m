% Test the add_block_to_db script

cell_data = [];

for jj = 2:ntanks
    tankname = tanknames{jj}.name;
    [blocknames,nblocks] = get_blocknames(actxname,tankname);

    for kk = 2:nblocks
        blockname = blocknames{kk}.name;

        try
            [cell_data,msg] = add_block_to_db(cell_data,tankname,blockname);
        catch
            %err = lasterror;
            %disp(err.message);
        end
    end
end