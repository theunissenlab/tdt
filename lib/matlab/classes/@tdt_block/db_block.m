function block_id = db_block(t)

%% Find the corresponding block for a tdt_block in the database

tdt_block_id = db_find(t);

mysql('use cells');
sql_cmd = sprintf(...
    'SELECT block_id FROM tdt_blocks WHERE tdt_block_id = %0.0f',...
    tdt_block_id);
result = mysql(sql_cmd);
block_id = result.block_id;