function tdt_block_id = db_insert(b)

% Insert tdt_block data into database

%% Check to see if the block exists in the database
tdt_block_id = db_find(b);

if tdt_block_id
    error('SQL:Insert',...
        'Block is already present in database with block_id = %0.0f',...
        tdt_block_id);

%% Otherwise insert it
else
    % Insert tank into database if it's not there already
    tank_id = db_find(b.tank);
    if isempty(tank_id)
        db_insert(b.tank);
    end
    
    % Insert block data
    mysql('use tdt_data');
    sql_cmd = sprintf(['INSERT INTO blocks ',...
        '(block_name,tank_id,starttime,endtime) ',...
        'SELECT ''%s'',tank_id,%s,%s ',...
        'FROM tanks WHERE tank_name = ''%s'';'],...
        b.name,sql_str(b.starttime),sql_str(b.endtime),b.tank.name);
    mysql(sql_cmd);
end