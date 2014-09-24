function bird_id = db_find(b)

% Get index of bird in database

mysql('use birds');
sql_cmd = sprintf('SELECT bird_id FROM birds WHERE bandnumber = %s;',...
    sql_str(b));
result = mysql(sql_cmd);
bird_id = [result.bird_id];