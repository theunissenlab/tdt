function tank_id = db_insert(t)

% Insert tank data into database

%% Check if the tank exists in the database
tank_id = db_find(t);

if tank_id
    error('SQL:Insert',...
        'Tank is already present in database with tank_id = %0.0f',tank_id)
else
    sql_cmd = sprintf(...
        ['INSERT INTO tanks (tank_name) VALUES(''%s'');'],t.name);
    mysql(sql_cmd);
end

tank_id = db_find(t);