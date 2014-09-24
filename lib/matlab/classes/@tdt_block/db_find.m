function tdt_block_id = db_find(b)

% Get index of tank in database

mysql('use tdt_data');
sql_cmd = sprintf(['SELECT tdt_block_id ',...
    'FROM blocks NATURAL JOIN tanks ',...
    'WHERE tank_name = ''%s'' AND block_name = ''%s'';'],...
    b.tank.name,b.name);
result = mysql(sql_cmd);
tdt_block_id = [result.tdt_block_id];