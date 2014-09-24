% second test script
blocknum = 9;
blockname = blocknames{blocknum}.name;
[cell_data,msg] = append_cell_info_to_db([],tankname,blockname);
blocknum = 10;
blockname = blocknames{blocknum}.name;
[cell_data,msg1,msg2] = append_block_info_to_cell(cell_data,tankname,blockname,1);