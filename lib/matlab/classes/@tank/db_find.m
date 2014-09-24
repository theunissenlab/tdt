function tank_id = db_find(t)

% Get index of tank in database

mysql('use tdt_data');
sql_cmd = sprintf('SELECT tank_id FROM tanks WHERE tank_name = ''%s'';',...
    t.name);
result = mysql(sql_cmd);
tank_id = [result.tank_id];